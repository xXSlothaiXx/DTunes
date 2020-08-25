import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../../../api/Service.dart';
import '../../../api/Service.dart';
import '../../../models/Users.dart'; 




class UsersPage extends StatefulWidget {

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage > {

  String HOST;


List<Users> _users; 


  @override
  void initState() {

    Service.getNetworkUsers().then((users){
      setState(() {
        _users = users; 
        print("LOADING IN NEW METHOD FAM"); 
      });
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('All Users'),
        backgroundColor: Colors.black87,
      ),
      body: ListView.builder(
          itemCount: _users == null ? 0: _users.length,
          itemBuilder: (context, index){
            Users user = _users[index]; 
            return ListTile(
              leading: Icon(
                Icons.supervised_user_circle,
                color: Colors.red,
              ),
            title: Text(user.username, style: TextStyle(color: Colors.white),),
                subtitle: Text(user.id.toString(), style: TextStyle(color: Colors.grey),),
            );
          }
      ),
    );
  }
}