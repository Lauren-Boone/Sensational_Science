import 'package:flutter/material.dart';
import 'package:sensational_science/Screens/Student/saveStudentAnswers.dart';
import 'package:sensational_science/Screens/Student/student_collect_data.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';
import 'package:sensational_science/Screens/Teacher/viewprojectstaging.dart';
import 'package:sensational_science/Services/projectDB.dart';
import 'package:sensational_science/models/user.dart';
import '../../models/project.dart';
import '../../Services/getproject.dart';
import 'textquestion.dart';
import 'multiplechoicequestion.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/imageCapture/imageCaptureService.dart';
import 'shortanswerquestion.dart';
import 'numericalquestion.dart';
import 'UserLocationInfo.dart';
import 'multiplechoicequestion.dart';
import '../../Services/projectDB.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/models/student.dart';
import 'submittedPage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:sensational_science/Services/storeLocally.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ViewProjectPage extends StatelessWidget {
  final String projectID;
  final String title;
  final String createdProjectID;
  final String uid;
  GetProject project;
  ViewProjectPage(this.title, this.projectID, this.project,
      this.createdProjectID, this.uid);

  Widget build(BuildContext context) {
    final Student student = new Student.teacherKey(
        code: uid, projectCode: createdProjectID, projectTitle: title);
    return new Observation(
        key: new Key(projectID),
        projectID: this.projectID,
        answers: new Map(),
        child: new ViewProject(this.title, this.projectID, this.project,
            this.createdProjectID, student));
  }
}

class ViewProject extends StatefulWidget {
  final String docIDref;
  final String title;
  final String createdProjectID;
  final Student student;
  final GetProject project;
  bool done = false;
  List<TextEditingController> controllers = [new TextEditingController()];
  // Observation studentObservations;
//GetProject project;
  ViewProject(this.title, this.docIDref, this.project, this.createdProjectID,
      this.student) {
    //this.docIDref = docID;

    // this.project = project;

    // this.controllers = new List();
    //project.questionData().then((ignore) {
    for (int i = 1; i < this.project.questions.length; i++) {
      controllers.add(new TextEditingController());
      print("Values of i " + i.toString());
    }
    // });

    // studentObservations = new Observation(docID);
  }

  AddProject proj;

  @override
  _ViewProjectState createState() =>
      _ViewProjectState(this.title, this.docIDref);
}

class _ViewProjectState extends State<ViewProject> {
  _ViewProjectState(String title, String docID) {}
  int _currentQuestion = 0;

  Future<int> _getType(_currentQuestion) async {
    if (_currentQuestion < widget.project.questions.length) {
      switch (widget.project.questions[_currentQuestion].type) {
        case 'TextInputItem':
          return 0;
        case 'MultipleChoice':
          return 1;
        case 'ShortAnswerItem':
          return 2;
        case 'UserLocation':
          return 3;
        case 'NumericalInputItem':
          return 4;
        case 'AddImageInput':
          return 5;
      }
    }
  }

  bool _checkforAnswers(List<TextEditingController> answers) {
    bool retVal = false;
    answers.forEach((element) {
      if (element.text == null || element.text == "") {
        retVal = true;
      }
    });
    return retVal;
  }

