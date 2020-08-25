import 'package:flutter/material.dart';
import 'db/network.dart';
import 'db/data_repository.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'github.dart'; 




class NetworkPage extends StatefulWidget {
  NetworkPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  final _formKey = GlobalKey<FormState>();
  Future<List<Network>> future;
  String name;
  int id;

  /**
   * Get the DB for sqflite
   */

  @override
  initState() {
    super.initState();
    future = RepositoryServiceNetwork.getAllNetworks();
  }

  /**
   * 
   * Sqflite database query function. CRUD operations
   */

  void selectNetwork(String network) async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    prefs.setString("network", network);
  }

  void readData() async {
    final network = await RepositoryServiceNetwork.getNetwork(id);
    print(network.name);
  }

  updateTodo(Network network) async {
    network.name = 'please 🤫';
    await RepositoryServiceNetwork.updateTodo(network);
    setState(() {
      future = RepositoryServiceNetwork.getAllNetworks();
    });
  }

  deleteTodo(Network network) async {
    await RepositoryServiceNetwork.deleteNetwork(network);
    setState(() {
      id = null;
      future = RepositoryServiceNetwork.getAllNetworks();
    });
  }

  /**
   * Build Individual network component
   */

  ListTile buildItem(Network network) {
    return ListTile(
      onTap: () {
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()));
              selectNetwork('${network.network}');


        });
      },
      title: Text('${network.name}', style: TextStyle(color: Colors.white)),
      leading: Icon(
        Icons.network_check,
        color: Colors.red,
      ),
      subtitle: Text('${network.network}', style: TextStyle(color: Colors.grey)),
      trailing: IconButton(
        icon:  Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () {
          setState(() {
            deleteTodo(network);
          });
        },
      )
    );
  }




  /**
   * 
   * Name controller for editing the name of your selected network
   * 
   */

  TextEditingController nameController = new TextEditingController();


/**
 * 
 * Text field component for name of network
 * 
 */

  _buildNameComposer(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      color: Colors.grey[800],
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.music_note, color: Colors.red),
          ),
          Expanded(
              child: TextField(
                controller: nameController,
                decoration: InputDecoration.collapsed(
                    hintText: 'Input name of network'
                ),

              )

          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.red),
            onPressed: (){
              setState(() {

              });
            },
          ),
        ],
      ),



    );
  }

  /**
   * 
   * Text controller for adding the physical IP/Web address
   */

  TextEditingController networkController = new TextEditingController();


  _buildNetworkComposer(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      color: Colors.grey[800],
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.music_note, color: Colors.red),
          ),
          Expanded(
              child: TextField(
                controller: networkController,
                decoration: InputDecoration.collapsed(
                    hintText: 'Input address of network'
                ),

              )

          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.red),
            onPressed: (){
              setState(() {




              });
            },
          ),
        ],
      ),



    );
  }

  /**
   * Add network using this function
   */


  void createNetwork(String name, String networkAddress) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      int count = await RepositoryServiceNetwork.networksCount();
      final network = Network(count, name, networkAddress);
      await RepositoryServiceNetwork.addNetwork(network);
      setState(() {
        id = network.id;
        future = RepositoryServiceNetwork.getAllNetworks();
      });
      print(network.id);
    }


  }

  /**
   * Display bottom sheet when adding network
   */

  void showBottomSheet(){
    showModalBottomSheet(context: context, builder: (context){
      return Column(
        children: <Widget>[
          Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Add your personal network', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _buildNameComposer(),
                        SizedBox(
                          height: 20,
                        ),
                        _buildNetworkComposer(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,

                  ),
                  GestureDetector(
                    onTap: (){
                      createNetwork(nameController.text, networkController.text);


                    },
                    child:  Container(
                      height: 50,
                      width: 200,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15.0)
                      ),
                      child: Center(
                        child: Text(
                            'Add Device',
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
              )
          ),
        ],
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Choose A Device'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.web_asset,
                color: Colors.white,
              ),
              onPressed: (){
                setState(() {
                   Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GitPage()));

                  
                });
              },
            )
         
        ],
        backgroundColor: Colors.black87,
        
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[


          FutureBuilder<List<Network>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    children: snapshot.data.map((network) => buildItem(network))
                        .toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          setState(() {
            showBottomSheet();
          });
        },
        child: Icon(Icons.add),
      ) ,
    );
  }
}