import 'package:flutter/material.dart';
import 'package:sensational_science/models/student.dart';
import 'package:sensational_science/Services/getproject.dart';
import 'package:provider/provider.dart';
import 'collectDataStaging.dart';
import 'student_view_class_data.dart';
import 'package:sensational_science/Screens/Login/authenticate.dart';

class StudentHome extends StatelessWidget{
  final String classData;

  StudentHome({
    Key key,
    @required this.classData,
  }) :  assert(classData != null),
          super(key: key);

  @override

  Widget build(BuildContext context) {
    final student = Student(code: classData);
    return Provider<Student>(
      create: (_) => new Student(code: classData), 
      child:  
          Scaffold(
          appBar: AppBar(
            title: Text('Project Home Page'),
            backgroundColor: Colors.deepPurple,
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('Log out'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => Authenticate()),             
                    );
                },
              ),
            ]
                
          ),
          body: SingleChildScrollView(
            child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Collect Data For Project'),
                      onPressed: () {
                        if (DateTime.now().isBefore(student.dueDate)) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>CollectDataStaging(student.projectTitle, student.projectID, classData),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Due Date Has Passed"),
                                content: Text("The due date for this project is " + student.dueDate.toString() +". It is now past the due date so new data cannot be submitted."),
                                actions: [
                                  FlatButton(
                                    child: Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                    RaisedButton(
                      child: Text('View All Class Data'),
                      onPressed: () {
                        if (DateTime.now().isAfter(student.dueDate)) {
                          var proj = new GetProject( student.projectTitle, student.projectID);
                          proj.questionData().whenComplete(() => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewClassData(
                                    user: student.teacherID,
                                    className: student.className,
                                    classProjDocID: student.projectCode,
                                    proj: proj),
                              ),
                            ),
                          }
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Class Data Is Not Available Yet"),
                                content: Text("The due date for this project is " + student.dueDate.toString() +". The class data will not be available to until after the due date has passed."),
                                actions: [
                                  FlatButton(
                                    child: Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                    Container(height: 120.0,
      width: 120.0, child: Image.asset('assets/images/logo.jpg'),), 
                  ],
                )
              ),
          ),
          // floatingActionButton: RaisedButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   child: Text('Go back'),
          ),
      );
  }
}
