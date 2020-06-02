import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/Screens/Teacher/addProjectToClass.dart';
import 'package:sensational_science/Screens/Teacher/addRoster.dart';
import 'package:sensational_science/Screens/Teacher/teacher_add_class.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';
import 'package:sensational_science/Shared/styles.dart';
import 'package:sensational_science/models/classInfo.dart';
import 'package:sensational_science/models/user.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:fa_stepper/fa_stepper.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class SetUpClassSteps extends StatefulWidget {
  SetUpClassSteps({Key key}) : super(key: key);
  // SetUpClassSteps({this.createdClass, this.createdRoster, this.addedProject});
  @override
  _SetUpClassStepsState createState() => _SetUpClassStepsState();
}

class _SetUpClassStepsState extends State<SetUpClassSteps> {
  bool hasClass = false;
  bool hasProject = false;
  String _class;
  String _project;
  DateTime _date;
  bool hasRoster = false;
  bool myProjectsOnly = true;
  final _formKey = GlobalKey<FormState>();
  final classNameController = TextEditingController();
  final subjectController = TextEditingController();
  final levelController = TextEditingController();
  final schoolController = TextEditingController();
  int _currentStep = 0;
  String name;
  List<DynamicWidget> roster = [];
  List<String> addedStudents = [];
  @override
  Widget build(BuildContext context) {
    List<FAStep> steps = [
      FAStep(
        title: Text("Step 1"),
        subtitle: Text("Create a Class"),
        //content: Text("here"),
        content: createClass(),
      ),
      FAStep(
        title: Text("Step 2"),
        subtitle: Text("Add Roster to Class"),
        //content: Text("here"),
        content: addRoster(),
      ),
      FAStep(
        title: Text("Step 3"),
        subtitle: Text("Add Project to Class"),
        //content: Text("here"),
        content: addProject(),
      ),
    ];
    return Material(
          child: Scaffold(
          appBar: AppBar(
            title: Text("Set up a Class"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
            actions: <Widget>[
              new FlatButton.icon(
                onPressed: () => {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Material(
                          //padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                          child: SetUpClassHelp(),
                        );
                      }),
                },
                icon: Icon(Icons.help, color: Colors.black),
                label: Text("Help", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          body: FAStepper(
            type: FAStepperType.horizontal,
            titleIconArrange: FAStepperTitleIconArrange.column,
            stepNumberColor: Colors.pink,
            currentStep: _currentStep,
            titleHeight: 90,
            steps: steps,
            onStepCancel: () => {
              Navigator.of(context).pop(),
            },
            onStepContinue: () {
              if (_currentStep == 0 && hasClass == false) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text("You must create and submit a class first!"),
                        content: Text("Please be sure to submit your data."),
                        actions: <Widget>[
                          RaisedButton(
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ]);
                  },
                );
              }
              if (_currentStep == 1 && hasRoster == false) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text(
                            "You must create and submit a class Roster first!"),
                        content:
                            Text("Please be sure to submit your roster data."),
                        actions: <Widget>[
                          RaisedButton(
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ]);
                  },
                );
              }
              else if (_currentStep != 2 && hasClass==true) {
                setState(() {
                  _currentStep++;
                });
              } else if(hasClass==true) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TeacherHome()));
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text("Success! You have set up a class"),
                        content: Text(
                            "You can add more projects to this class in the add project to class section and add more student to the roster under the class info"),
                        actions: <Widget>[
                          RaisedButton(
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ]);
                  },
                );
              }
            },
          )),
    );
  }

  Widget createClass() {
    final user = Provider.of<User>(context);
    final CollectionReference classCollection = Firestore.instance
        .collection('Teachers')
        .document(user.uid)
        .collection('Classes');
    return Material(
      child: SingleChildScrollView(
      child: Container(
        color: appTheme.scaffoldBackgroundColor,
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: classNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter class name (must be unique)',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please a unique class name';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        hintText: 'Class Subject',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a subject';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: levelController,
                      decoration: const InputDecoration(
                        hintText: 'class level',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a class level';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: schoolController,
                      decoration: const InputDecoration(
                        hintText: 'school',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the school';
                        }

                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            bool docExists = false;
                            final existingClasses =
                                await classCollection.getDocuments();
                            for (var doc in existingClasses.documents) {
                              //print(doc.documentID);
                              if (doc.documentID ==
                                  classNameController.text.trim()) {
                                docExists = true;
                              }
                            }
                            if (docExists) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Text("Class Exists"),
                                        content: Text(
                                            "A class with the name you entered already exists, please enter a unique class name."),
                                        actions: <Widget>[
                                          RaisedButton(
                                            child: Text("Close"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ]);
                                  });
                            } else {
                              await classCollection
                                  .document(classNameController.text.trim())
                                  .setData({
                                'name': classNameController.text,
                                'subject': subjectController.text,
                                'level': levelController.text,
                                'school': schoolController.text,
                                'students': 0,
                                'projects': 0,
                              });
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Text("Success!"),
                                        content: Text(
                                            "A new class has been created! Go to View All Classes to see your new class."),
                                        actions: <Widget>[
                                          RaisedButton(
                                            child: Text("Close"),
                                            onPressed: () {
                                              setState(() {
                                                hasClass = true;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ]);
                                  });
                              //Navigator.pop(context);
                            }
                          } else {
                            return;
                          }
                        },
                        child: Text('Register Class'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget addRoster() {

    addStudent() {
      roster.add(new DynamicWidget());
      setState(() {});
    }

    submitData(teachID) async {
      final int count = roster.length;
      //String val='Success!';
      //int rosterCount = 0;
      CollectionReference classRoster = Firestore.instance
          .collection('Teachers')
          .document(teachID)
          .collection('Classes')
          .document(classNameController.text.trim())
          .collection('Roster');
      CollectionReference classProjects = Firestore.instance
          .collection('Teachers')
          .document(teachID)
          .collection('Classes')
          .document(classNameController.text.trim())
          .collection('Projects');
      DocumentReference classInfo = Firestore.instance
          .collection('Teachers')
          .document(teachID)
          .collection('Classes')
          .document(classNameController.text.trim());
      //add students and project codes for existing projects
       classInfo.get().then((doc) async{
          //print(doc.data['students']);
          classInfo.updateData({'students':  doc.data['students']+count});
          //print(doc.data['students']);
        });
        
      roster.forEach((e) async {
        DocumentReference newStudent =
            await classRoster.add({'name': e.controller.text});
        QuerySnapshot eachProject = await classProjects.getDocuments();
        eachProject.documents.forEach((project) async {
          bool exists = false;
          int newCode;
          do {
            newCode = Random().nextInt(10000000);
            newCode = newCode < 1000000 ? newCode + 999999 : newCode;
            await Firestore.instance
                .collection('codes')
                .document(newCode.toString())
                .get()
                .then((doc) {
              exists = doc.exists ? true : false;
            });
            //print('code: ' + newCode.toString() + ' exists: ' + exists.toString());
          } while (exists);
          await classProjects
              .document(project.documentID)
              .collection('Students')
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
            'Class': classNameController.text.trim(), //class doc id
            'Student': newStudent.documentID, //student doc id in roster
            'Name': e.controller.text, //student name in roster
            'Project': project.documentID, //project doc id in class
            'ProjectID': project.data[
                'projectID'], //project doc id in top level project collection
            'ProjectTitle': project.data['projectTitle'], //project title
            'dueDate': project.data['dueDate'], //project due date
            'Subject': project.data['projectSubject'], //project subject
          });
        });
        addedStudents.add(e.controller.text);
      });

      // //increment the count of students in the class
      //   await classInfo.get().then((doc) {
      //     print((doc.data['students'] + rosterCount).toString());
      //     classInfo.updateData({'students': doc.data['students'] + rosterCount});
      //   });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Students added!'),
              content: Text('Students have been added to the class'),
              actions: <Widget>[
                RaisedButton(
                  child: Text("Close"),
                  onPressed: () {
                    setState(() {
                      hasRoster = true;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        },
      );
      roster = [];
      //print(addedStudents.toString());
      setState(() {});
    }

    String success = '';

    final user = Provider.of<User>(context);
    return Material(
      child: Container(
        color: appTheme.scaffoldBackgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .6,
        child: Column(
          children: <Widget>[
            new Text('Current Roster'),
            new Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: new ListView.builder(
                  itemCount: addedStudents.length,
                  itemBuilder: (context, index) {
                    return new ListTile(
                      title: Text(addedStudents[index]),
                    );
                  }
                ),
              ),
            ),
//            new StreamBuilder(
            //   stream: Firestore.instance
            //       .collection('Teachers')
            //       .document(user.uid)
            //       .collection('Classes')
            //       .document(classNameController.text)
            //       .collection('Roster')
            //       .snapshots(),
            //   builder: (BuildContext context, snapshot) {
            //     if (!snapshot.hasData) return new Text('...Loading');
            //     return new Expanded(
            //       child: SizedBox(
            //         height: MediaQuery.of(context).size.height * 0.8,
            //         child: new ListView(
            //           children: snapshot.data.documents.map<Widget>((doc) {
            //             return new ListTile(
            //               title: new Text(doc['name']),
            //             );
            //           }).toList(),
            //         ),
            //       ),
            //     );
            //   },
            // ),
            new Divider(
              color: Colors.deepPurple,
              height: 10.0,
            ),
            new Text('Students to add:'),
            new Expanded(
              child: new SizedBox(
                //height: MediaQuery.of(context).size.height * 0.2,
                child: new ListView.builder(
                    itemCount: roster.length,
                    itemBuilder: (_, index) => roster[index]),
              ),
            ),
            new Container(
              child: Text(success),
            ),
            new RaisedButton(
              child: new Text('Submit Students'),
              onPressed: () => submitData(user.uid),
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

  Widget addProject() {
    Future<void> assignProject(String uid, String className, String projectID,
        DateTime dueDate) async {
      //print(dueDate);
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
        'dueDate': dueDate, //due date
      });

      //increment project count for class
      classDoc.get().then((doc) {
        int projCount = doc['projects'];
        projCount++;
        classDoc.updateData({'projects': projCount});
      });

      //create a code for each student in the class, create code under the project, store under the student, store all codes
      //under top level codes collection
      final students = await classDoc.collection('Roster').getDocuments();
      for (var student in students.documents) {
        bool exists = false;
        int newCode;
        do {
          newCode = Random().nextInt(10000000);
          newCode = newCode < 1000000 ? newCode + 999999 : newCode;
          await Firestore.instance
              .collection('codes')
              .document(newCode.toString())
              .get()
              .then((doc) {
            exists = doc.exists ? true : false;
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
          'name': student.data['name'], //add student name for reference
        });
        await classDoc
            .collection('Roster')
            .document(student.documentID)
            .setData({
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
          'ProjectID':
              projectID, //project doc id in top level project collection
          'ProjectTitle': projectDoc.data['title'], //project title
          'dueDate': dueDate,
          'Subject': projectDoc.data['subject'], //project subject
        });
      }
    }

    _checkForRoster(String uid) {
      Future<QuerySnapshot> snap = Firestore.instance
          .collection('Teachers')
          .document(uid)
          .collection('Classes')
          .document(_class)
          .collection('Roster')
          .getDocuments();
      snap.then((value) => {
            if (value.documents.length == 0)
              {
                this.hasRoster = false,
              }
          });
      setState(() {});
    }

    final user = Provider.of<User>(context);
    return new Material(
       color: appTheme.scaffoldBackgroundColor,
      child: Container(
         color: appTheme.scaffoldBackgroundColor,
        child: new Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1, bottom: 10.0),
              child: Row(
                children: [
                  Text(
                    "View my projects only",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
            myProjectsOnly
                ? new StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('Teachers')
                        .document(user.uid)
                        .collection('Created Projects')
                        .snapshots(),
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
                                    fontSize: 15.0,
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
                                      value: document.data['docIDref'],
                                      child: Text(document.data['title']),
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
                : new StreamBuilder<QuerySnapshot>(
                    stream:
                        Firestore.instance.collection('Projects').snapshots(),
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
                            //Text("Project to Assign"),
                            new Expanded(
                              flex: 4,
                              child: new InputDecorator(
                                decoration: const InputDecoration(
                                  hintText: 'Choose a project',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
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
                                      child: Text(document.data['title']),
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
            Container(
             
              child: Center(
                child: DateTimeField(
                  format: DateFormat("yyyy-MM-dd"),
                  decoration: const InputDecoration(
                   
                    hintText: 'Select Project Due Date',
                    hintStyle: TextStyle(color: Colors.black,),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () async {
                  if (_project != null && _date != null) {
                    await assignProject(user.uid,
                        classNameController.text.trim(), _project, _date);
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
                  //Navigator.pop(context);
                  return;
                },
                child: Text('Add Project'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DynamicWidget extends StatelessWidget {
  final controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
       color: appTheme.scaffoldBackgroundColor,
      child: Container(
         color: appTheme.scaffoldBackgroundColor,
        margin: new EdgeInsets.all(8.0),
        child: new TextField(
          controller: controller,
          decoration: new InputDecoration(hintText: 'Enter Student Name'),
        ),
      ),
    );
  }
}

class SetUpClassHelp extends StatefulWidget {
  @override
  _SetUpClassHelp createState() => _SetUpClassHelp();
}

class _SetUpClassHelp extends State<SetUpClassHelp> {
  @override
  Widget build(BuildContext context) {
    return Material(
      //theme: modalHelpTheme,
      child: Container(
        color: modalHelpTheme.backgroundColor,
        padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                "Set up a Class",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
                textAlign: TextAlign.center,
              ),
              trailing: Icon(
                Icons.help,
                semanticLabel: 'Close',
              ),
              onTap: () => {Navigator.of(context).pop()},
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Text(
                    "This pages guides you through setting up a class, adding a roster, and adding projects to a class",
                    style: modalInfo,
                  ),
                ),
                Text(
                  "Step 1: Set up a Class ",
                  style: modalLabel,
                ),
                Text(
                  '-Enter your class details here and click register to add the class.',
                  style: modalInfo,
                ),
                SizedBox(height: 20),
                Text(
                  "Step 2: Create a Roster ",
                  style: modalLabel,
                ),
                Text(
                  "-Add as many students as you like with the 'Add Another Student' button. Click submit to add the students",
                  style: modalInfo,
                ),
                
                SizedBox(height: 20),
                 Text(
                  "Step 3: Add Projects to the Class",
                  style: modalLabel,
                ),
                Text(
                  "-Chose from projects you have created or public projects to add to the class. This step is not required.",
                  style: modalInfo,
                ),
                
            
                SizedBox(height: 20),
               
                      
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}
