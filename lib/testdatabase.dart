import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/Screens/user_list.dart';
import 'package:sensational_science/Screens/user_tile.dart';
import 'Services/database.dart';
import 'models/teacher.dart';



class TestDatabase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Teacher>>.value(
        value: DatabaseService().user,
             child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('User Data'),
         
        ),
        body: UserList(),
      ),
      
    );
  }
}