import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';


class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {



  GestureDetector videoCard(String thumbnail, String artist){
    return GestureDetector(

      onTap: (){
        print('Ok');
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6.0) ,
        width: MediaQuery.of(context).size.width * 0.4,
        height: 150.0,
        decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter:  ColorFilter.mode(Colors.black, BlendMode.softLight),
              image: NetworkImage(
                thumbnail,
              ),
              fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.circular(20.0),

        ),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 75,
              ),
              Text(artist, style: TextStyle(color: Colors.white))


            ],
          ),
        ),



      ),
    );
  }

  Container videosView(){
    return  Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 30,
        itemBuilder: (context, index){
          return videoCard(
              'http://10.132.1.93:8000/media/profile_pics/cu.jpg',
              'Billy Eillish'

          );
        },
      ),
    );
  }



  String HOST;

  bool is_loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black87,


              title: Text('Select Playlist',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              // Allows the user to reveal the app bar if they begin scrolling back
              // up the list of items.
              floating: true,
              actions: <Widget>[

                IconButton(
                  color: Colors.black,
                  icon: Icon(
                      Icons.remove_red_eye
                  ),
                  onPressed: (){

                  },
                ),


              ],

              // Display a placeholder widget to visualize the shrinking size.
              // Make the initial height of the SliverAppBar larger than normal.
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return ListTile(
                      onTap: (){


                      },
                      title: Text('Song title', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,)),
                      leading: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                          maxWidth: 64,
                          maxHeight: 64,
                        ),
                        child: Image.network('http://10.132.1.93:8000/media/profile_pics/aspca.jpg'),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.red,
                        ),
                        onPressed: (){
                          showBottomSheet();
                        },
                      ),
                      subtitle: Text('By: Billy Eillish', style: TextStyle(color: Colors.grey),),
                    );
                  },
                  childCount: 7
              ),
            ),
          ],
        )
    );
  }
}