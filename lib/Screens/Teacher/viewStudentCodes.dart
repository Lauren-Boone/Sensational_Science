import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewStudentCodes extends StatelessWidget{
  final String teachID;
  final String classID;
  final String studentID;
  final String name;

  ViewStudentCodes({this.teachID, this.classID, this.studentID, this.name});

  buildList() async {
    List<ListTile> tiles = [
      ListTile(
        title: Text("Project Title: Student Code", 
          textAlign: TextAlign.center,), 
        subtitle: Text("Project due date",
          textAlign: TextAlign.center,),
      )
    ];

    var codeList = await Firestore.instance.collection('Teachers').document(teachID).
      collection('Classes').document(classID).collection('Roster').document(studentID).get();
    var projectList = Firestore.instance.collection('Teachers').document(teachID).
        collection('Classes').document(classID).collection('Projects');
    if (codeList.data.containsKey('codes') && codeList.data['codes'].length > 0) {
      for (var pair in codeList['codes']) {
        for (var key in pair.keys) {
          await projectList.document(key).get().then((doc) {
            tiles.add(ListTile(
              title: Text(doc['projectTitle'] + ': ' + pair[key]),
              subtitle: Text(doc['dueDate'].toDate().toString()),
            ));
          });
        }
      }
    }

    if (tiles.length < 2) {
      tiles.add(ListTile(
        title: Text("The class has no projects assigned yet"),
      ));
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name + "'s Project Access Codes"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future: buildList(),
          builder: (context, codes) {
            if (!codes.hasData) {
              return Text("...Loading");
            } else {
              return ListView(
                children: codes.data, 
              );
            }
          }
        ),
      ),
    );
  }

}