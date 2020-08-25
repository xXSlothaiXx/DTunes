import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'home/home.dart';
import 'library/library.dart';
import 'discover/discover.dart';
import 'package:webview_flutter/webview_flutter.dart';


class GitPage extends StatefulWidget {


  @override
  _GitPageState createState() => _GitPageState();
}

class _GitPageState extends State<GitPage> {

  String HOST;

  /**
   * Get the current youtube API key stored in the django database to set it
   * in shared preferences
   * 
   * Might need to move this to the library.dart file
   */



  /**
   * Bottom navigation bar index selection
   */






  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Server Setup'),
      
        backgroundColor: Colors.black87,
        
      ),
      body: WebView(
        initialUrl: "https://github.com/xXSlothaiXx/DTunes",
      )
     

    );
  }
}