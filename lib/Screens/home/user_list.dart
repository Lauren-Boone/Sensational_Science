import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../models/teacher.dart';
import 'user_tile.dart';


class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<Teacher>>(context) ?? [];
    //print(users.documents);
   
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index){
        return UserTile(teacher: users[index]);
      },
    );
  }
}