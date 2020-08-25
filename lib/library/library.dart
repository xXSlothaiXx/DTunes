import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/artist_detail.dart';
import 'playlist_detail.dart';
import '../base.dart';
import 'drawer/network/artists.dart';
import 'drawer/network/playlists.dart';
import 'drawer/network/songs.dart';
import 'drawer/network/users.dart';
import 'drawer/devices.dart';
import 'public_network/public_network_detail.dart';
import '../db/network.dart';
import '../db/data_repository.dart';
import '../models/Playlists.dart';
import '../api/Service.dart';
import '../api/Posting.dart';



class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {

  static String HOSTNAME;

  Posting _action = Posting(); 


  Future<List<Network>> future;
  String name;
  int id;

  /**
   * THE SAME SQFLITE methods for the datbase
   * this needs to go into class file becuase its reused many times
   */


  void hostNetwork() async {
      SharedPreferences  prefs = await SharedPreferences.getInstance();
      final network = prefs.getString("network"); 
      HOSTNAME = network; 

  }



  void selectNetwork(String network) async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    prefs.setString("public_network", network);

  }

  void readData() async {
    final network = await RepositoryServiceNetwork.getNetwork(id);
    print(network.name);
  }

  updateTodo(Network network) async {
    network.name = 'please 🤫';
    await RepositoryServiceNetwork.updateTodo(network);
    setState(() {
      future = RepositoryServiceNetwork.getAllNetworks();
    });
  }

  deleteTodo(Network network) async {
    await RepositoryServiceNetwork.deleteNetwork(network);
    setState(() {
      id = null;
      future = RepositoryServiceNetwork.getAllNetworks();
    });
  }




Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text('DTunes', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Adding song to your server, Please wait 1-2 minutes for the song to be avaialble to your device', style: TextStyle(color: Colors.white)),
             
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}




  /**
   * SAME build item method, needs to go into classfile
   */

  ListTile buildItem(Network network) {
    return ListTile(
        onTap: () {
          setState(() {

            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PublicHomePage(public_network : '${network.network}')));


          });
        },
        title: Text('${network.name}', style: TextStyle(color: Colors.white)),
        leading: Icon(
          Icons.network_check,
          color: Colors.red,
        ),
        subtitle: Text('${network.network}', style: TextStyle(color: Colors.grey)),
        trailing: IconButton(
          icon:  Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            setState(() {
              deleteTodo(network);
            });
          },
        )
    );
  }



  bool is_loading = false;

  /**
   * THis method is to create a playlist
   */

  void addPlaylist(){
    showModalBottomSheet(context: context, builder: (context){
      return Column(
        children: <Widget>[
          is_loading ? Center(
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 300,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              )
          ): Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),

                  ListTile(
                    title: Text('Create Playlist', style: TextStyle(color: Colors.white)),
                    leading: Icon(
                      Icons.playlist_add,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildMessageComposer(),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: (){
                      _action.createPlaylist(createController.text);
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()));

                    },
                    child: Text('Create Playlist', style: TextStyle(color: Colors.red, fontSize: 17),),
                  )


                ],
              ),
            ),
          )
        ],
      );
    });

  }


  void showBottomSheetSong(){
    showModalBottomSheet(context: context, builder: (context){
      return Column(
        children: <Widget>[
          Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),

                  ListTile(
                    title: Text('Remove Playlist', style: TextStyle(color: Colors.white)),
                    leading: Icon(
                      Icons.playlist_play,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: Text('Edit Playlist', style: TextStyle(color: Colors.white)),
                    leading: Icon(
                      Icons.edit,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: Text('Favorite Playlist', style: TextStyle(color: Colors.white)),
                    leading: Icon(
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
          )
        ],
      );
    });

  }


  TextEditingController createController = new TextEditingController();


  _buildMessageComposer(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      color: Colors.grey[800],
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.music_note, color: Colors.red),
          ),
          Expanded(
              child: TextField(
                controller: createController,
                decoration: InputDecoration.collapsed(
                    hintText: 'Create a playlist'
                ),

              )

          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.red),
            onPressed: (){
              setState(() {

              });
            },
          ),
        ],
      ),



    );
  }


  TextEditingController songsearchController = new TextEditingController();


  _buildSongSearchComposer(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      color: Colors.grey[800],
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.music_note, color: Colors.red),
          ),
          Expanded(
              child: TextField(
                controller: songsearchController,
                decoration: InputDecoration.collapsed(
                    hintText: 'Enter YouTube URL'
                ),

              )

          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.red),
            onPressed: (){
              setState(() {
                _showMyDialog(); 
                _action.addSong(songsearchController.text); 
                

                
              });
            },
          ),
        ],
      ),



    );
  }
  





  GestureDetector artistCard(String thumbnail, String artist){
    return GestureDetector(
        onTap: (){
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ArtistPage()));
          });
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 6.0) ,
                width: MediaQuery.of(context).size.width * 0.5,
                height: 220.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter:  ColorFilter.mode(Colors.black, BlendMode.softLight),
                      image: NetworkImage(
                        thumbnail,
                      ),
                      fit: BoxFit.cover
                  ),

                ),

              ),
              SizedBox(
                height: 15,
              ),
              Text(artist, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),)


            ],
          ),
        )
    );
  }


