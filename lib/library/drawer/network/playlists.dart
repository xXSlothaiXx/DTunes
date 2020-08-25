import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../library/playlist_detail.dart';
import '../../../models/Playlists.dart';
import '../../../api/Service.dart';



class PlaylistsPage extends StatefulWidget {




  @override
  _PlaylistsPageState createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage > {

  String HOST;


  void hostNetwork() async {
      SharedPreferences  prefs = await SharedPreferences.getInstance();
      final network = prefs.getString("network"); 
      HOST = network; 

  }

  List<Playlists> _playlists; 



  bool is_loading = false;




  @override
  void initState() {

    hostNetwork(); 

    Service.getPlaylists().then((playlists){
      setState(() {
        _playlists = playlists; 
        print("LOADING IN NEW METHOD FAM"); 
      });
    });


  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text('All Artists'),
          backgroundColor: Colors.black87,
        ),
        body: CustomScrollView(
          slivers: <Widget>[
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
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage( "$HOST" + playlist.picture,)
                      ),
                      trailing:IconButton(
                        icon:  Icon(
                          Icons.remove_red_eye,
                          color: Colors.red,
                        ),
                        onPressed: (){


                        },
                      ),

                  );
                },
                childCount: _playlists == null ? 0: _playlists.length,
              ),
            ),
          ],
        )
    );
  }
}