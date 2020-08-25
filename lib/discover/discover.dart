import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../home/player.dart';
import '../home/search_result.dart';
import '../home/artist_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/Posting.dart'; 
import '../models/Songs.dart'; 
import '../models/Artists.dart'; 
import '../models/Playlists.dart'; 
import '../api/Service.dart';


class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {

  String HOSTNAME; 

   void hostNetwork() async {
      SharedPreferences  prefs = await SharedPreferences.getInstance();
      final network = prefs.getString("network"); 
      HOSTNAME = network; 

  }

  Posting _action = Posting(); 

  TextEditingController searchController = new TextEditingController();

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
                controller: searchController,
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
                    MaterialPageRoute(builder: (context) => SearchResult(query : searchController.text)));

              });
            },
          ),
        ],
      ),

    );
  }


  GestureDetector artistCard(String thumbnail, String name, int pk){
    return GestureDetector(

        onTap: (){
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ArtistPage(pk: pk)));
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
                  borderRadius: BorderRadius.circular(10),
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



  GestureDetector songCard(String thumbnail, String song, int pk){
    return GestureDetector(

        onTap: (){
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlayerPage(pk : pk)));

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
                  borderRadius: BorderRadius.circular(10),
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 6.0) ,
                width: MediaQuery.of(context).size.width * 0.33,
                child: Column(
                  children: <Widget>[
                    Text(song,  maxLines: 3 , style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),)
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
      height: 230,
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

  bool is_loading = false;

  List<Playlists> _playlists;
  List<Songs> _songs; 
  List<Artists> _artists; 

  @override
  void initState(){
    super.initState();
    this.hostNetwork(); 
    is_loading = true; 


    Service.getPlaylists().then((playlists){
      setState(() {
        _playlists = playlists; 
        is_loading = false;  
      });
    });

    Service.getTopSongs().then((songs){
     
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
        backgroundColor: Colors.black87,

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
              ): Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      _buildMessageComposer(),
                      SizedBox(
                        height: 20,
                      ),

                      ListTile(
                        title:  Text('Top Artists', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                        leading: Icon(
                          Icons.account_circle,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      artistView(),
                      Divider(
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        title:  Text('Most Listened to', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                        leading: Icon(
                          Icons.account_circle,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      songView(),
                      Divider(
                        color: Colors.white,
                      ),

                      ListTile(
                        title:  Text('Top 100', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                        leading: Icon(
                          Icons.account_circle,
                          color: Colors.red,
                        ),
                      ),
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
                          backgroundImage: NetworkImage( song.thumbnail,)
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
          ),
        )
    );
  }
}
