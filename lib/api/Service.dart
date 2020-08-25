import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../models/Artists.dart';
import '../models/Artists.dart';
import '../models/Artist.dart';
import '../models/Songs.dart';
import '../models/Song.dart';
import '../models/Playlists.dart';
import '../models/Playlist.dart';
import '../models/Users.dart'; 
import 'package:shared_preferences/shared_preferences.dart';



// To parse this JSON data, do
//
//     final artist = artistFromJson(jsonString);


class Service {



  static String url; 
  static String auth_token; 

  static setToken() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    final token  = prefs.getString('token'); 
    final network = prefs.getString('network');

    url = network; 
    auth_token = token; 
  
  }

/******************************************************************
   * 
   * THIS IS FOR THE ARTIST MODEL
   *************************************************************/ 

static Future<Artist> fetchArtist(pk) async {
  final response =
      await http.get('$url/dtunes/artists/artist/$pk/', headers: {
         "Accept":"application/json",
          "Authorization": "Token $auth_token"

      } );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Artist.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

static Future<List<Artists>> getArtists() async {
    try {
      final response = await http.get('$url/dtunes/artists/artists/', headers: {
         "Accept":"application/json",
          "Authorization": "Token $auth_token"

      });
      if(response.statusCode == 200){
        final List<Artists> artists = artistsFromJson(response.body);
        return artists;
      }else{
        return List<Artists>(); 
      }

    }catch(e){
      return List<Artists>(); 

    }

  }

  //PUBLIC RELATED CONTENT

static Future<Artist> fetchPublicArtist(pk) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final network = prefs.getString("public_network"); 

  final response =
      await http.get('$network/dtunes/artists-public/public-artist/$pk/');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Artist.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

static Future<List<Artists>> getPublicArtists() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final network = prefs.getString("public_network"); 
    try {
      final response = await http.get('$network/dtunes/artists-public/public-artists/');
      if(response.statusCode == 200){
        final List<Artists> artists = artistsFromJson(response.body);
        return artists;
      }else{
        return List<Artists>(); 
      }

    }catch(e){
      return List<Artists>(); 

    }

  }


  /******************************************************************
   * 
   * THIS IS FOR THE SONG MODEL
   *************************************************************/ 






  static Future<List<Songs>> getTopSongs() async {
    try {
      final response = await http.get('$url/dtunes/songs/top-songs/', headers: {
         "Accept":"application/json",
          "Authorization": "Token $auth_token"

      });
      if(response.statusCode == 200){
        final List<Songs> songs = songsFromJson(response.body);
        return songs;
      }else{
        return List<Songs>(); 
      }

    }catch(e){
      return List<Songs>(); 

    }

  }


    static Future<List<Songs>> getAllSongs() async {
    try {
      final response = await http.get('$url/dtunes/songs/songs/', headers: {
         "Accept":"application/json",
          "Authorization": "Token $auth_token"

      });
      if(response.statusCode == 200){
        final List<Songs> songs = songsFromJson(response.body);
        return songs;
      }else{
        return List<Songs>(); 
      }

    }catch(e){
      return List<Songs>(); 

    }

  }

  //Get Songs by a specific artist
  static Future<List<Songs>> getArtistSongs(pk) async {
    try {
      final response = await http.get('$url/dtunes/songs/artist-songs/$pk/', headers: {
         "Accept":"application/json",
          "Authorization": "Token $auth_token"

      });
      if(response.statusCode == 200){
        final List<Songs> songs = songsFromJson(response.body);
        return songs;
      }else{
        return List<Songs>(); 
      }

    }catch(e){
      return List<Songs>(); 

    }
  }


  static Future<List<Songs>> getPlaylistSongs(pk) async {
    try {
      final response = await http.get('$url/dtunes/songs/song-playlist/$pk/', headers: {
         "Accept":"application/json",
          "Authorization": "Token $auth_token"

      });
      if(response.statusCode == 200){
        final List<Songs> songs = songsFromJson(response.body);
        return songs;
      }else{
        return List<Songs>(); 
      }

    }catch(e){
      return List<Songs>(); 

    }
  }

  static Future<List<Songs>> searchSongs(query) async {
    try {
      final response = await http.get('$url/dtunes/songs/search/?search=${query}', headers: {
         "Accept":"application/json",
          "Authorization": "Token $auth_token"

      });
      if(response.statusCode == 200){
        final List<Songs> songs = songsFromJson(response.body);
        return songs;
      }else{
        return List<Songs>(); 
      }

    }catch(e){
      return List<Songs>(); 

    }

  }

  //PUBLIC RELATED CONTENT
