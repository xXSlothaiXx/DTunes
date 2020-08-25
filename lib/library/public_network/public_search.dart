import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../../home/player.dart';
import '../../models/Songs.dart'; 
import '../../api/Service.dart'; 



class PublicSearchResult extends StatefulWidget {

  final query;

  PublicSearchResult({Key key, @required this.query}) : super(key: key);


  @override
  _PublicSearchResultState createState() => _PublicSearchResultState(query);
}

class _PublicSearchResultState extends State<PublicSearchResult> {

  String HOST;

  Container postCard(String image_value,  String heading, String artistname,  int pk){
    return Container(
      width: 300.0,
      height: 75.0,
      child: new GestureDetector(
          onTap: (){
            print("Pressed widget");
          },

          child: ListTile(
            onTap: (){
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayerPage(pk: pk)));
              });
            },
            leading:  Image.network(
              image_value,
              width:  MediaQuery.of(context).size.width * 0.2,
              height:  MediaQuery.of(context).size.height * 0.2,
              fit: BoxFit.fitWidth,
            ),
            title: Text(heading, maxLines: 2,  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(artistname, style: TextStyle(color: Colors.grey),),
            trailing: IconButton(
              icon: Icon(
                Icons.playlist_add,
                color: Colors.red,
              ),
              onPressed: (){
              },
            ),
          )
      ),
    );
  }

  bool is_loading = false;



List<Songs> _results; 

  @override
  void initState() {

    is_loading = true; 


    Service.searchPublicSongs(query).then((songs){
      setState(() {
        _results = songs; 
        is_loading = false;   
      });
    }); 
  }

  String query;

  _PublicSearchResultState(this.query);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Results for: ${query}'),
        backgroundColor: Colors.black87,
      ),
      body: ListView.builder(
          itemCount: _results == null ? 0: _results.length,
          itemBuilder: (context, index){
            Songs result = _results[index]; 
            return postCard( result.thumbnail, result.name, result.artistname, result.id);

          }
      ),
    );
  }
}