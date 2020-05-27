import 'package:flutter/material.dart';
import 'package:sensational_science/Screens/Student/locationmap.dart';
import 'package:sensational_science/Screens/Teacher/addProjectToClass.dart';
import 'package:sensational_science/Screens/Teacher/setupclasswithprojects.dart';
import 'package:sensational_science/Screens/Teacher/teacherclasslist.dart';
import 'package:sensational_science/Screens/Teacher/teacher_add_class.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/image_capture.dart';
import 'package:sensational_science/Screens/Teacher/testingNEWcreateproj.dart';
import 'package:sensational_science/Services/auth.dart';
import 'package:sensational_science/Shared/styles.dart';
//import 'package:universal_html/html.dart';
import '../../Services/database.dart';
import 'package:provider/provider.dart';
import '../../models/teacher.dart';
import 'package:sensational_science/Screens/Login/authenticate.dart';
import 'staging.dart';
import 'listprojects.dart';
import 'viewallprojects.dart';

class TeacherHome extends StatefulWidget {
  TeacherHome({Key key}) : super(key: key);

  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  bool selected = false;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Teacher>>.value(
      value: DatabaseService().user,
      child: MaterialApp(
        theme: appTheme,
        home: Scaffold(
          appBar: AppBar(title: Text("Home"), actions: <Widget>[
            new FlatButton.icon(
              icon: Icon(Icons.person, color: Colors.black),
              label: Text('Log out', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Authenticate()),
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
                        child: MainHelp(),
                      );
                    }),

              },
              icon: Icon(Icons.help, color: Colors.black),
              label: Text("Help", style: TextStyle(color: Colors.black)),
            ),
          ]),

          body: ListView(
            children: <Widget>[
              Card(
                child: ListTile(
                  title: Text('Classes',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  subtitle: Text(
                      'View All Classes, view class info, add roster, and view compiled data',
                      style: TextStyle(fontSize: 17)),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => {
                    setState(() {}),
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassListPage(),
                      ),
                    ),
                  },
                ),
              ),
              // Card(
              //                 child: Ink(
              //    color: Colors.white,
              //     child: ListTile(
              //       title: Text('Add Class', style: TextStyle(fontSize: 20)),
              //       subtitle: Text('Add A New Class', style: TextStyle(fontSize: 17)),
              //       trailing: Icon(Icons.arrow_forward_ios),
              //       onTap: (){
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) =>AddClassPage(),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),

              Card(
                child: ListTile(
                  title:
                      Text('View All projects', style: TextStyle(fontSize: 20)),
                  subtitle:
                      Text('Public Projects', style: TextStyle(fontSize: 17)),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PublicProjectsList(),
                      ),
                    );
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Assign Project to Class',
                      style: TextStyle(fontSize: 20)),
                  subtitle: Text(
                      'Assign an Existing Project to an Existing Class',
                      style: TextStyle(fontSize: 17)),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddProjectToClass(),
                      ),
                    );
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Create Project', style: TextStyle(fontSize: 20)),
                  subtitle: Text('Create A New Project From Scratch',
                      style: TextStyle(fontSize: 17)),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StagingPage(),
                      ),
                    );
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Class Setup', style: TextStyle(fontSize: 20)),
                  subtitle: Text('Create and setup a class',
                      style: TextStyle(fontSize: 17)),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetUpClassSteps(),
                      ),
                    );
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('View Your Projects',
                      style: TextStyle(fontSize: 20)),
                  subtitle: Text('', style: TextStyle(fontSize: 17)),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListProjects(),
                      ),
                    );
                  },
                ),
              ),

              // Card(
              //   child: ListTile(
              //     title: Text('Test Camera'),
              //     subtitle: Text('Test opening camera & picture from file'),
              //     trailing: Icon(Icons.arrow_forward_ios),
              //     onTap: (){
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => ImageCapture(),
              //         ),
              //       );
              //     },
              //   ),
              // ),
              //                Card(
              //   child: ListTile(
              //     title: Text('Location'),
              //     subtitle: Text('Location Test'),
              //     trailing: Icon(Icons.arrow_forward_ios),
              //     onTap: (){
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => LocationMap(),
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
          // floatingActionButton: RaisedButton(
          //   onPressed: (){
          //     Navigator.pop(context);
          //   },
          //   child: Text("Go Back"),

          // ),
        ),
      ),
    );
  }
}

class MainHelp extends StatefulWidget {
  @override
  _MainHelpState createState() => _MainHelpState();
}

class _MainHelpState extends State<MainHelp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: modalHelpTheme,
      home: SingleChildScrollView(
              child: Container(
          color: modalHelpTheme.backgroundColor,
          padding: EdgeInsets.fromLTRB(30, 10, 10, 30),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  "This is your home page",
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
              SingleChildScrollView(
                            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text("From this page you can navigate to:",
                          style: modalLabel),
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Classes: ",
                          style: modalLabel,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'Here you will find your current classes with their projects, rosters, and class info',
                              style: modalInfo,
                            ),
                          ]),
                    ),
                    SizedBox(height: 20),
                    RichText(
                        text: TextSpan(
                            text: "Set Up a Class: ",
                            style: modalLabel,
                            children: <TextSpan>[
                          TextSpan(
                            text:
                                "Here you can create up a new class, add a roster to the class and add projects to the class ",
                            style: modalInfo,
                          ),
                        ])),
                         SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                          text: "View All Projects: ",
                          style: modalLabel,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  "This is a listing of all public projects in the database",
                              style: modalInfo,
                            ),
                          ]),
                    ),
                     SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                          text: "View Your Projects: ",
                          style: modalLabel,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  "This is a listing of all the project you have created or added from the public projects",
                              style: modalInfo,
                            ),
                          ]),
                    ),
                     SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                          text: "Create A Project: ",
                          style: modalLabel,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  "This is a custom form builder that allows you to create a custom project for you class",
                              style: modalInfo,
                            ),
                          ]),
                    ),
                     SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                          text: "Assign a Project to a Class: ",
                          style: modalLabel,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  "You can add a project to any class that has a roster",
                              style: modalInfo,
                            ),
                          ]),
                    ),
                     
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
