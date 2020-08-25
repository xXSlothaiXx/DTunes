import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../home/artist_detail.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import '../../api/Posting.dart';

//PublicPlayerPage
//_PublicPlayerPageState

class PublicPlayerPage extends StatefulWidget {

  final pk;

  PublicPlayerPage({Key key, @required this.pk}) : super(key: key);


  @override
  _PublicPlayerPageState createState() => _PublicPlayerPageState(pk);
}

class _PublicPlayerPageState extends State<PublicPlayerPage> {

  bool isPlaying = true;

  Posting _action = Posting(); 

  Duration _duration = new Duration();
  Duration _position = new Duration();



  int pk;

  _PublicPlayerPageState(this.pk);


  String HOST;

  String image_url;
  String name;
  String media_url;
  int artistID;
  String artistname;
  static String media_url_static;



  Future<String> getSong() async {
    is_loading = true; 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final network = prefs.getString('public_network');
    HOST = network;

    http.Response response = await http.get(
        Uri.encodeFull("$network/dtunes/songs-public/public-song/$pk/?format=json"),
        headers: {
          "Accept":"application/json"
        }
    );

    if(response.statusCode == 200){
       final jsonData = json.decode(response.body);
       print(jsonData);

        setState(() {
          image_url = jsonData["thumbnail"];
          name = jsonData["name"];
          media_url = '${network}' + jsonData["media_file"];
          artistname = jsonData["artistname"];
          artistID = jsonData["artist"];

          play(); 

        });
      
     
    }else{
      return "Failure"; 
    }

  
  }

  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache;

  play() async {
    isPlaying = true; 
    int result = await audioPlayer.play(media_url);
    if (result == 1) {
      // success
      print('Playing song');
    }
  }



  stop() async {
    isPlaying = false; 
    audioPlayer.stop();
  }

   Widget slider() {
    return Slider(
        activeColor: Colors.red,
        inactiveColor: Colors.white,
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            seekToSecond(value.toInt());
            value = value;
          });
        });
  }


void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    audioPlayer.seek(newDuration);
  }



void initPlayer() {
    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: audioPlayer);

    audioPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    audioPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });
  }

  

  
//https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3





  @override
  void initState() {
    super.initState();
    this.getSong(); 
    initPlayer(); 
  
  }



  bool is_loading = false;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black38,
        appBar: AppBar(
          backgroundColor: Colors.black38,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: (){
              stop();

              setState(() {

                Navigator.pop(context);
                

              });
              
              
            },
          ),

          title: ListTile(
            onTap: (){
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ArtistPage(pk : artistID)));

              });
            },
            title: Text(
              name, maxLines: 1, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),),
            subtitle: Text(artistname, style: TextStyle(color: Colors.grey)),
          ),

        ),
        body: Column(
          children: [
            Container(
                     height: MediaQuery.of(context).size.height * 0.65,
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
                       height: 10
                     ), 

                     slider(), 


                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Column(
                        children: <Widget>[

                          Container(
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[

                                     IconButton(
                                       icon: Icon(
                                         Icons.fast_rewind,
                                         color: Colors.red,
                                         size: 40,
                                       ),
                                       onPressed: (){

                                         isPlaying = false;

                                       },
                                     ),

                                      SizedBox(
                                       height: 10
                                     ), 

                                     ClipOval(
                                       child: Material(
                                         color: Colors.red,
                                         child: InkWell(
                                           splashColor: Colors.blue,
                                           child: SizedBox(
                                            width: 70, 
                                            height: 70, 
                                            child: isPlaying ?  IconButton(
                                       icon: Icon(
                                         Icons.pause,
                                         color: Colors.white,
                                         size: 40,
                                       ),
                                       onPressed: (){


                                         setState(() {
                                           isPlaying = false;
                                           stop(); 
                                         });



                                       },

                                     ) :  IconButton(
                                       icon: Icon(
                                         Icons.play_arrow,
                                         color: Colors.white,
                                         size: 40,
                                       ),
                                       onPressed: (){

                                         setState(() {
                                           isPlaying = true;
                                           play(); 

                                         });
                                       },

                                     ),
                                           ),
                                         )
                                       )

                                     ),

                                     SizedBox(
                                       height: 10
                                     ), 



                                    
                                      IconButton(
                                        icon: Icon(
                                          Icons.fast_forward,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                        onPressed: (){
                                          setState(() {
                                            media_url_static = media_url;

                                          });

                                          isPlaying = false;


                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
          ],
        )
    );
  }
}