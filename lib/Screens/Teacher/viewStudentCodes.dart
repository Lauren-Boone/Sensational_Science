import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensational_science/Screens/Teacher/projectPreview.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';
import 'package:sensational_science/Services/getproject.dart';
import 'package:get/get.dart';
/*
class ViewStudentCodes extends StatelessWidget {
  final String teachID;
  final String classID;
  final String studentID;
  final String name;
  List<dynamic> answers = [];
  GetProject project;
  List<ListTile> tiles = [];

  ViewStudentCodes({this.teachID, this.classID, this.studentID, this.name});

  buildList(BuildContext context) async {
    var studentAnswers;
   
    var codeList = await Firestore.instance
        .collection('Teachers')
        .document(teachID)
        .collection('Classes')
        .document(classID)
        .collection('Roster')
        .document(studentID)
        .get();
    var projectList = Firestore.instance
        .collection('Teachers')
        .document(teachID)
        .collection('Classes')
        .document(classID)
        .collection('Projects');
    if (codeList.data.containsKey('codes') &&
        codeList.data['codes'].length > 0) {
      for (var pair in codeList['codes']) {
        for (var key in pair.keys) {
          await projectList.document(key).get().then((doc) {
            tiles.add(
              ListTile(
                  title: Text(doc['projectTitle'] + ': ' + pair[key]),
                  subtitle: Text(doc['dueDate'].toDate().toString()),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => {
                        studentAnswers = Firestore.instance
                            .collection('codes')
                            .document(pair[key]),
                        studentAnswers.get().then((value) => {
                              if (value.data.containsKey('Answers'))
                                {
                                  value.data.forEach((key, value) {
                                    if (key == "Answers") {
                                      answers.add(value);
                                    }
                                  }),
                                  project = new GetProject(
                                      doc['projectTitle'], doc['projectID']),
                                  print(project),
                                  project.questionData(),

                                
                              Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>PreviewProject(
                                        title: doc['projectTitle'],
                                        hasKey: true,
                                        proj: project,
                                        answers: answers,
                                      ),
                            ),
                          )
                                  
                                }
                              else
                                {}
                            }),
                      }),
            );
          });
        }
      }
    }
    if (tiles.length < 2) {
      tiles.add(ListTile(
        title: Text("The class has no projects assigned yet"),
      ));
    }
    return tiles;
  }

/*
    var codeList = await Firestore.instance.collection('Teachers').document(teachID).
      collection('Classes').document(classID).collection('Roster').document(studentID).get();
    var projectList = Firestore.instance.collection('Teachers').document(teachID).
        collection('Classes').document(classID).collection('Projects');
    if (codeList.data.containsKey('codes') && codeList.data['codes'].length > 0) {
      for (var pair in codeList['codes']) {
        for (var key in pair.keys) {
          await projectList.document(key).get().then((doc) {
            
            tiles.add(ListTile(
              title: Text(doc['projectTitle'] + ': ' + pair[key]),
              subtitle: Text(doc['dueDate'].toDate().toString()),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: ()=>{
            studentAnswers= Firestore.instance.collection('Codes').document(pair[key]),
            studentAnswers.get().then((value) => {
              if(value.data.containsKey('Answers')){
                value.data.forEach((key, value) {
                  if(key == "Answers"){
                    answers.add(value);
                  }
                }),
                project = new GetProject(doc['projectTitle'],doc['projectID']),
                project.questionData(),
                navigatorKey.currentState.pushNamed('/projectPreview.dart'),
                Get.to(PreviewProject(title: doc['projectTitle'], hasKey: true, proj: project, answers: answers,)),
              }
              else{
                        
              }
            }),

            
          },
            ),
            );
          });
        }
      }
    }

    if (tiles.length < 2) {
      tiles.add(ListTile(
        title: Text("The class has no projects assigned yet"),
      ));
    }
    return tiles;
  }*/

  @override
  Widget build(BuildContext context) {
     final GlobalKey<NavigatorState> navigatorKey =
        new GlobalKey<NavigatorState>();
    return MaterialApp(
      navigatorKey: navigatorKey,
          home: Scaffold(
        
        appBar: AppBar(
          title: Text(name + "'s Project Access Codes"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
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
          child: FutureBuilder(
              future: buildList(context),
              builder: (context, codes) {
                if (!codes.hasData) {
                  return Text("...Loading");
                } else {
                  return ListView(
                    children: codes.data,
                  );
                }
              }),
        ),
      ),
    );
  }
}
*/
class ViewStudentCodes extends StatefulWidget {
    final String teachID;
  final String classID;
  final String studentID;
  final String name;
  

