import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sensational_science/Screens/Student/collectData.dart';
import 'package:sensational_science/models/student.dart';
import 'package:provider/provider.dart';

class StudentHome extends StatelessWidget{
  final String classData;

  StudentHome({
    Key key,
    @required this.classData,
  }) :  assert(classData != null),
          super(key: key);

//  getStudentData() {
//    return Firestore.instance.collection('codes').document(classData).snapshots();
//  }
  
//  DocumentReference _getDocument(){
//    return Firestore.instance.collection('Projects').document(this.classData);
//  }

  @override

  Widget build(BuildContext context) {
    final student = Student(code: classData);
    return Provider<Student>(
    create: (_) => new Student(code: classData), 
    child:  
        Scaffold(
        appBar: AppBar(
          title: Text('Project Home Page'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Collect Data For Project'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>CollectDataPage(student.projectTitle, student.projectID, classData),
                    ),
                  );
                },
              ),
              RaisedButton(
                child: Text('View All Class Data'),
                onPressed: () => print('going to all class data'),
              )
            ],
          )
        ),
        floatingActionButton: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back'),
        ),
      ),
    );
  }
}


/*


class StudentHome extends StatefulWidget{
  final String classData;

  StudentHome({
    Key key,
    @required this.classData,
    }) :  assert(classData != null),
          super(key: key);

  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  CollectionReference = Firestore.instance.collection('codes').document(widget.classData);

  @override
  Widget build(BuildContext context) {
    return Provider(
    create: (context) => new Student(code: widget.classData), 
    child:  Scaffold(
        appBar: AppBar(
          title: Text('Project Home Page'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text()
              )
              RaisedButton(
                child: Text('Collect Data For Project'),
                onPressed: () => print('going to collect data'),
              ),
              RaisedButton(
                child: Text('View All Class Data'),
                onPressed: () => print('going to all class data'),
              )
            ],
          )
        ),
        floatingActionButton: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back'),
        ),
      ),
    );
  }
}

*/