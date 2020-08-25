import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../library/drawer/network/artists.dart';
import '../../library/drawer/network/songs.dart';
import '../../library/drawer/network/playlists.dart';
import '../../library/drawer/network/users.dart';


class MyNetworkPage extends StatefulWidget {
  @override
  _MyNetworkPageState createState() => _MyNetworkPageState();

}

class _MyNetworkPageState extends State<MyNetworkPage> {

  String HOST;

  bool _isLoading = false;

  getNetwork() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final network = prefs.getString('network');
    HOST = network;

  }

  String total;
  String used;

  Future<String> getSystem() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final network = prefs.getString('network');
    HOST = network;

    http.Response response = await http.get(
        Uri.encodeFull("$network/music/system/?format=json"),
        headers: {
          "Accept":"application/json",
          "Authorization": "Token $token"
        }
    );
    setState((){
      var jsonData = json.decode(response.body);
      total = jsonData['HDD Total'];
      used = jsonData['HDD Used'];


    });
    return "Success!";
  }






  //THIS IS OUR SIGN IN METHOD







  @override
  void initState(){
    super.initState();
    this.getNetwork();
    this.getSystem();



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text('Network Info', style: TextStyle(color: Colors.white),),
        ),

        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                child: Column(
                  children: <Widget>[

                   ListTile(
                     leading: Icon(
                       Icons.storage,
                       color: Colors.red,
                     ),
                     title: Text('Hard Drive Space', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                     subtitle: Text('$used/$total', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),

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
                        Icons.music_video,
                        color: Colors.red,
                      ),
                      title: Text('All Songs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      subtitle: Text('View all songs on this device', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),

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
                        Icons.art_track,
                        color: Colors.red,
                      ),
                      title: Text('All Artists', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      subtitle: Text('View all artists on this device', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),

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
                        Icons.playlist_play,
                        color: Colors.red,
                      ),
                      title: Text('All Playlists', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      subtitle: Text('View all playlists on this device', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),

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
                        Icons.supervised_user_circle,
                        color: Colors.red,
                      ),
                      title: Text('All Users', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      subtitle: Text('View all Users on this device', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),

                    ),






                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}