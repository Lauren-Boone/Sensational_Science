import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';
import 'package:sensational_science/models/user.dart';
import 'package:sensational_science/Screens/Teacher/viewStudentCodes.dart';


class AddRoster extends StatefulWidget{
  final String name;
  AddRoster({this.name});
 @override
  _AddRosterState createState() => _AddRosterState();
}


class _AddRosterState extends State<AddRoster>{
  String name;
  List<DynamicWidget> roster=[];
  Random numberGenerator = new Random();

  addStudent(){
    roster.add(new DynamicWidget());
    setState((){
    });
  }

 submitData(teachID) async {
  final int count = roster.length;
  //String val='Success!';
  CollectionReference classRoster = Firestore.instance.collection('Teachers').document(teachID).collection('Classes').document(widget.name).collection('Roster');
  CollectionReference classProjects = Firestore.instance.collection('Teachers').document(teachID).collection('Classes').document(widget.name).collection('Projects');
  DocumentReference classInfo = Firestore.instance.collection('Teachers').document(teachID).collection('Classes').document(widget.name);
  //increment the count of students in the class
  classInfo.get().then((doc) async{
    classInfo.updateData({'students':  doc.data['students']+count});
  });
  //add students and project codes for existing projects
  roster.forEach((e) async{
    DocumentReference newStudent = await classRoster.add({'name':e.controller.text});
    QuerySnapshot eachProject = await classProjects.getDocuments();
    eachProject.documents.forEach((project) async {
      bool exists = false;
      int newCode;
      do {
        newCode = numberGenerator.nextInt(10000000);
        newCode = newCode<1000000?newCode+999999:newCode;        
        await Firestore.instance.collection('codes').document(newCode.toString()).get().then((doc) {
          exists = doc.exists?true:false;
        });
        //print('code: ' + newCode.toString() + ' exists: ' + exists.toString());
      } while (exists);
      await classProjects.document(project.documentID).collection('Students')
        .document(newCode.toString())
        .setData({
          'student': newStudent.documentID, //student doc id in roster
          'completed': false, //has student submitted data
          'name': e.controller.text, //student's name for reference
        });
      await newStudent.setData({
        'codes': FieldValue.arrayUnion([
          {project.documentID: newCode.toString()}
        ]) //list of codes for each student for all projects, {projectCode : studentCode}
      }, merge: true);
      await Firestore.instance
        .collection('codes')
        .document(newCode.toString())
        .setData({
          'Teacher': teachID, //teacher doc id
          'Class': widget.name, //class doc id
          'Student': newStudent.documentID, //student doc id in roster
          'Name': e.controller.text, //student name in roster
          'Project': project.documentID, //project doc id in class
          'ProjectID': project.data['projectID'], //project doc id in top level project collection
          'ProjectTitle': project.data['projectTitle'], //project title
          'DueDate': project.data['dueDate'], //project due date
          'Subject': project.data['projectSubject'], //project subject
      });
    });
  }); 


  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Students added!'),
        content: Text('Students have been added to the class'),
        actions: <Widget>[
          RaisedButton(child: Text("Close"),
            onPressed: () {Navigator.pop(context);},
          ),
        ]
      );
    },
  );
  roster = [];
  setState(() {});
}
Color getColor(){
    RandomColor _randomColor = RandomColor();

Color _color = _randomColor.randomColor(
  colorSaturation: ColorSaturation.lowSaturation,
  colorHue: ColorHue.green,
  colorBrightness: ColorBrightness.primary,
);
return _color;
}
String success = '';
@override

Widget build(BuildContext context){
  final user = Provider.of<User>(context);
    return Material(
          child: Scaffold(
        
        //backgroundColor: Colors.green[200],
        appBar: AppBar(
          title: Text("View & Add To Roster"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          
          actions: <Widget>[
            FlatButton.icon(
               icon: Icon(Icons.home, color: Colors.black),
                label: Text('Home', style: TextStyle(color: Colors.black)),
                onPressed: () {
               Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherHome()),
                  (Route<dynamic> route) => false,
                );
                        
                },
            ),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              new Text('Current Roster', style: TextStyle(fontSize: 20)),
              new Text('Select a student to view their project access codes', style: TextStyle(fontSize: 16)),
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
                    child: Container(child: DecoratedBox(
                        decoration: BoxDecoration(
                          //color: getColor(),
                        ),
                        child: SizedBox(height: MediaQuery.of(context).size.height * 0.8,
                      child: new ListView(
                        children: snapshot.data.documents.map<Widget>((doc){
                          return Card(
                            color: getColor(),
                                                      child: new ListTile(
                              //hoverColor: Colors.blue,
                              title: new Text(doc['name']),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) =>ViewStudentCodes(teachID: user.uid, classID: widget.name, studentID: doc.documentID, name: doc['name']),
                                ),);
                              }
                            ),
                          );
                        }).toList(),
                      ),)
                        ),)
                  );
                },
              ),
              new Divider(
                color: Colors.deepPurple,
                height: 10.0,
              ),
              new Text('Students to add:', style: TextStyle(fontSize: 20)),
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