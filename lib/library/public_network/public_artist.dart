import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../home/player.dart';
import '../../models/Songs.dart'; 
import '../../api/Service.dart';



class PublicArtistPage extends StatefulWidget {

  final pk;

  PublicArtistPage({Key key, @required this.pk}) : super(key: key);

  @override
  _PublicArtistPageState createState() => _PublicArtistPageState(pk);
}

class _PublicArtistPageState extends State<PublicArtistPage> {

  int pk;

  _PublicArtistPageState(this.pk);



  String HOST;

  String image_url;
  String name;
  bool is_loading = true;

  Future<String> getArtist() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final network = prefs.getString('public_network');
    HOST = network;

    http.Response response = await http.get(
        Uri.encodeFull("$network/public/artist/$pk/?format=json"),
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
    });

    return "Success!";
  }



List<Songs> _songs;

  @override
  void initState(){
    super.initState();
    is_loading = true; 

    Service.getPublicArtistSongs(pk).then((songs){
      setState(() {
        _songs = songs; 
        is_loading = false;  
      });
    }); 

    this.getArtist(); 
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
                       //_action.followArtist(pk);
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
                         child: Text('View',
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