import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'public_artist.dart';
import 'public_player.dart';
import 'public_search.dart';
import '../../models/Songs.dart'; 
import '../../models/Artists.dart'; 
import '../../models/Playlists.dart'; 
import '../../api/Service.dart';
import '../../api/Posting.dart';


class PublicHomePage extends StatefulWidget {

  final public_network;

  PublicHomePage({Key key, @required this.public_network}) : super(key: key);
  @override
  _PublicHomePageState createState() => _PublicHomePageState(public_network);
}

class _PublicHomePageState extends State<PublicHomePage> {

  Posting _action = Posting();

  String HOST;

  String public_network;

  _PublicHomePageState(this.public_network);

  setNetwork() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("public_network", public_network);
    final public_ip = prefs.getString("public_network");
    HOST = public_ip;

  }


  TextEditingController searchController = new TextEditingController();

  GestureDetector artistCard(String thumbnail, String name, int pk){
    return GestureDetector(

        onTap: (){
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PublicArtistPage(pk: pk)));
          });
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 6.0) ,
                width: MediaQuery.of(context).size.width * 0.6,
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
              Text(name, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),)


            ],
          ),
        )
    );
  }

  Container artistView(){
    return  Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _artists == null ? 0: _artists.length,
        itemBuilder: (context, index){
          Artists artist = _artists[index]; 
          return artistCard(
            artist.picture,
            artist.name,
            artist.id,

          );
        },
      ),
    );
  }

  GestureDetector songCard(String thumbnail, String song, int pk){
    return GestureDetector(

        onTap: (){
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PublicPlayerPage(pk : pk)));

          });
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 6.0) ,
                width: MediaQuery.of(context).size.width * 0.33,
                height: 130.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter:  ColorFilter.mode(Colors.black, BlendMode.softLight),
                      image: NetworkImage(
                       '$HOST' +  thumbnail,
                      ),
                      fit: BoxFit.cover
                  ),

                ),

              ),
              SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 6.0) ,
                width: MediaQuery.of(context).size.width * 0.33,
                child: Column(
                  children: <Widget>[
                    Text(song, maxLines: 3, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),)
                  ],
                ),
              )


            ],
          ),
        )
    );
  }

  Container songView(){
    return  Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _songs == null ? 0: _songs.length,
        itemBuilder: (context, index){
          Songs song = _songs[index]; 
          return songCard(
              song.thumbnail,
              song.name,
              song.id

          );
        },
      ),
    );
  }

  TextEditingController publicsearchController = new TextEditingController();

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
                controller: publicsearchController,
                decoration: InputDecoration.collapsed(
                    hintText: 'Search artists and songs on this device'
                ),

              )

          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.red),
            onPressed: (){
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PublicSearchResult(query : publicsearchController.text)));

              });
            },
          ),
        ],
      ),



    );
  }



  bool is_loading = false;

  List<Songs> _songs; 
  List<Artists> _artists; 
  List<Playlists> _playlists; 

  @override
  void initState(){
    super.initState();

    is_loading = true; 
  


    Service.getPublicSongs().then((songs){
      setState(() {
        _songs = songs; 
        is_loading = false; 
      });
    }); 

    Service.getPublicArtists().then((artists){
      setState(() {
        _artists = artists; 
        is_loading = false; 
      });
    }); 

  

    this.setNetwork();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text('$HOST', style: TextStyle(color: Colors.white),),
        ),

        body: DefaultTabController(
          length: 5,
          child: CustomScrollView(
            slivers: <Widget>[


              SliverToBoxAdapter(
                child: is_loading ? Center(
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
              ) : Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      _buildMessageComposer(),
                      SizedBox(
                        height: 10,
                      ),




                      ListTile(
                        title:  Text('Your Artists', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                        leading: Icon(
                          Icons.supervised_user_circle,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      artistView(),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title:  Text('Your Songs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                        leading: Icon(
                          Icons.music_note,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      songView(),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title:  Text('Songs you like', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                        leading: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
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
                                MaterialPageRoute(builder: (context) => PublicPlayerPage(pk: song.id)));
                          });
                        },
                        title: Text(song.name,  maxLines: 2,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,)),
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage( '$HOST' +  song.thumbnail,)
                        ),
                        trailing:IconButton(
                          icon:  Icon(
                            Icons.playlist_add,
                            color: Colors.red,
                          ),
                          onPressed: (){
                            print("NEED TO ADD SONG LEECHING FEATURE"); 

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
          ),
        )
    );
  }
}