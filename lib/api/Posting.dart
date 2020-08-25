import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Service.dart'; 
import 'package:shared_preferences/shared_preferences.dart';


class Posting {

register(String username, password, email) async {
    Map data = {
      'username': username,
      'email': password,
      'password': email,
    };

    var jsonData = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final network = prefs.getString('network');
    var response = await http.post(
        "$network/dtunes/auth/register/", body: data);
    //if this user gets a token, send them to the home page
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      print(jsonData);
      print('Successful sign in');

      return "Success"; 

      //this is to move us to the next page
      //print(jsonData['token']);
      //var auth_token = jsonData['token'];
    } else {
      return "Failure"; 
    }
  }


    //THIS IS OUR SIGN IN METHOD
signIn(String username, password) async {
  
    Map data = {
      'username': username,
      'password': password
    };

    var jsonData = null;
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    final network = prefs.getString('network');
    var response = await http.post("$network/api-token-auth/", body: data);
    //if this user gets a token, send them to the home page
    if(response.statusCode == 200){
      jsonData = json.decode(response.body);
      final auth_token = jsonData['token'];
    

        prefs.setString("token", jsonData['token']);
        print(prefs.getString("token"));
        Service.setToken(); 
        //Navigator.push(
            //context,
            //MaterialPageRoute(builder: (context) => MainPage()));
     
      //this is to move us to the next page
      //print(jsonData['token']);
      //var auth_token = jsonData['token'];

      return "Success"; 


    }else{

       return "Failure";  
      
    }
  }


Future<String> addToPlaylist(int songid, playlistid) async{
  
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final network = prefs.getString('network');


    Map data = {
      'songid': songid.toString(),
    };

    http.Response response = await http.post(
        Uri.encodeFull("$network/dtunes/playlists/playlist-add/$playlistid/?format=json"),
        body: data,
        headers: {
          "Accept":"application/json",
          "Authorization": "Token ${token} "
        }
    );
    if(response.statusCode == 200){
      return "Success"; 
    }else{
      return "Failure";
    }
  }


Future<String> removeFromPlaylist(int songid, playlistid) async{
   
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final network = prefs.getString('network');

    Map data = {
      'songid': songid.toString(),
    };

    http.Response response = await http.post(
        Uri.encodeFull("$network/dtunes/playlists/playlist-remove/$playlistid/?format=json"),
        body: data,
        headers: {
          "Accept":"application/json",
          "Authorization": "Token ${token} "
        }
    );
   
   if(response.statusCode == 200){
     print("Succesfully done");
     return "Success!";
   }else{
     return "Song not removed"; 
   }
    
  }


Future<String> createPlaylist(String name) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final network = prefs.getString('network');
    Map data = {
      'name': name,
    };

    http.Response response = await http.post(
        Uri.encodeFull("$network/dtunes/playlists/playlists/?format=json"),
        body: data,
        headers: {
          "Accept":"application/json",
          "Authorization": "Token ${token} "
        }
    );
    if(response.statusCode == 200){
      return "Success";
    }else{
      return "Faliure";
    }
  }


removePlaylist(int playlistid) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final network = prefs.getString('network');

    http.Response response = await http.delete(
        Uri.encodeFull("$network/dtunes/playlists/playlist/$playlistid/?format=json"),
        headers: {
          "Accept":"application/json",
          "Authorization": "Token ${token} "
        }
    );

    if(response.statusCode == 200){
      return 'Success';
    }else{
      return "Failure"; 
    }
    
  }


Future<String> followArtist(pk) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final network = prefs.getString('network');

    http.Response response = await http.post(
        Uri.encodeFull("$network/dtunes/artists/artist-actions/$pk/?format=json"),
        headers: {
          "Accept":"application/json",
          "Authorization": "Token ${token} "
        }
    );

    final jsonData = json.decode(response.body);
    print(jsonData);


    return "Success!";
  }

  


  addSong(String youtube_url) async {
  
    Map data = {
      'video_url': youtube_url
    };

    SharedPreferences  prefs = await SharedPreferences.getInstance();
    final network = prefs.getString('network');
    final token = prefs.getString('token'); 

    http.Response response = await http.post(
        Uri.encodeFull("$network/dtunes/songs/songs/?format=json"),
        body: data, 
        headers: {
          "Accept":"application/json",
          "Authorization": "Token ${token} "
        }
    );
    //if this user gets a token, send them to the home page
    if(response.statusCode == 200){
      //jsonData = json.decode(response.body);

      return "Success"; 
        //Navigator.push(
            //context,
            //MaterialPageRoute(builder: (context) => MainPage()));
     
      //this is to move us to the next page
      //print(jsonData['token']);
      //var auth_token = jsonData['token'];



    }else{

       return "Failure";  
      
    }
  }



}