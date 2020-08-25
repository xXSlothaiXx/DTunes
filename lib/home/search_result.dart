import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'player.dart';
import '../home/player.dart';
import '../api/Service.dart';
import '../api/Posting.dart';
import '../models/Songs.dart';
import '../models/Playlists.dart';

class SearchResult extends StatefulWidget {

  final query;

  SearchResult({Key key, @required this.query}) : super(key: key);


  @override
  _SearchResultState createState() => _SearchResultState(query);
}

class _SearchResultState extends State<SearchResult> {

  String HOSTNAME;

  bool is_loading = false;

  Posting _action = Posting(); 

    void hostNetwork() async {
      SharedPreferences  prefs = await SharedPreferences.getInstance();
      final network = prefs.getString("network"); 
      HOSTNAME = network; 

  }



  Container postCard(String image_value,  String heading, String artistname,  int pk){
    return Container(
      width: 300.0,
      height: 75.0,
      child: new GestureDetector(
          onTap: (){
            print("Pressed widget");
          },

          child: ListTile(
            onTap: (){
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayerPage(pk: pk)));
              });
            },
            leading:  Image.network(
              image_value,
              width:  MediaQuery.of(context).size.width * 0.2,
              height:  MediaQuery.of(context).size.height * 0.2,
              fit: BoxFit.fitWidth,
            ),
            title: Text(heading, maxLines: 2, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(artistname, style: TextStyle(color: Colors.grey),),
            trailing: IconButton(
              icon: Icon(
                Icons.playlist_add,
                color: Colors.red,
              ),
              onPressed: (){
                playlistSheet(pk);
              },
            ),
          )
      ),
    );
  }

  

  Container playlistView(int songid){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _playlists == null ? 0: _playlists.length,
        itemBuilder: (context, index){
          Playlists playlist = _playlists[index]; 
          return  ListTile(
            onTap: (){
              setState(() {
                //send request parameters song id, playlist id
                _action.addToPlaylist(songid, playlist.id);

              });

            },
            title: Text(playlist.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,)),
            leading: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 64,
                maxHeight: 64,
              ),
              child: Image.network('$HOSTNAME' + playlist.picture),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.red,
              ),
              onPressed: (){

              },
            ),
            subtitle: Text(playlist.datePosted.toString(), style: TextStyle(color: Colors.grey),),
          );
        },
      ),
    );
  }

  void playlistSheet(int songid){
    showModalBottomSheet(context: context, builder: (context){
      return Column(
        children: <Widget>[
          Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text('Your Playlists', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(
                    height: 10,
                  ),
                  playlistView(songid),

                ],
              ),
            ),
          )
        ],
      );
    });

  }

  List<Songs> _results; 
  List<Playlists> _playlists; 



  @override
  void initState() {
    
  

    Service.searchSongs(query).then((songs){
      setState(() {
        _results = songs; 
        print("LOADING IN NEW METHOD FAM"); 
      });
    }); 

    Service.getPlaylists().then((playlists){
      setState(() {
        _playlists = playlists; 
        print("LOADING IN NEW METHOD FAM"); 
      });
    });

     


  }

  String query;

  _SearchResultState(this.query);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Results for: ${query}'),
        backgroundColor: Colors.black87,
      ),
      body: ListView.builder(
          itemCount: _results == null ? 0: _results.length,
          itemBuilder: (context, index){
            Songs result = _results[index]; 
            return postCard( result.thumbnail, result.name, result.artistname, result.id);

          }
      ),
    );
  }
}