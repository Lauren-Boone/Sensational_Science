import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:provider/provider.dart';
import 'package:sensational_science/models/user.dart';



class AddRoster extends StatefulWidget{
  final String name;
  AddRoster({this.name});
 @override
  _AddRosterState createState() => _AddRosterState();
}


class _AddRosterState extends State<AddRoster>{
  String name;
  List<DynamicWidget> roster=[];

  addStudent(){
    roster.add(new DynamicWidget());
    setState((){
    });
  }

 submitData(teachID) async {
  //String val='Success!';
  CollectionReference classRoster = Firestore.instance.collection('Teachers').document(teachID).collection('Classes').document(widget.name).collection('Roster');
  CollectionReference classProjects = Firestore.instance.collection('Teachers').document(teachID).collection('Classes').document(widget.name).collection('Projects');
  int count = 0;
  //add students and project codes for existing projects
  roster.forEach((e) async{
    DocumentReference newStudent = await classRoster.add({'name':e.controller.text});
    QuerySnapshot eachProject = await classProjects.getDocuments();
    eachProject.documents.forEach((project) async {
      var codeRef = await classProjects.document(project.documentID).collection('Students').add({
        'student': newStudent.documentID, //student doc id in roster
        'completed': false, //has student submitted data
      });
      await newStudent.setData({
        'codes': FieldValue.arrayUnion([
          {project.documentID: codeRef.documentID}
        ]) //list of codes for each student for all projects, {projectCode : studentCode}
      }, merge: true);
    });
    count++;
  }); 

  //increment the count of students in the class
  DocumentReference classInfo = Firestore.instance.collection("Teachers").document(teachID).collection('Classes').document(widget.name);
  classInfo.get().then((doc) {
    count = count + doc.data['students'];
    print("class student count: " + count.toString());
    classInfo.updateData({'students': count});
  });

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Students added!'),
        content: Text('Students have been added to the class'),
        actions: <Widget>[
          RaisedButton(child: Text("Close"),
            onPressed: () {Navigator.of(context).pop();},
          ),
        ]
      );
    },
  );
  roster = [];
  setState(() {});
}

  /*
  List<String> tags = List.from(doc.data['name']);
  
    if(tags.contains(element.controller.text)==true){
    
    docRef.addData({
      'Name' : FieldValue.arrayRemove([element.controller.text])
    });
    
  }
  else{
    docRef.updateData(
      {
      'Name' : FieldValue.arrayUnion([element.controller.text])
      });
  }
  });
  
  roster.forEach(
    (widget)=>print(widget.controller.text)
  );
}
*/
String success = '';
@override

Widget build(BuildContext context){
  final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("View & Add To Roster"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            new Text('Current Roster'),
            new StreamBuilder(
              stream: Firestore.instance.collection('Teachers').
                document(user.uid)
                .collection('Classes')
                .document(widget.name)
                .collection('Roster')
                .snapshots(),
              builder: (BuildContext context, snapshot) {
                if(!snapshot.hasData) return new Text('...Loading');
                return new Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: new ListView(
                      children: snapshot.data.documents.map<Widget>((doc){
                        return new ListTile(
                          title: new Text(doc['name']),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            new Divider(
              color: Colors.blue,
              height: 10.0,
            ),
            new Text('Students to add:'),
            new Expanded(
              child: new SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: new ListView.builder(
                  itemCount: roster.length,
                  itemBuilder: (_, index)=>roster[index]
                ),
              ),
            ),
              new Container(
              child: Text(success),
            ),
            new RaisedButton(
              child: new Text('Submit Students'),
              onPressed: ()=> submitData(user.uid),
            ),
            new RaisedButton(
              child: new Text('Add Another Student'),
              onPressed: addStudent,
            ),
          ],
        ),
      ),
    );
    
  
}
}

class DynamicWidget extends StatelessWidget{
  final controller = new TextEditingController();
  @override
  Widget build(BuildContext context){
    return Container(
      margin: new EdgeInsets.all(8.0),
      child: new TextField(
        controller: controller,
        decoration: new InputDecoration(hintText: 'Enter Student Name'),
      ),
    );
  }
}