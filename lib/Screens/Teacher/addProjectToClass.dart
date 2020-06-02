import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:sensational_science/Screens/Teacher/addRoster.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';
import 'package:sensational_science/models/user.dart';
import '../../Shared/styles.dart';

class AddProjectToClass extends StatefulWidget {
  AddProjectToClass({Key key}) : super(key: key);
  @override
  _AddProjectToClassState createState() => _AddProjectToClassState();
}

class _AddProjectToClassState extends State<AddProjectToClass> {
  final _formKey = GlobalKey<FormState>();
  String _class;
  String _project;
  DateTime _date;
  bool hasRoster = true;
  bool myProjectsOnly = true;
  Random numberGenerator = new Random();

Color getColor(){
    RandomColor _randomColor = RandomColor();

Color _color = _randomColor.randomColor(
  colorSaturation: ColorSaturation.lowSaturation,
  colorHue: ColorHue.green,
  colorBrightness: ColorBrightness.primary,
);
return _color;
}
  Future<dynamic> assignProject(
    String uid, String className, String projectID, DateTime dueDate) async {
    //create project under the class
    DocumentReference classDoc = Firestore.instance
        .collection('Teachers')
        .document(uid)
        .collection('Classes')
        .document(className);
    final projectDoc = await Firestore.instance
        .collection('Projects')
        .document(projectID)
        .get();
    final projRef = await classDoc.collection('Projects').add({
      'projectID': projectID, //project doc id in top level project collection
      'projectTitle': projectDoc.data['title'], //project title
      'projectSubject': projectDoc.data['subject'], //project subject
      'dueDate': dueDate, //due date
    });

    //increment project count for class
    classDoc.get().then((doc) {
      int projCount = doc['projects'];
      projCount++;
      classDoc.updateData({'projects': projCount});
    });

    //create a unique 7 digit code for the student, create the code under the project, store the code in the roster
    //under the student, then store the code under the top level codes collection
    final students = await classDoc.collection('Roster').getDocuments();
    for (var student in students.documents) {
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
      await classDoc
        .collection('Projects')
        .document(projRef.documentID)
        .collection('Students')
        .document(newCode.toString())
        .setData({
          'student': student.documentID, //student doc id in roster
          'completed': false, //has student submitted data
          'name': student.data['name'], //student's name for reference
        });
      await classDoc.collection('Roster').document(student.documentID).setData({
        'codes': FieldValue.arrayUnion([
          {projRef.documentID: newCode.toString()}
        ]) //list of codes for each student for all projects, {projectCode : studentCode}
      }, merge: true);
      await Firestore.instance
          .collection('codes')
          .document(newCode.toString())
          .setData({
        'Teacher': uid, //teacher doc id
        'Class': className, //class doc id
        'Student': student.documentID, //student doc id in roster
        'Name': student.data['name'], //student name in roster
        'Project': projRef.documentID, //project doc id in class
        'ProjectID': projectID, //project doc id in top level project collection
        'ProjectTitle': projectDoc.data['title'], //project title
        'dueDate': dueDate, //project due date
        'Subject': projectDoc.data['subject'], //project subject
      });
    }
  }

