import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:sensational_science/Services/firebaseStorage/fireStorageService.dart';

class DeleteProjectFromClass extends StatefulWidget{
  final String teachID;
  final String classID;
  final String projectID;

  DeleteProjectFromClass({this.teachID, this.classID, this.projectID});
  @override
  _DeleteProjectFromClassState createState() => _DeleteProjectFromClassState();
}
class _DeleteProjectFromClassState extends State<DeleteProjectFromClass> {
  bool _ackDelete = false;

  @override
  void setState(fn) {
    _ackDelete = false;
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Project"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
          actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.home, color: Colors.black),
              label: Text('Home', style: TextStyle(color: Colors.black)),
          onPressed: () {
               Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>TeacherHome()),
               );
              },
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            StreamBuilder(
              stream: Firestore.instance
              .collection('Teachers')
              .document(widget.teachID)
              .collection('Classes')
              .document(widget.classID)
              .collection('Projects')
              .document(widget.projectID)
              .snapshots(),
              builder: (BuildContext context, snapshot) {
                if(!snapshot.hasData) return new Text('...Loading');
                return new Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: new ListView(
                      children: [
                        new ListTile(
                          title: Text(snapshot.data['projectTitle']),
                          subtitle: Text('Project Title'),
                        ),
                        new ListTile(
                          title: Text(snapshot.data['dueDate'].toDate().toString()),
                          subtitle: Text('Project Due Date'),
                        ),
                        new ListTile(
                          title: Text(widget.classID),
                          subtitle: Text('Class that this project is assigned to'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Text("Once you delete this project from this class you cannot recover it. It will delete all student codes and asociated submissions and it will delete this project from this class. It will still be available as a project to add to a class.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CheckboxListTile(
                    title: new Text("I understand that I cannot undo deleting this project from the class and I would still like to proceed with deleting this project form this class"),
                    value: _ackDelete,
                    onChanged: (bool value) {
                      setState(() {
                        _ackDelete = value;
                      });
                    }
                  ),
                  RaisedButton(
                    onPressed: () async {
                      if(_ackDelete) {
                        var studentCodes = await Firestore.instance.collection('Teachers')
                        .document(widget.teachID)
                        .collection('Classes')
                        .document(widget.classID)
                        .collection('Projects')
                        .document(widget.projectID)
                        .collection('Students')
                        .getDocuments();
                        var roster = await Firestore.instance.collection('Teachers')
                        .document(widget.teachID)
                        .collection('Classes')
                        .document(widget.classID)
                        .collection('Roster');
                        //delete each project student code from the top level codes collection
                        await Firestore.instance.runTransaction((transaction) async {
                          studentCodes.documents.forEach((element) async {
                            await transaction.delete(Firestore.instance.collection('codes').document(element.documentID));
                          });
                        });
                        //delete codes from student list of codes in class roster
                        studentCodes.documents.forEach((element) async { 
                          var deleteVal = [];
                          deleteVal.add({widget.projectID: element.documentID});
                          await roster.document(element.data['student']).updateData({
                            "codes": FieldValue.arrayRemove(deleteVal)
                          });
                        });
                        //delete all information associated with this project in firebase storage 
                        await FireStorageService.loadImage(context, '${widget.teachID}/${widget.classID}/${widget.projectID}');
                        //delete the project from the class
                        await Firestore.instance.runTransaction((transaction) async {
                          await transaction.delete(Firestore.instance.collection('Teachers')
                          .document(widget.teachID)
                          .collection('Classes')
                          .document(widget.classID)
                          .collection('Projects')
                          .document(widget.projectID));
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Project Deleted"),
                              content: Text("The project and all associated student codes and answers have been deleted from this class"),
                              actions: [
                                RaisedButton(
                                  child: Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }
                                )
                              ],
                            );
                          }
                        );
                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Delete Not Acknowledged"),
                              content: Text("You must acknowledge the terms of deleting a project prior to deleting. Read the terms and check the box if desired and try again."),
                              actions: [
                                RaisedButton(
                                  child: Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }
                                )
                              ],
                            );
                          }
                        );
                        return;
                      }
                    },
                    child: Text('Delete Project From Class'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


