import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';
import 'package:sensational_science/models/user.dart';
import 'dart:async';
import '../Size_Config.dart';
import 'classInfo.dart';

class ClassListPage extends StatefulWidget {
  @override
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassListPage> {
  @override
  getClassList(String teachID) {
    return (Firestore.instance
        .collection('Teachers')
        .document(teachID)
        .collection('Classes')
        .snapshots());
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context); 
    final user = Provider.of<User>(context);
    return Center(
      child: Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(title: FittedBox(fit:BoxFit.fitHeight, child: Text("Classes")), actions: <Widget>[
        FlatButton.icon(
          icon: Icon(Icons.home, color: Colors.black),
          label: Text('Home', style: TextStyle(color: Colors.black)),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => TeacherHome()),
            );
          },
        ),
      ]),
      body: Material(
        color: Colors.green[200],
        child: new StreamBuilder<QuerySnapshot>(
            stream: getClassList(user.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return new Text('..Loading');
              return Card(
                child: new ListView(
                  children: snapshot.data.documents.map((document) {
                    return Container(
                      height: SizeConfig.verticalSize * 13,
                      child: Card(
                      child: new ListTile(
                        title: FittedBox(fit:BoxFit.scaleDown, child: new Text(document['name'], maxLines: 2,)), 
                        subtitle: FittedBox(fit:BoxFit.scaleDown, child: new Text('Click to View Class Info', maxLines: 2),), 
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () => {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ClassInfo(
                                  name: document.documentID, uid: user.uid),
                            ),
                          )
                        },
                      ),
                    ),
                    );
                  }).toList(),
                ),
              );
            }),
      ),
    )
    );
  }
}
