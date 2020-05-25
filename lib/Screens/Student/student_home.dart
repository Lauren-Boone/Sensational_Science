import 'package:flutter/material.dart';
import 'package:sensational_science/models/student.dart';
import 'package:sensational_science/Services/getproject.dart';
import 'package:provider/provider.dart';
import 'collectDataStaging.dart';
import 'student_view_class_data.dart';
import 'package:sensational_science/Screens/Login/authenticate.dart';

class StudentHome extends StatelessWidget {
  final String classData;

  StudentHome({
    Key key,
    @required this.classData,
  })  : assert(classData != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final student = Student(code: classData);
    return Provider<Student>(
      create: (_) => new Student(code: classData),
      child: MaterialApp(
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.

          brightness: Brightness.light,
          //  accentColor: Colors.lightBlueAccent,
          accentColor: Colors.deepPurpleAccent,
          primarySwatch: Colors.deepPurple,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.indigo[600],
            shape: RoundedRectangleBorder(),
            textTheme: ButtonTextTheme.primary,
            hoverColor: Colors.white,
            highlightColor: Colors.blueGrey,
            splashColor: Colors.purpleAccent,
          ),
          cardTheme: CardTheme(
            color: Colors.green[100],
          ),
          iconTheme: IconThemeData(
            color: Colors.grey,
          ),

          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
          highlightColor: Colors.deepPurpleAccent,
          // highlightColor: Colors.blueAccent,
        ),
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
                  label: Text('Log out', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Authenticate()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ]),
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
                          builder: (context) => CollectDataStaging(
                              student.projectTitle,
                              student.projectID,
                              classData),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Due Date Has Passed"),
                            content: Text("The due date for this project is " +
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
                    if (DateTime.now().isAfter(student.dueDate)) {
                      var proj = new GetProject(
                          student.projectTitle, student.projectID);
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
                          });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Class Data Is Not Available Yet"),
                            content: Text("The due date for this project is " +
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
                  height: 120.0,
                  width: 120.0,
                  child: Image.asset('assets/images/logo.jpg'),
                ),
              ],
            )),
          ),
          // floatingActionButton: RaisedButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   child: Text('Go back'),
        ),
      ),
    );
  }
}
