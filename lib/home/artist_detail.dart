import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'player.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../api/Posting.dart'; 
import '../models/Songs.dart'; 
import '../models/Artists.dart'; 
import '../models/Playlists.dart'; 
import '../api/Service.dart';


class ArtistPage extends StatefulWidget {

  final pk;

  ArtistPage({Key key, @required this.pk}) : super(key: key);

  @override
  _ArtistPageState createState() => _ArtistPageState(pk);
}

class _ArtistPageState extends State<ArtistPage> {

  Posting _action = Posting(); 

  int pk;

  _ArtistPageState(this.pk);

  bool is_following = false;

  String HOST;

  String image_url;
  String name;
  String followstatus;
  bool is_loading = true;

  Future<String> getArtist() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final network = prefs.getString('network');
    HOST = network;

    http.Response response = await http.get(
        Uri.encodeFull("$network/dtunes/artists/artist/$pk/?format=json"),
        headers: {
          "Accept":"application/json",
          "Authorization": "Token ${token} "
        }
    );

    final jsonData = json.decode(response.body);
    print(jsonData);

    setState(() {
      image_url = jsonData["picture"];
      name = jsonData["name"];
      followstatus = jsonData["follow_status"];
    });

    if(followstatus == "Following"){
      is_following = true;
    }

    return "Success!";
  }

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
        Uri.encodeFull("$network/dtunes/artists/artist/$pk/"),
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

      });
      //this is to move us to the next page
      //print(jsonData['token']);
      //var auth_token = jsonData['token'];
    }else{
      print(response.body);
    }
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

  void addPhotoSheet(){
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
                  Text('add photo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(
                    height: 10,
                  ),
                 ListTile(
                   onTap: () {
                     setState(() {
                       getImage();
                     });
                   },
                   title: Text('Add photo from camera', style: TextStyle(color: Colors.white),),
                   leading: Icon(
                     Icons.camera_alt,
                     color: Colors.red,
                   ),
                 ),
                  ListTile(
                    onTap: (){
                      setState(() {
                        getGallery();
                      });
                    },
                    title: Text('Add photo from camera roll', style: TextStyle(color: Colors.white),),
                    leading: Icon(
                      Icons.photo_library,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: (){
                      submitPost();

                    },
                    child:  Container(
                      height: 50,
                      width: 200,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15.0)
                      ),
                      child: Center(
                        child: Text(
                            'Add Photo',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16
                            )
                        ),
                      ),

                    ),
                  )

                ],
              ),
            ),
          )
        ],
      );
    });

  }




  List<Playlists> _playlists; 
  List<Artists> _artists;
  List<Songs> _songs; 


  @override
  void initState(){
    super.initState();

    is_loading = true; 

    this.getArtist();
   

    Service.getPlaylists().then((playlists){
      setState(() {
        _playlists = playlists; 
        is_loading = false; 
      });
    });

    Service.getArtistSongs(pk).then((songs){
      setState(() {
        _songs = songs; 
        is_loading = false;
      });
    });

    Service.getArtists().then((artists){
      setState(() {
        _artists = artists; 
       is_loading = false; 
      });
    });



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black38,
        appBar: AppBar(
          backgroundColor: Colors.black45,
          title: Text(name),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
              ),
              onPressed: () {
                addPhotoSheet();
              },
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                child: Column(
                  children: <Widget>[
                 
                    Container(
                     height: MediaQuery.of(context).size.height * 0.50,
                     child: Stack(
                       children: <Widget>[
                          Container(

                      decoration: BoxDecoration(
                        image: DecorationImage(
                  
                          image: NetworkImage(
                            
                              '$HOST' + image_url,
                              
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
                       _action.followArtist(pk);
                       setState(() {
                         getArtist();
                       });


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
                         child:  is_following ? Text('Following', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),) :  Text('Follow',
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
                     title:  Text(name + ' Tracks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
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
                ),
              ),

            ),
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
                      title: Text(song.name, maxLines: 2, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,)),
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(song.thumbnail)
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.playlist_add,
                          color: Colors.red,
                        ),
                        onPressed: (){
                          playlistSheet(song.id);
                        },
                      ),
                      subtitle: Text(song.artistname, style: TextStyle(color: Colors.grey),),
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