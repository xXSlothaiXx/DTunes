import 'register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'base.dart';
import 'api/Posting.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

  String HOST;

  Posting _action = Posting(); 


  bool _isLoading = false;

  /**
   * Get our network: Need to add this to a class file
   */

  getNetwork() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final network = prefs.getString('network');
    HOST = network;

  }

  authenticate(username, password) async {
    String status = await _action.signIn(username , password); 
    _isLoading = true; 

    if(status == "Success"){
      _isLoading = false; 
       Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainPage()));

    }else if(status == "Failure"){
      _showMyDialog();
    }

  }

  /**
   * Show this dialogue if the login credentials do not work
   */

Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text('DTunes', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Failed to log in with provided credentials', style: TextStyle(color: Colors.white)),
             
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



  /**
   * Username and password text controller
   * Hide password
   */

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();


/**
 * Text section component
 */
  Container textSection(){
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),

        padding: EdgeInsets.symmetric(horizontal: 20.0),
        margin: EdgeInsets.only(top: 30.0),
        child: Center(
          child: Column(
            children: <Widget>[


              SizedBox(height: 30.0),
              txtUser("User", Icons.email),
              SizedBox(height: 30.0),
              txtPassword("Password", Icons.lock),
              SizedBox(height: 60.0),
              GestureDetector(
                onTap: () {
                  authenticate(usernameController.text , passwordController.text);
                },
                child: Container(
                  height: 55,
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Center(
                    child: Text(
                        'Sign in',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16
                        )
                    ),
                  ),

                ),
              ),

            ],
          ),
        )
    );
  }

//OUR USERNAME TEXT FIELD
  TextFormField txtUser(String title, IconData icon){
    return TextFormField(
      controller: usernameController,
      style: TextStyle(color: Colors.grey),
      decoration: InputDecoration(
          fillColor: Colors.grey[800],
          filled: true,
          border:  OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          hintText: title,
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon)
      ),

    );
  }

//OUR USERNAME TEXT FIELD
  TextFormField txtPassword(String title, IconData icon){
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      style: TextStyle(color: Colors.grey),
      decoration: InputDecoration(
          fillColor: Colors.grey[800],
          filled: true,
          border:  OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          hintText: title,
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon)
      ),
    );
  }


//HEADER section for logo and intro to the app

  Container headerSection(){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Container(
          width: 600,
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),

                ListTile(
                  title: Text('DTunes',
                      style: TextStyle(
                        fontSize: 50.0,
                        color: Colors.red,
                      )
                  ),
                  subtitle: Text(
                      '$HOST', style: TextStyle(color: Colors.grey, fontSize: 15)
                  ),
                  leading: Icon(
                    Icons.music_video,
                    color: Colors.red,
                    size: 50,
                  ),
                )
              ],
            ),
          ),
        )
    );
  }


/**
 * Get the network on state
 */


  @override
  void initState(){
    super.initState();
    this.getNetwork();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.account_circle,
            color: Colors.red,
          ),
          onPressed: (){
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));

            });
          },
        ),
        backgroundColor: Colors.black87,
        title: Text('Login', style: TextStyle(color: Colors.white),),
      ),
      body:  CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child:  Container(
              color: Colors.black87,
              height: MediaQuery.of(context).size.height,


              child: _isLoading ? Center(
        
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
        ) : Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  headerSection(),

                  SizedBox(
                    height: 30,
                  ),

                  textSection(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
