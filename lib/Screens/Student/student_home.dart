import 'package:flutter/material.dart';

class StudentHome extends StatefulWidget{
  final String teacher;
  final String project;
  final String className;

  StudentHome({
    Key key,
    @required this.teacher,
    @required this.project,
    @required this.className,
    }) :  assert(teacher != null),
          assert(project != null),
          assert(className != null),
          super(key: key);

  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Home Page'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Collect Data For Project'),
              onPressed: () => print('variables in StudentHome widget; teacher: ' + widget.teacher +' project: ' + widget.project + ' className: ' + widget.className),
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
    );
  }
}

