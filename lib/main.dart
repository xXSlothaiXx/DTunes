import 'package:flutter/material.dart';
import 'network_list.dart';
import 'db/database_creator.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red,
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black)
      ),
      title: "DTunes",
      home: Scaffold(

        body: NetworkPage(),
      ),
    );
  }
}