List<Playlists> _playlists; 

  @override
  void initState(){
    super.initState();
    is_loading = true; 

    this.hostNetwork(); 
  
    future = RepositoryServiceNetwork.getAllNetworks();

    Service.getPlaylists().then((playlists){ 
      setState(() {

        _playlists = playlists; 
        is_loading = false;  
      });
    }); 

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.black87,
          child: ListView(

            children: <Widget>[
              DrawerHeader(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                     
                      title: Text('DTunes', style: TextStyle(color: Colors.red, fontSize: 20), ),
                      subtitle: Text('Created by: xXSlothAIXx', style: TextStyle(color: Colors.grey),),

                    ),
                  ],

                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
              ListTile(
                onTap: (){
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SongsPage()));
                  });

                },
                leading: Icon(
                  Icons.music_note,
                  color: Colors.red,
                ),
                title: Text('Songs', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                onTap: (){
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ArtistsPage()));
                  });
                },
                leading: Icon(
                  Icons.supervised_user_circle,
                  color: Colors.red,
                ),
                title: Text('Artists', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                onTap: (){
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlaylistsPage()));
                  });
                },
                leading: Icon(
                  Icons.playlist_add,
                  color: Colors.red,
                ),
                title: Text('Playlists', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                onTap: (){
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UsersPage()));
                  });
                },
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.red,
                ),
                title: Text('Users', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                onTap: (){
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DeviceNetworkPage()));
                  });
                },
                leading: Icon(
                  Icons.device_hub,
                  color: Colors.red,
                ),
                title: Text('Devices', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });


                },
                leading: Icon(
                  Icons.arrow_back,
                  color: Colors.red,
                ),
                title: Text('Sign Out', style: TextStyle(color: Colors.red)),
              )
            ],
          ) ,
        )
      ),
        backgroundColor: Colors.black87,

        appBar: AppBar(
          title: Text('Playlists'),
          backgroundColor: Colors.black87,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: (){
                setState(() {

                  addPlaylist();
                });
              },
            )
          ],
        ),

        body: is_loading ? Center(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 300,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            )
        ) :  DefaultTabController(
          length: 5,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  child: Column(
                    children: <Widget>[

                      SizedBox(
                        height: 10,
                      ),
                      _buildSongSearchComposer(),

                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        Playlists playlist = _playlists[index]; 
                    return ListTile(
                      onTap: (){
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PlaylistPage(pk: playlist.id)));
                        });
                      },
                      title: Text(playlist.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,)),

                      leading:  Image.network(
                        '${HOSTNAME}' + playlist.picture,
                        width:  MediaQuery.of(context).size.width * 0.2,
                        height:  MediaQuery.of(context).size.height * 0.2,
                        fit: BoxFit.fitWidth,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: (){
                          _action.removePlaylist(playlist.id);
                        },
                      ),
                      subtitle: Text(playlist.datePosted.toString(), style: TextStyle(color: Colors.grey),),
                    );
                  },
                  childCount: _playlists == null ? 0: _playlists.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("Playlist Devices", style: TextStyle(color: Colors.white),),
                      ),


                      ListView(
                        shrinkWrap: true,
                        children: <Widget>[


                          FutureBuilder<List<Network>>(
                            future: future,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                    children: snapshot.data.map((network) => buildItem(network))
                                        .toList());
                              } else {
                                return SizedBox();
                              }
                            },
                          )
                        ],
                      ),



                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
