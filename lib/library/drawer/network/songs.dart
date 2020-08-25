import '../../../home/artist_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../../../home/player.dart';
import '../../../api/Service.dart';
import '../../../models/Songs.dart';
import '../../../models/Playlists.dart';
import '../../../api/Posting.dart';



class SongsPage extends StatefulWidget {

  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage > {

  String HOST;

  Posting _action = Posting(); 

  Container postCard(String image_value,  String name,   int pk){
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

List<Songs> _songs; 
List<Playlists> _playlists; 


  @override
  void initState() {
    
     Service.getPlaylists().then((playlists){
      setState(() {
        _playlists = playlists; 
        print("LOADING IN NEW METHOD FAM"); 
      });
    });

    Service.getNetworkSongs().then((songs){
      setState(() {
        _songs = songs; 
        print("LOADING IN NEW METHOD FAM"); 
      });
    });



  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('All Songs'),
        backgroundColor: Colors.black87,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Songs song = _songs[index]; 
                return ListTile(
                    onTap: (){
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PlayerPage(pk: song.id)));
                      });
                    },
                    title: Text(song.name,  maxLines: 2,  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,)),
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(song.thumbnail,)
                    ),
                    trailing:IconButton(
                      icon:  Icon(
                        Icons.playlist_add,
                        color: Colors.red,
                      ),
                      onPressed: (){
                        playlistSheet(song.id);

                      },
                    ),
                    subtitle: Row(
                      children: <Widget>[

                        Icon(
                          Icons.remove_red_eye,
                          color: Colors.red,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(song.plays.toString(), style: TextStyle(color: Colors.grey),),
                        SizedBox(
                          width: 10,
                        ),
                        Text(song.artistname, style: TextStyle(color: Colors.grey),),
                      ],
                    )
                );
              },
              childCount: _songs == null ? 0: _songs.length,
            ),
          ),
        ],
      )
    );
  }
}