 _checkForRoster(String uid){
  
     Future<QuerySnapshot> snap=  Firestore.instance.collection('Teachers')
      .document(uid)
      .collection('Classes')
      .document(_class)
      .collection('Roster')
      .getDocuments();
      snap.then((value) => {
        if(value.documents.length == 0){
          this.hasRoster = hasRoster ?? false,
        }
      });
     
  
   
      
  }
  String classname="";
  String project = "";
  String dueDate="";


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return new Material(
      child: new Scaffold(
          appBar: new AppBar(
      title: Text("Add Project To Class"),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context, false),
      ),
      //backgroundColor: Colors.deepPurple,
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
            new FlatButton.icon(
      onPressed: () => {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Material(
                //padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                child: AddProjectToClassHelp(),
              );
            }),

      },
      icon: Icon(Icons.help, color: Colors.black),
      label: Text("Help", style: TextStyle(color: Colors.black)),
            ),
          ],
      ),
          body: new Container(
            //color: appTheme.backgroundColor,
      child: SingleChildScrollView(
              child: new Column(
          children: <Widget>[
             SizedBox(height:20),
            Text("Assign a Project to a Class", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height:20),
          
            Card(
                          child: ExpansionTile(
                            title: Text("Step 1: Choose a Class", textAlign: TextAlign.start, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            //subtitle: Text(classname),
                            key: GlobalKey(),
                            children: <Widget>[
new StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                          .collection('Teachers')
                          .document(user.uid)
                          .collection('Classes')
                          .snapshots(),
                          builder: (context, snapshot) {
              if (!snapshot.hasData)
                          return Center(
                            child: Text("Loading . . ."),
                          );
                          
              return new Container(
               
                          padding: EdgeInsets.only(bottom: 10.0),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: new Row(
                            children: <Widget>[
                              //Text("Class to Assign Project For", style: modalLabel),
                              new Expanded(
                                flex: 4,
                                child: new InputDecorator(
                                  decoration: const InputDecoration(
                                    hintText: 'Choose a class',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  isEmpty: _class == null,
                                  child: new DropdownButton(
                                    value: _class,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _class = newValue;
                                        classname="Selected: "+ _class;
                                        _checkForRoster(user.uid);
                                        //print(_class);
                                      });
                                    },
                                    items: snapshot.data.documents
                                        .map((DocumentSnapshot document) {
                                      return new DropdownMenuItem<String>(
                                        value: document.documentID,
                                        child: new Container(
                                          decoration: new BoxDecoration(
                                            //color: getColor(),
                                            borderRadius:
                                                new BorderRadius.circular(3.0),
                                          ),
                                          height: 32.0,
                                          width: MediaQuery.of(context).size.width *
                                              0.52,
                                          padding: EdgeInsets.fromLTRB(
                                              10.0, 5.0, 10.0, 0.0),
                                          child: Text(document.data['name'], style: TextStyle(color: Colors.black)),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
              );
                          },
              ),

                            ],
                            ),
            ),
            
            SizedBox(height:10),
            Card(
                          child: ExpansionTile(
                            title: Text("Step 2: Choose a type of project to select from", textAlign: TextAlign.start, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
         children: <Widget>[
               Padding(
                          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.1,
              bottom: 10.0),
                          child: Row(
              children: [
                          Text("View my projects only",
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          Switch(
                            value: myProjectsOnly,
                            onChanged: (value) {
                              setState(() {
                                myProjectsOnly = value;
                              });
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
              ],
                          ),
              ),
         ],
          ),
            ),
          
            SizedBox(height:10),
           Card(
                        child: ExpansionTile(
                          key: GlobalKey(),
                          title: Text("Step 3: Choose a Project", textAlign: TextAlign.start, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          //subtitle: Text(project),
                          children: <Widget>[
myProjectsOnly ? new StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection('Teachers').document(user.uid).collection('Created Projects').snapshots(),
                        builder: (context, snapshot) {
              if (!snapshot.hasData)
                        return Center(
                          child: Text('Loading . . .'),
                        );
              return new Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: new Row(
                          children: <Widget>[
                            //Text("Project to Assign", style: modalLabel),
                            new Expanded(
                              flex: 4,
                              child: new InputDecorator(
                                decoration: const InputDecoration(
                                  hintText: 'Choose a project',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                isEmpty: _project == null,
                                child: new DropdownButton(
                                  value: _project,
                                  isDense: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      
                                      _project = newValue;
                                     // project="Selected: "+ ;
                                      //print(_project);
                                    });
                                  },
                                  items: snapshot.data.documents
                                      .map((DocumentSnapshot document) {
                                       
                                    return new DropdownMenuItem<String>(
                                      
                                      value: document.data['docIDref'],
                                      child: Text(document.data['title'],style: TextStyle(color: Colors.black)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
              );
                        },
              ) 
              : Container(
                                      child: new StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('Projects').snapshots(),
              builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: Text('Loading . . .'),
                          );
                        return new Container(
                          padding: EdgeInsets.only(bottom: 10.0),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: new Row(
                            children: <Widget>[
                            
                              new Expanded(
                                flex: 4,
                                child: new InputDecorator(
                                  decoration: const InputDecoration(
                                    hintText: 'Choose a project',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  isEmpty: _project == null,
                                  child: new DropdownButton(
                                    value: _project,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _project = newValue;
                                        //print(_project);
                                      });
                                    },
                                    items: snapshot.data.documents
                                        .map((DocumentSnapshot document) {
                                      return new DropdownMenuItem<String>(
                                        value: document.documentID,
                                        child: Text(document.data['title'], style: TextStyle(color: Colors.black)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
              },
                        ),
              ),

                          ]
                          
                          ),
           ),
            
             SizedBox(height:10),
             Card(
                            child: ExpansionTile(
                              title: Text("Step 4: Choose a Due Date", textAlign: TextAlign.start, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              children: <Widget>[

Container(
                            //padding: EdgeInsets.all(20),
                            padding: EdgeInsets.only(bottom: 10.0),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: DateTimeField(
            format: DateFormat("yyyy-MM-dd"),
            decoration: const InputDecoration(
                            hintText: 'Select Project Due Date',
                            icon: Icon(Icons.calendar_today),
                            hintStyle: TextStyle(color: Colors.black),
            ),
            onChanged: (dt) => setState(() => _date = dt),
            onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
            },
                            ),
            ),

                              ],
                              ),
             ),
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
            onPressed: () async {
              if (_class != null && _project != null && _date != null ) {
                if(hasRoster){
                   await assignProject(user.uid, _class.trim(), _project, _date);
                }
                else{
                  //print("No Roster exists"); 
                  return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Error: Your Selected Class does not have a roster yet"),
                      content: Text(
                          "You must add a roster to a class first."),
                      actions: <Widget>[
                         RaisedButton(
                          child: Text("Click here to add a roster now"),
                          onPressed: () {
                             Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>AddRoster(name: _class),
                ));
                          },
                        ),
                        RaisedButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }

                
               
              } else {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Missing Data"),
                      content: Text(
                          "You must make a selection for class, project and due date."),
                      actions: <Widget>[
                        RaisedButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text("Success!"),
                        content: Text(
                            "A project has been added to the class. View the class details to see the assigned project."),
                        actions: <Widget>[
                          RaisedButton(
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ]);
                  });
              Navigator.pop(context);
              return;
            },
            child: Text('Add Project'),
              ),
            ),
          ],
        ),
      ),
            ),
        ),
    );
  }
}

class AddProjectToClassHelp extends StatefulWidget {
  @override
  _AddProjectToClassHelpState createState() => _AddProjectToClassHelpState();
}

class _AddProjectToClassHelpState extends State<AddProjectToClassHelp> {
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      theme: modalHelpTheme,
      home: SingleChildScrollView(
              child: Container(
          color: modalHelpTheme.backgroundColor,
          padding: EdgeInsets.fromLTRB(30, 0, 10, 30),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  "Create a Project",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                  textAlign: TextAlign.center,
                ),
                trailing: Icon(
                  Icons.help,
                  semanticLabel: 'Close'
                  ,
                ),
                onTap: () => {Navigator.of(context).pop()},
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "This pages allows you to add projects to a class. ",
                      style: modalInfo,
                    ),
                  ),
                  Text(
                    "Step 1: Select a Class",
                    style: modalLabel,
                  ),
                  Text(
                    '-Select a class from the dropdown menu',
                    style: modalInfo,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Step 2: Select a Project",
                    style: modalLabel,
                  ),
                  Text(
                    "-Toggle between projects in your list or public projects then select the project for the class",
                    style: modalInfo,
                  ),
                  
                  SizedBox(height: 20),
                   Text(
                    "Step 3: Pick a Due Date",
                    style: modalLabel,
                  ),
                  Text(
                    "-Chose a due data for the project\n-Note that the due date can be changes by going to the class data page. ",
                    style: modalInfo,
                  ),
                  
              
                  SizedBox(height: 20),
                   Text(
                    "Submit",
                    style: modalLabel,
                  ),
                  Text(
                    "-You will now be able to view the class project.\n -Each student will have their own personal code to use to access the project\n-You can view the codes under the class information section",
                    style: modalInfo,
                  ),
                  
                 
                        
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}