import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewAllStudentCodes extends StatelessWidget{
  final String teachID;
  final String classID;
  final String projectID;
  final String title;

  ViewAllStudentCodes({this.teachID, this.classID, this.projectID, this.title});

  buildList() async {
    List<ListTile> tiles = [
      ListTile(
        title: Text("Student's Name: Student's Code", 
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold)), 
      )
    ];

    var projStudents = await Firestore.instance.collection('Teachers').document(teachID).
      collection('Classes').document(classID).collection('Projects').document(projectID).collection('Students').getDocuments();

    for (var studCode in projStudents.documents) {
      var studentID = studCode['student'];
      var name;
      await Firestore.instance.collection('Teachers').document(teachID).
        collection('Classes').document(classID).collection('Roster').document(studentID).get().then((doc) { name = doc['name'];});
      tiles.add(ListTile(
        title: Text(name + ': ' + studCode.documentID),
      ));

    }

    if (tiles.length < 2) {
      tiles.add(ListTile(
        title: Text("The class this project is assigned to has no students"),
      ));
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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