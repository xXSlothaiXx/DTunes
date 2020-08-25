import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../home/player.dart';
import 'shuffle.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/Playlist.dart';
import '../models/Songs.dart';
import '../api/Service.dart';
import '../api/Posting.dart';

class PlaylistPage extends StatefulWidget {

  final pk;

  PlaylistPage({Key key, @required this.pk}) : super(key: key);


  @override
  _PlaylistPageState createState() => _PlaylistPageState(pk);
}

class _PlaylistPageState extends State<PlaylistPage> {

  Posting _action = Posting(); 

  bool is_loading = false;

  static String HOSTNAME; 


  void hostNetwork() async {
      SharedPreferences  prefs = await SharedPreferences.getInstance();
      final network = prefs.getString("network"); 
      HOSTNAME = network; 

  }


  int pk;

  _PlaylistPageState(this.pk);


  Future<Playlist> futurePlaylist; 

  /**
   * Get Playlist info from the API
   * 
   * CF
   */



  /**
   * 
   * CF
   * Image/Gallery functions that need to go in class FILE
   */

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future getGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }


  /**
   * Submit Photo using base 64 IMAGE
   * CF
   */


  submitPost() async {

    SharedPreferences  prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final network = prefs.getString('network');



    if (_image == null) return;
    String base64Image = base64Encode(_image.readAsBytesSync());
    String fileName = _image.path.split("/").last;

    Map data = {
      'picture': base64Image,
    };

    http.Response response = await http.put(
        Uri.encodeFull("$network/dtunes/playlists/playlist/$pk/"),
        body: data,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token $token"
        }
    );
    //if this user gets a token, send them to the home page
    if(response.statusCode == 200){
      print(response.body);
      setState(() {
        Navigator.pop(context);
        is_loading = true; 
        

      });
      //this is to move us to the next page
      //print(jsonData['token']);
      //var auth_token = jsonData['token'];
    }else{
      print(response.body);
    }
  }

  /**
   * REMOVE song from playlist
   * CF
   */



  /**
   * SHOW bottom sheet to add profile photo to playlist
   */

  void showBottomSheet(){
    showModalBottomSheet(context: context, builder: (context){
      return Column(
        children: <Widget>[
          Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Text('Add Playlist Photo', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),

                  SizedBox(
                    height: 10,
                  ),

                  ListTile(
                    onTap: (){
                      getImage();
                    },
                    title: Text('Take photo', style: TextStyle(color: Colors.white)),
                    leading: Icon(
                      Icons.photo_camera,
                      color: Colors.red,
                    ),
                  ),
                  ListTile(
                    onTap: (){
                      getGallery();
                    },
                    title: Text('Choose from Camera Roll', style: TextStyle(color: Colors.white)),
                    leading: Icon(
                      Icons.photo_library,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  GestureDetector(
                    onTap: (){
                      submitPost();
                      setState(() {
                        is_loading = true;
                      });
                    },
                    child: Text('Submit Photo', style: TextStyle(color: Colors.red, fontSize: 17),),
                  )


                ],
              ),
            ),
          )
        ],
      );
    });

  }

  /**
   * Get songs from selected playlist, PLAYLIST ID required if 
   * you want it to go into class file
   */



  List<Songs> _songs; 

  @override
  void initState(){
    super.initState();

    is_loading = true; 

    Service.getPlaylistSongs(pk).then((songs){
      setState(() {
        _songs = songs; 
        is_loading = false;  
      });
    }); 

    setState(() {
      futurePlaylist = Service.fetchPlaylist(pk);
      is_loading = false; 
      
    });
     
    
    this.hostNetwork(); 


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black38,
        appBar: AppBar(
         
          title: Text('Playlist'),
          backgroundColor: Colors.black,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_a_photo,
              ),
              onPressed: (){
                showBottomSheet();
              },
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child:  Container(
                child: FutureBuilder<Playlist>(
                  future: futurePlaylist,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return  Column(
                  children: <Widget>[
                    Container(
                     height: MediaQuery.of(context).size.height * 0.50,
                     child: Stack(
                       children: <Widget>[
                          Container(

                      decoration: BoxDecoration(
                        image: DecorationImage(
                  
                          image: NetworkImage(
                            
                              '$HOSTNAME' + snapshot.data.picture,
                              
                          ),
                          fit: BoxFit.cover,
                        ),

                      ),

                    ),

                    Container(
                      decoration: BoxDecoration( 
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.3), Colors.red.withOpacity(0.9)],
                   
                        begin: Alignment.topCenter, 
                        end: Alignment.bottomCenter),),

                    ),
                       ],

                     )
                     ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ShufflePlayPage(pk: pk)));
                        

                        

  
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Center(
                          child:  Text('Shuffle',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),

                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title:  Text(snapshot.data.name + " Tracks", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                      leading: Icon(
                        Icons.music_note,
                        color: Colors.red,
                      ),
                      trailing: Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),


                  ],
                );
                    }else if(snapshot.hasError){
                      return Text('Error getting artist'); 
                    }
                    return CircularProgressIndicator(); 
                  }
                )
              ),

            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        Songs playlistsong = _songs[index];
                    return ListTile(
                      onTap: (){
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PlayerPage(pk: playlistsong.id)));
                        });
                      },
                      title: Text(playlistsong.name, maxLines: 2,  style: TextStyle(color: Colors.white,  fontWeight: FontWeight.bold,)),
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(playlistsong.thumbnail)
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                        ),
                        onPressed: (){
                          _action.removeFromPlaylist(playlistsong.id, pk);

                        },
                      ),
                      subtitle: Text('By: Billy Eillish', style: TextStyle(color: Colors.grey),),
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