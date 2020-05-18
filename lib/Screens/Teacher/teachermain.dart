import 'package:flutter/material.dart';
import 'package:sensational_science/Screens/Student/locationtest.dart';
import 'package:sensational_science/Screens/Teacher/addProjectToClass.dart';
import 'package:sensational_science/Screens/Teacher/setupclasswithprojects.dart';
import 'package:sensational_science/Screens/Teacher/teacherclasslist.dart';
import 'package:sensational_science/Screens/Teacher/teacher_add_class.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/image_capture.dart';
import 'package:sensational_science/Screens/Teacher/testingNEWcreateproj.dart';
import 'package:sensational_science/Services/auth.dart';
import '../../Services/database.dart';
import 'package:provider/provider.dart';
import '../home/user_list.dart';
import '../../models/teacher.dart';

import 'staging.dart';
import 'listprojects.dart';
import 'viewallprojects.dart';
class TeacherHome extends StatefulWidget {
  TeacherHome({Key key}) : super(key: key);

  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
bool selected= false;  
final AuthService _auth = AuthService();

  @override

  Widget build(BuildContext context){
    
    
    return StreamProvider<List<Teacher>>.value(
        value: DatabaseService().user,
          child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: <Widget>[
            new FlatButton.icon(
            
              icon: Icon(Icons.person, color: Colors.black),
              
              label: Text('Log out', style: TextStyle(color: Colors.black)),
              onPressed: () async{
                await _auth.signOut();
              },
            ),
          ]
              
        ),
        
        backgroundColor: Colors.blueGrey[50],
        body: ListView(
            children:  <Widget>[
              
              Card(
                              child: Ink(
                  color: Colors.white,
                                child: ListTile(
                    
                     title: Text('Classes', style: TextStyle(fontSize: 20)),
                     subtitle: Text('View All Classes, view class info, add roster, and view compiled data', style: TextStyle(fontSize: 17)),
                     trailing: Icon(Icons.arrow_forward_ios), 
                     
                     onTap: ()=>{
                       setState((){
                         
                       }),
                       
                     
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (context) =>ClassListPage(),
                         ),
                       ),
                     },
                     ),
                ),
              ),
              Card(
                              child: Ink(
                 color: Colors.white,
                  child: ListTile(
                    title: Text('Add Class', style: TextStyle(fontSize: 20)),
                    subtitle: Text('Add A New Class', style: TextStyle(fontSize: 17)),
                    trailing: Icon(Icons.arrow_forward_ios), 
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>AddClassPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
               
               Card(
                child: ListTile(
                  title: Text('View All projects', style: TextStyle(fontSize: 20)),
                  subtitle: Text('Public Projects', style: TextStyle(fontSize: 17)),
                  trailing: Icon(Icons.arrow_forward_ios), 
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>PublicProjectsList(),
                      ),
                    );
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Assign Project to Class', style: TextStyle(fontSize: 20)),
                  subtitle: Text('Assign an Existing Project to an Existing Class', style: TextStyle(fontSize: 17)),
                  trailing: Icon(Icons.arrow_forward_ios), 
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>AddProjectToClass(),
                      ),
                    );
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Create Project', style: TextStyle(fontSize: 20)),
                  subtitle: Text('Create A New Project From Scratch', style: TextStyle(fontSize: 17)),
                  trailing: Icon(Icons.arrow_forward_ios), 
                  onTap: (){
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
                  subtitle: Text('Create and setup a class', style: TextStyle(fontSize: 17)),
                  trailing: Icon(Icons.arrow_forward_ios), 
                  onTap: (){
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
                  title: Text('View Your Projects', style: TextStyle(fontSize: 20)),
                  subtitle: Text('', style: TextStyle(fontSize: 17)),
                  trailing: Icon(Icons.arrow_forward_ios), 
                  onTap: (){
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
          floatingActionButton: RaisedButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text("Go Back"),
            
          ),
        
          ),
    );
  }
}