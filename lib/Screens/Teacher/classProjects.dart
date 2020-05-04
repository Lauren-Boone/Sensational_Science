import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:provider/provider.dart';
import 'package:sensational_science/models/user.dart';



class ViewClassProjects extends StatefulWidget{
  final String name;
  ViewClassProjects({this.name});
 @override
  _ViewClassProjectsState createState() => _ViewClassProjectsState();
}


class _ViewClassProjectsState extends State<ViewClassProjects>{

  @override

  Widget build(BuildContext context){
    final user = Provider.of<User>(context);
      return Scaffold(
        appBar: AppBar(
          title: Text("View " + widget.name + " Projects"),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              new StreamBuilder(
                stream: Firestore.instance.collection('Teachers').
                  document(user.uid)
                  .collection('Classes')
                  .document(widget.name)
                  .collection('Projects')
                  .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if(!snapshot.hasData) return new Text('...Loading');
                  return new Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: new ListView(
                        children: snapshot.data.documents.map<Widget>((doc){
                          return new ListTile(
                            title: new Text(doc['projectTitle']),
                            subtitle: new Text('Due Date: ' + doc['dueDate'].toDate().toString()),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
      
    
  }
}
