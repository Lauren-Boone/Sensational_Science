import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sensational_science/Shared/styles.dart';
import 'package:sensational_science/models/student.dart';
import 'package:sensational_science/Services/getproject.dart';
import 'package:provider/provider.dart';
import 'collectDataStaging.dart';
import 'student_view_class_data.dart';
import 'package:sensational_science/Screens/Login/authenticate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentHome extends StatelessWidget {
  final String classData;

 
  StudentHome({
    
    Key key,
    @required this.classData,
  })  : assert(classData != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    
    // final student = Student.getForCode(classData);
    // String subject = student.classSubject;
    // Icon icon = chooseIcon(subject);
    // print("Class Subject: " + student.classSubject);
    return FutureProvider<Student>(
      create: (_) => Student.getForCode(classData),
      child: Consumer<Student>(builder: (context, student, child) {
        if (student == null) {
          return new Scaffold(
              appBar: AppBar(
                  title: Text('Loading'),
                  backgroundColor: Colors.deepPurple,
                  actions: <Widget>[
                    FlatButton.icon(
                        icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    )),
                  ]),
              body: Container(
                  width: 250, height: 250, child: CircularProgressIndicator()));
        }
        GetProject project = new GetProject(student.projectTitle, student.projectID,);
        project.questionData();
        return MaterialApp(
          theme: appTheme,
          home: Scaffold(
            appBar: AppBar(
                title: Text('Project Home Page'),
                backgroundColor: Colors.deepPurple,
                actions: <Widget>[
                  FlatButton.icon(
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    label:
                        Text('Log out', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Authenticate()),
                        (Route<dynamic> route) => false
                      );
                        // Navigator.of(context).pushReplacement(
                        // MaterialPageRoute(builder: (context) => Authenticate()),
                      // );
                    },
                  ),
                ]),
            body: SingleChildScrollView(
              child: Center(
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('codes')
                        .document(classData)
                        .snapshots(),
                    builder: (context, stream) {
                      if (!stream.hasData) {
                        return CupertinoActivityIndicator();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            child: Text('Collect Data For Project'),
                            onPressed: () {
                              if (DateTime.now()
                                  .isBefore(stream.data['dueDate'].toDate())) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CollectDataStaging(
                                        student.projectTitle,
                                        student.projectID,
                                        classData,
                                        project),
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Due Date Has Passed"),
                                      content: Text(
                                          "The due date for this project is " +
                                              student.dueDate.toString() +
                                              ". It is now past the due date so new data cannot be submitted."),
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
                              if (DateTime.now()
                                  .isAfter(stream.data['dueDate'].toDate())) {
                                var proj = new GetProject(
                                    student.projectTitle, student.projectID);
                                proj.questionData().whenComplete(() => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewClassData(
                                              user: student.teacherID,
                                              className: student.className,
                                              classProjDocID:
                                                  student.projectCode,
                                              proj: proj),
                                        ),
                                      ),
                                    });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          "Class Data Is Not Available Yet"),
                                      content: Text(
                                          "The due date for this project is " +
                                              student.dueDate.toString() +
                                              ". The class data will not be available to until after the due date has passed."),
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
                          Container(
                            height: 300.0,
                            width: 300.0,
                            child: chooseIcon(student.classSubject.toString()),
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ),
        );
      }),
    );
  }
}

Icon chooseIcon(String subject) {
  //print("Choose Icon: " + subject.toString());
  switch (subject) {
    case 'Physics':
      {
        return Icon(Foundation.lightbulb, size: 150.0, color: Colors.orange);
      }
      break;
    case 'Biology':
      {
        return Icon(FontAwesome5Brands.canadian_maple_leaf,
            size: 150.0, color: Colors.orange);
      }
      break;
    case 'Chemistry':
      {
        return Icon(Octicons.beaker, size: 150.0);
      }
      break;
    case 'Astronomy':
      {
        return Icon(Ionicons.ios_planet, size: 150.0, color: Colors.orange);
      }
      break;
    case 'Geography':
      {
        return Icon(Foundation.map, size: 150.0);
      }
      break;
    case 'Geology':
      {
        return Icon(Foundation.mountains, size: 150.0);
      }
    default:
      {
        return Icon(Ionicons.ios_school, size: 150.0);
      }
      break;
  }
}
