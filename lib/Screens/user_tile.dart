import 'package:flutter/material.dart';
import '../models/teacher.dart';



class UserTile extends StatelessWidget {
  final Teacher teacher;
  UserTile({this.teacher});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.green[300],
          ),
          title: Text(teacher.name),
          


        ),
      ),
    );
  }
}