  Widget build(BuildContext context) {
    List<TextEditingController> answers = [];
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          title: Text("Your Project"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          backgroundColor: Colors.deepPurple,
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
        body: Center(
            child: FutureBuilder(
                future: _getType(_currentQuestion),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return getQuestionWidget(context, snapshot.data);
                  } else if (_currentQuestion >=
                      widget.project.questions.length) {
                    return getQuestionWidget(context, -1);
                  } else {
                    return CircularProgressIndicator();
                  }
                })
            // )
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

  Widget getNextButton(BuildContext context) {
    //We need to add a var value as a parameter for this function to add to the controller
    return RaisedButton(
        child: Text("NEXT"),
        color: Colors.red,
        onPressed: () {
          var questionObservations = Observation.of(context);

          if (!questionObservations.answers.containsKey(_currentQuestion)) {
            questionObservations.addAnswer(
                widget.project.questions[_currentQuestion].number,
                widget.controllers[_currentQuestion].value.text);
          }

          print(questionObservations.toJson());
          if (_currentQuestion < widget.project.questions.length) {
            setState(() {
              _currentQuestion++;
              _getType(_currentQuestion);
            });
          }
        });
  }

  Widget getQuestionWidget(BuildContext context, int number) {
    if (_currentQuestion < widget.project.questions.length) {
      switch (number) {
        case 0:
          return Column(children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width / 1.2,
              child: Text("#" + (_currentQuestion + 1).toString() + ": " +
                  widget.project.questions[_currentQuestion].question, style: TextStyle(fontSize: 20)),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 1.33,
              child: Center(
                  child: new TextQuestionWidget(
                      textAnswerController:
                          widget.controllers[_currentQuestion])),
            ),
            getNextButton(context)
          ]);
          break;
        case 1:
          return Column(children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width / 1.2,
              child: Text("#" + (_currentQuestion + 1).toString() + ": " +
                  widget.project.questions[_currentQuestion].question, style: TextStyle(fontSize: 20)),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 3 * 2,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: new MultQuestionWidget(
                    question: widget.project.questions[_currentQuestion],
                    multChoiceController: widget.controllers[_currentQuestion]),
              ),
            ),
            getNextButton(context)
          ]);
          break;
        case 2:
          return Column(children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width / 1.2,
              child: Text("#" + (_currentQuestion + 1).toString() + ": " +
                  widget.project.questions[_currentQuestion].question, style: TextStyle(fontSize: 20)),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 1.33,
              child: new ShortAnswerQuestion(
                  shortAnswerController: widget.controllers[_currentQuestion]),
            ),
            getNextButton(context)
          ]);
          break;
        case 3:
          return Column(children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width / 1.2,
              child: Text("#" + (_currentQuestion + 1).toString() + ": " +
                  widget.project.questions[_currentQuestion].question, style: TextStyle(fontSize: 20)),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 1.33,
              child: new UserLocationInfo(
                userLocationController: widget.controllers[_currentQuestion],
              ),
            ),
            getNextButton(context)
          ]);
          break;
        case 4:
          return Column(children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width / 1.2,
              child: Text("#" + (_currentQuestion + 1).toString() + ": " +
                  widget.project.questions[_currentQuestion].question, style: TextStyle(fontSize: 20)),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 1.33,
              child: new NumericalQuestion(
                  numAnswerController: widget.controllers[_currentQuestion]),
            ),
            getNextButton(context)
          ]);
        case 5:
          return Column(children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              width: MediaQuery.of(context).size.width / 1.2,
              child: Text("#" + (_currentQuestion + 1).toString() + ": " +
                  widget.project.questions[_currentQuestion].question, style: TextStyle(fontSize: 20)),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 1.33,
              child: RaisedButton(
                child: Text('Click to upload or take photo'),
                onPressed: () async {
                  File preFilledFile;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ImageCapture(
                        student: widget.student,
                        questionNum: _currentQuestion.toString(),
                        imgLocController: widget.controllers[_currentQuestion],
                        imageFile: preFilledFile,
                      ),
                    ),
                  );
                },
              ),
            ),
            getNextButton(context),
          ]);
          break;
      }
    } else {
      return Column(children: <Widget>[
        Text(
            "Would you like to save your answers as an answer key/example project?",
            textScaleFactor: 2),
        RaisedButton(
          child: Text('Go back and review answers'),
          onPressed: () => {
            setState(() {
              _currentQuestion = 0;
            }),
            //getQuestionWidget(),
          },
        ),
        RaisedButton(
          onPressed: () async {
            final user = Provider.of<User>(context, listen: false);
            var results = Observation.of(context);
            if (_checkforAnswers(widget.controllers)) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("One or more of your answers is empty!"),
                      content:
                          Text("Your must submit an answer for each question!"),
                      actions: <Widget>[
                        RaisedButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            } else {
              //if answered on mobile app, store the image in the database (web is already stored)
              if (!kIsWeb) {
                for (var index = 0;
                    index < widget.project.questions.length;
                    index++) {
                  if (widget.project.questions[index].type == "AddImageInput") {
                    File image =
                        await getImage(widget.student.code, index.toString());
                    StorageUploadTask _uploadTask = FirebaseStorage(
                            storageBucket:
                                'gs://citizen-science-app.appspot.com')
                        .ref()
                        .child(widget.controllers[index].text)
                        .putFile(image);
                    await _uploadTask.onComplete;
                  }
                }
              }
              await saveAnswers(user.uid, widget.createdProjectID, results);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        saveStudentAnswers(results: Observation.of(context))),
              );
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Answer key has been saved!"),
                      content:
                          Text("You can now view your answer key."),
                      actions: <Widget>[
                        RaisedButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => ViewProjectStaging(
                        widget.project.title,
                        widget.project.docID,
                        widget.project.info,
                        widget.createdProjectID,
                        user.uid)),
                (Route<dynamic> route) => false,
              );
            }
          },
          child: Text('Submit Form'),
        )
      ]);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  // Call this function when you want to move to the next page
  void goToNextPage() {
    //setState(() {
    _currentQuestion++;
    // });
  }
}
