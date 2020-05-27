import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:random_color/random_color.dart';
import 'package:sensational_science/Screens/Teacher/deleteProjectFromClass.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';
import 'package:sensational_science/Screens/Teacher/viewCompiledData.dart';
import 'package:sensational_science/Shared/styles.dart';
import 'dart:async';
import '../Student/student_view_class_data.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/models/user.dart';
import '../../Services/getproject.dart';
import 'package:sensational_science/Screens/Teacher/viewAllStudentCodes.dart';
import 'package:sensational_science/Screens/Teacher/changeProjectDueDate.dart';

class ViewClassProjects extends StatefulWidget {
  final String name;
  ViewClassProjects({this.name});
  @override
  _ViewClassProjectsState createState() => _ViewClassProjectsState();
}

class _ViewClassProjectsState extends State<ViewClassProjects> {
  GetProject proj;
  int current = 0;
  final GlobalKey expansionTileKey = GlobalKey();
  double previousOffset = 0;
  final ScrollController _scrollController = ScrollController();
  void _scrollToSelectedContent(
      bool isExpanded, double previousOffset, int index, GlobalKey myKey) {
    final keyContext = myKey.currentContext;

    if (keyContext != null) {
      // make sure that your widget is visible
      final box = keyContext.findRenderObject() as RenderBox;
      _scrollController.animateTo(
          isExpanded ? (box.size.height) : previousOffset,
          duration: Duration(milliseconds: 500),
          curve: Curves.linear);
    }
  }
  Color getColor(){
    RandomColor _randomColor = RandomColor();

Color _color = _randomColor.randomColor(
  colorSaturation: ColorSaturation.lowSaturation,
 colorHue: ColorHue.multiple(colorHues: [ColorHue.green, ColorHue.blue]),
  colorBrightness: ColorBrightness.primary,
);
return _color;
}
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("View " + widget.name + " Projects"),
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
          children: <Widget>[
            StreamBuilder(
              stream: Firestore.instance
                  .collection('Teachers')
                  .document(user.uid)
                  .collection('Classes')
                  .document(widget.name)
                  .collection('Projects')
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) return new Text('...Loading');
                if (snapshot.data.documents.length < 1) {
                  return new Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: new ListView(
                        children: [
                          new ListTile(
                            title: Text(
                                'This class does not have any projects assigned'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Flexible(
                                  child: new ListView(
                    children: snapshot.data.documents.map<Widget>((doc) {
                      return Card(
                        color: Colors.blueGrey[300],
                                            child: ExpansionTile(
                          key: GlobalKey(),
                        /*  onExpansionChanged: (isExpanded) {
                            if (isExpanded)
                              previousOffset = _scrollController.offset;
                            _scrollToSelectedContent(isExpanded, previousOffset,
                                2, expansionTileKey);
                          },*/
                          title: new Text(doc['projectTitle'],
                              style: modalLabel),
                          subtitle: new Text('Due Date: ' +
                              doc['dueDate'].toDate().toString(), style: modalInfo),
                          children: <Widget>[
                            Card(
                              child: new ListTile(
                                title: new Text("Compile & View Class Data"),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () {
                  proj = new GetProject(
                  doc['projectTitle'], doc['projectID']);
                  proj.questionData().whenComplete(() => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TeacherViewClassData(
                                  //user: user.uid,
                                  className: widget.name,
                                  classProjDocID:
                                      doc.documentID,
                                  proj: proj),
                        ),
                    )
                  });
                                },
                              ),
                            ),
                            Card(
                              child: new ListTile(
                  title: new Text(
                  "View Student Codes for Project"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                        builder: (context) =>
                            ViewAllStudentCodes(
                              teachID: user.uid,
                              classID: widget.name,
                              projectID: doc.documentID,
                              title: doc['projectTitle'],
                            )),
                    );
                  }),
                            ),
                            Card(
                              child: new ListTile(
                  title: new Text("Change Project Due Date"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                        builder: (context) =>
                            ChangeProjectDueDate(
                              teachID: user.uid,
                              classID: widget.name,
                              projectID: doc.documentID,
                              dueDate: doc.data['dueDate']
                                  .toDate(),
                            )),
                    );
                  }),
                            ),
                            Card(
                              child: new ListTile(
                  title: new Text("Delete Project"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                        builder: (context) =>
                            DeleteProjectFromClass(
                              teachID: user.uid,
                              classID: widget.name,
                              projectID: doc.documentID,
                            )),
                    );
                  }),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
