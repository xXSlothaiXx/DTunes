import '../../../home/artist_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/Service.dart';
import '../../../api/Posting.dart';
import '../../../models/Artists.dart';
import '../../../models/Playlists.dart';

class ArtistsPage extends StatefulWidget {

  @override
  _ArtistsPageState createState() => _ArtistsPageState();
}

class _ArtistsPageState extends State<ArtistsPage > {

  String HOST;

  Posting _action = Posting(); 

  setHost() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    final network = prefs.getString('network');

    setState(() {
      HOST = network;
      
    });
    
  }

  Container postCard(String image_value,  String name, int pk){
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
                    MaterialPageRoute(builder: (context) => ArtistPage(pk: pk)));
              });
            },
            leading:  Image.network(
              image_value,
              width:  MediaQuery.of(context).size.width * 0.2,
              height:  MediaQuery.of(context).size.height * 0.2,
              fit: BoxFit.fitWidth,
            ),
            title: Text(name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text("Artist", style: TextStyle(color: Colors.grey),),
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

  bool is_loading = false;
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
              child: Image.network('$HOST' + playlist.picture),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.red,
              ),
              onPressed: (){

              },
            ),
            subtitle: Text('Created: March 20th 2020', style: TextStyle(color: Colors.grey),),
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

List<Artists> _artists; 
List<Playlists> _playlists; 

  @override
  void initState() {
    
    this.setHost();

     Service.getPlaylists().then((playlists){
      setState(() {
        _playlists = playlists; 
        print("LOADING IN NEW METHOD FAM"); 
      });
    });

    Service.getNetworkArtists().then((artists){
      setState(() {
        _artists = artists; 
        print("LOADING IN NEW METHOD FAM"); 
      });
    });

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('All Artists'),
        backgroundColor: Colors.black87,
      ),
      body: ListView.builder(
          itemCount: _artists == null ? 0: _artists.length,
          itemBuilder: (context, index){
            Artists artist = _artists[index]; 
            return postCard( artist.picture, artist.name, artist.id);

          }
      ),
    );
  }
}