  ViewStudentCodes({this.teachID, this.classID, this.studentID, this.name});
  @override
  _ViewStudentCodesState createState() => _ViewStudentCodesState(this.teachID, this.classID, this.studentID, this.name);
}

class _ViewStudentCodesState extends State<ViewStudentCodes> {
   String teachID;
   String classID;
   String studentID;
   String name;
  
  
  List<ListTile> tiles = [];
  _ViewStudentCodesState(this.teachID, this.classID, this.studentID, this.name){
    this.teachID = teachID;
    this.classID = classID;
    this.studentID= studentID;
    this.name = name;

  }
buildList(BuildContext context) async {
    var studentAnswers;
   
    var codeList = await Firestore.instance
        .collection('Teachers')
        .document(teachID)
        .collection('Classes')
        .document(classID)
        .collection('Roster')
        .document(studentID)
        .get();
    var projectList = Firestore.instance
        .collection('Teachers')
        .document(teachID)
        .collection('Classes')
        .document(classID)
        .collection('Projects');
    if (codeList.data.containsKey('codes') &&
        codeList.data['codes'].length > 0) {
      for (var pair in codeList['codes']) {
        for (var key in pair.keys) {
          await projectList.document(key).get().then((doc) {
            GetProject project;
            
            String leading="No answers submitted";
            List<dynamic> answers = new List();
             studentAnswers = Firestore.instance
                            .collection('codes')
                            .document(pair[key]);
                        studentAnswers.get().then((value) => {
                          
                         project = new GetProject(
                                      doc['projectTitle'], doc['projectID']),
                                 // print(project),
                                  project.questionData(),
                              //if (value.data.containsKey('Answers')){
                                  value.data.forEach((key, value) {
                                    if (key == "Answers") {
                                      answers.add(value);
                                      
                                    }
                                  }),
                                
                                  
                            
                           
                        });

                        
            tiles.add(
            
              ListTile(
                  title: Text(doc['projectTitle'] + ': ' + pair[key]),
                  subtitle: Text(doc['dueDate'].toDate().toString()),
                  //leading: Text(leading),
                  trailing: Icon(Icons.arrow_forward_ios),
                  
                  onTap: () => {
                       
                                if(answers.length == 0){
                                   showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("This student has not submitted answers yet"),
                          content: Text(
                              "Try again later or after the due date."),
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
                    ),
                                }
                                
                                else{
                              Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>PreviewProject(
                                        title: doc['projectTitle'],
                                        hasKey: true,
                                        proj: project,
                                        answers: answers[0],
                                      ),
                            ),
                          )
                                }
                                  
                              //  }
                             // else
                              //  {}
                            }),
                     
            );
          });
        }
      }
    }
    if (tiles.length == 0) {
      tiles.add(ListTile(
        title: Text("The class has no projects assigned yet",style: TextStyle(fontSize: 25)),
      ));
    }
    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
     
          child: Scaffold(
        
        appBar: AppBar(
          title: Text(name + "'s Project Access Codes"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
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
        body: Column(
          children: [
            SizedBox(height: 30),
            Text("Click on a project from the list to view the student's answers.", style: TextStyle(fontSize: 20)),
            Expanded(
                          child: Container(
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                    future: buildList(context),
                    builder: (context, codes) {
                      if (!codes.hasData) {
                        return Text("...Loading");
                      } else {
                        
                        return ListView(
                          children: codes.data,
                        );
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
  }