static Future<Song> fetchPublicSong(pk) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final network = prefs.getString("public_network"); 

  final response =
      await http.get('$network/dtunes/songs-public/public-song/$pk/');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Song.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

static Future<List<Songs>> getPublicSongs() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final network = prefs.getString("public_network"); 

    try {
      final response = await http.get('$network/dtunes/songs-public/public-songs/');
      if(response.statusCode == 200){
        final List<Songs> songs = songsFromJson(response.body);
        return songs;
      }else{
        return List<Songs>(); 
      }

    }catch(e){
      return List<Songs>(); 

    }

  }


  static Future<List<Songs>> getPublicArtistSongs(pk) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final network = prefs.getString("public_network"); 

    try {
      final response = await http.get('$network/dtunes/artist-public/public-artist-song/$pk/?format=json');
      if(response.statusCode == 200){
        final List<Songs> songs = songsFromJson(response.body);
        return songs;
      }else{
        return List<Songs>(); 
      }

    }catch(e){
      return List<Songs>(); 

    }

  }

static Future<List<Songs>> searchPublicSongs(query) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final network = prefs.getString("public_network"); 

    try {
      final response = await http.get('$network/dtunes/songs-public/search/?search=${query}', headers: {
         "Accept":"application/json",
          "Authorization": "Token $auth_token"

      });
      if(response.statusCode == 200){
        final List<Songs> songs = songsFromJson(response.body);
        return songs;
      }else{
        return List<Songs>(); 
      }

    }catch(e){
      return List<Songs>(); 

    }

  }

    /******************************************************************
   * 
   * THIS IS FOR THE PLAYLIST MODEL
   *************************************************************/ 
  static Future<Playlist> fetchPlaylist(pk) async {
  final response =
      await http.get('$url/dtunes/playlists/playlist/$pk/', headers: {
         "Accept":"application/json",
          "Authorization": "Token $auth_token"

      });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Playlist.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

  static Future<List<Playlists>> getPlaylists() async {
    try {
      
      final response = await http.get('$url/dtunes/playlists/playlists/', headers: {
         "Accept":"application/json",
          "Authorization": "Token $auth_token"
      });
      if(response.statusCode == 200){
        final List<Playlists> playlists = playlistsFromJson(response.body);
        return playlists;
      }else{
        return List<Playlists>(); 
      }

    }catch(e){
      return List<Playlists>(); 

    }

  }


   /******************************************************************
   * 
   * Network info api calls
   *************************************************************/ 


static Future<List<Artists>> getNetworkArtists() async {
    try {
      final response = await http.get('$url/dtunes/artists/artists/', headers: {
         "Accept":"application/json",
          "Authorization": "Token $auth_token"

      });
      if(response.statusCode == 200){
        final List<Artists> artists = artistsFromJson(response.body);
        return artists;
      }else{
        return List<Artists>(); 
      }

    }catch(e){
      return List<Artists>(); 

    }

  }

static Future<List<Songs>> getNetworkSongs() async {
    try {
      final response = await http.get('$url/dtunes/songs/songs/', headers: {
         "Accept":"application/json",
          "Authorization": "Token $auth_token"

      });
      if(response.statusCode == 200){
        final List<Songs> songs = songsFromJson(response.body);
        return songs;
      }else{
        return List<Songs>(); 
      }

    }catch(e){
      return List<Songs>(); 

    }

  }

static Future<List<Playlists>> getNetworkPlaylists() async {
    try {
      final response = await http.get('$url/dtunes/playlists/playlists/', headers: {
         "Accept":"application/json",
          "Authorization": "Token $auth_token"

      });
      if(response.statusCode == 200){
        final List<Playlists> playlists = playlistsFromJson(response.body);
        return playlists;
      }else{
        return List<Playlists>(); 
      }

    }catch(e){
      return List<Playlists>(); 

    }

  }


static Future<List<Users>> getNetworkUsers() async {
    try {
      final response = await http.get('$url/dtunes/auth/users/', headers: {
         "Accept":"application/json",
          "Authorization": "Token $auth_token"

      });
      if(response.statusCode == 200){
        final List<Users> users = usersFromJson(response.body);
        return users;
      }else{
        return List<Users>(); 
      }

    }catch(e){
      return List<Users>(); 

    }

  }


}