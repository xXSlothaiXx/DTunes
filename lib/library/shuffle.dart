import 'package:flutter/material.dart';
import '../home/player.dart';
import '../api/Service.dart';
import '../models/Songs.dart'; 

class ShufflePlayPage extends StatefulWidget {

  final pk;

  ShufflePlayPage({Key key, @required this.pk}) : super(key: key);


  @override
  _ShufflePlayPageState createState() => _ShufflePlayPageState(pk);
}

class _ShufflePlayPageState extends State<ShufflePlayPage> {

  String HOST;

  bool is_loading = false; 

  int pk;

  _ShufflePlayPageState(this.pk);


  List<Songs> _playlistsongs; 

PageController _pageController;

  @override
  void initState() {

     _pageController = PageController();
     Service.getPlaylistSongs(pk).then((songs){
       is_loading = true; 
      setState(() {
        _playlistsongs = songs; 
        is_loading = false;  
      });
    }); 


  }


 @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
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
        ) : PageView.builder(
          controller: _pageController,
          itemBuilder: (context, position){    
          
         Songs song = _playlistsongs[position]; 
        return PlayerPage(pk: song.id); 
      },
      itemCount: _playlistsongs == null ? 0: _playlistsongs.length,
      )
    );
  }
}