import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/Posting.dart';
import 'login.dart'; 

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String HOST;

  Posting _action = Posting(); 

  bool is_loading = false; 

  /**
   * 
   * Get current selected network
   * 
   * CF
   */

  getNetwork() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final network = prefs.getString('network');
    HOST = network;

  }

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
              Text('Failed to create user with provided information. Make sure you use a secure Username and Password!!', style: TextStyle(color: Colors.white)),
             
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


authenticate(username, email, password) async {
    String status = await _action.register(username , email,  password); 
    is_loading = true; 

    if(status == "Success"){
      is_loading = false; 
       Navigator.pop(context);

    }else if(status == "Failure"){
      _showMyDialog();
    }

  }

  /**
   * 
   * Registration Method for network
   * 
   * CF
   */



  /**
   * username, email and password text controllers
   */

  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();


  /**
   * 
   * Text section component
   */

  Container textSection() {
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
              txtUser("User", Icons.verified_user),
              SizedBox(height: 30.0),
              txtEmail("Email", Icons.email),
              SizedBox(height: 30.0),
              txtPassword("Password", Icons.lock),
              SizedBox(height: 60.0),
              GestureDetector(
                onTap: () {
                  authenticate(usernameController.text, emailController.text,
                      passwordController.text); 
                 
                },
                child: Container(
                  height: 60,
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Center(
                    child: Text(
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16
                        )
                    ),
                  ),

                ),
              )
            ],
          ),
        )
    );
  }


  /**
   * Username text field component
   */

//OUR USERNAME TEXT FIELD
  TextFormField txtUser(String title, IconData icon) {
    return TextFormField(
      controller: usernameController,
      style: TextStyle(color: Colors.grey),
      decoration: InputDecoration(
          fillColor: Colors.grey[800],
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          hintText: title,
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon)
      ),

    );
  }

   /**
   * Email text field component
   */


  TextFormField txtEmail(String title, IconData icon) {
    return TextFormField(
      controller: emailController,
      style: TextStyle(color: Colors.grey),
      decoration: InputDecoration(
          fillColor: Colors.grey[800],
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          hintText: title,
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon)
      ),

    );
  }


   /**
   * Password text field component
   */



//OUR USERNAME TEXT FIELD
  TextFormField txtPassword(String title, IconData icon) {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      style: TextStyle(color: Colors.grey),
      decoration: InputDecoration(
          fillColor: Colors.grey[800],
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          hintText: title,
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon)
      ),
    );
  }

  /**
   * 
   * DTunes Header/Need to add logo
   * 
   */


  Container headerSection() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Container(
          width: 600,
          child: Center(
            child: Column(
              children: <Widget>[

                ListTile(
                  title: Text('DTunes',
                      style: TextStyle(
                        fontSize: 50.0,
                        color: Colors.red,
                      ),
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


  @override
  void initState(){
    super.initState();
    this.getNetwork();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Register', style: TextStyle(color: Colors.white),),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              color: Colors.black87,
              height: MediaQuery.of(context).size.height,

              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  headerSection(),
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