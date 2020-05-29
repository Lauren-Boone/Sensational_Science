import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sensational_science/Screens/Teacher/staging.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';
import 'package:sensational_science/Services/getproject.dart';
import 'package:sensational_science/Services/projectDB.dart';
import 'package:sensational_science/models/user.dart';

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.

class ItemData {
  ItemData(this.title, this.key);

  final String title;

  // Each item in reorderable list needs stable and unique key
  final Key key;
}

enum DraggingMode {
  iOS,
  Android,
}

class EditQuestions extends StatefulWidget {
  final String title;
  final GetProject proj;

  EditQuestions({Key key, this.title, this.proj, String projTitle})
      : super(key: key);

  @override
  _EditQuestionsState createState() => _EditQuestionsState(this.proj);
}

//List<TextEditingController> questions = new List<TextEditingController>();
int numQuestions = 0;
List<ItemData> items = [];
List<String> typecontroller = [];
List<TextEditingController> questions = [];
List<DynamicWidget> questionwidgets = [];
_removeQuestion(int number) {
  questionwidgets.removeAt(number - 1);
  typecontroller.removeAt((number - 1));
  //questions.removeAt((number-1));
  //items.removeAt(number-1);
  numQuestions--;
  for (int i = (number - 1); i < questionwidgets.length; ++i) {
    questionwidgets[i].numq = i + 1;
  }
}

List<List<TextEditingController>> answers = [];


bool needStateChange = false;

class _EditQuestionsState extends State<EditQuestions> {
  GetProject proj;
  AddProject updateProj;
  final title =  TextEditingController();
  String newTitle;
  String docID;
  _EditQuestionsState(GetProject proj) {
    this.proj = proj;

    _getquestionwidgets();
  }

  

  getAddProj() {
    updateProj = new AddProject(
        title: title.text,
        public: proj.public,
        info: proj.info,
        teacherID: proj.teacherID,
        subject: proj.subject);
    //updateProj.setDocID(docID);
  }

  _getquestionwidgets() {
    proj.questions.forEach((element) {
      DynamicWidget toAdd = new DynamicWidget(
          type: element.type, numq: element.number + 1, callback: callback);
      typecontroller.add(element.type);
      questionwidgets.add(toAdd);
      if (element.type == "MultipleChoice") {
        int i = 0;
        element.answers.forEach((e) {
          DynamicAnswers answer = new DynamicAnswers(numAnswers: i);
          answer.answercontroller.text = e;
          toAdd.answers.add(answer);

          i++;
        });
      }
      questionwidgets[element.number].controller.text = element.question;
      numQuestions++;
    });
  }
  //List<DynamicWidget> addQuestiontoAccordion = new List();

  //List<List<TextEditingController>> answers = [];
  List<String> types = [
    "MultipleChoice",
    "TextInputItem",
    "ShortAnswerItem",
    "UserLocation",
    "NumericalInputItem",
    "AddImageInput"
  ];
  String curVal = 'MultipleChoice';

  //String selected;

  bool _checkforInput() {
    bool retVal = true;
    if (questionwidgets.length == 0) {
      retVal = false;
    }
    questionwidgets.forEach((element) {
      if (element.controller.text == "") {
        retVal = false;
      }
      if (element.type == "MultipleChoice") {
        if (element.answers.length == 0) {
          retVal = false;
        }
        element.answers.forEach((e) {
          if (e.answercontroller.text == "") {
            retVal = false;
          }
        });
      }
    });
    return retVal;
  }

  bool reset = false;
  callback(reset) {
    setState(() {
      needStateChange = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Questions To the Project'),
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
            new FlatButton.icon(
              onPressed: () => {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Material(
                        //padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                        child: CreateAProjectHelp(),
                      );
                    }),
              },
              icon: Icon(Icons.help, color: Colors.black),
              label: Text("Help", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: new ListView.builder(
                  itemCount: questionwidgets.length,
                  itemBuilder: (_, index) => questionwidgets[index]),
            ),
            new RaisedButton(
              child: new Text('Add a Question'),
              onPressed: () => {
                curVal = 'MultipleChoice',
                setState(() {}),
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      //addQuestiontoAccordion.add(new DynamicWidget());
                      return AlertDialog(actions: <Widget>[
                        new StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Column(
                            children: <Widget>[
                              Text("Select the type of question"),
                              DropdownButton(
                                value: curVal,
                                items: types.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String newValue) {
                                  curVal = newValue;

                                  //print(curVal);
                                  setState(() {});
                                },
                              ),
                            ],
                          );
                        }),
                        RaisedButton(
                          child: Text('Continue'),
                          onPressed: () {
                            if (curVal == "") {
                            } else {
                              numQuestions++;
                              setState(() {
                                questionwidgets.add(new DynamicWidget(
                                    type: curVal,
                                    numq: numQuestions,
                                    callback: callback));
                                typecontroller.add(curVal);
                              });

                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ]);
                    }),
              },
            ),
            RaisedButton(
              child: Text('Submit Created Project'),
              onPressed: () {
                if (questionwidgets.length == 0) {
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text("A project must has questions!"),
                            content: Text("A project must questions."),
                            actions: <Widget>[
                              RaisedButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ]);
                      });
                } else if (!_checkforInput()) {
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text(
                                "All Questions Must have input and all multiple choice questions must have answers!"),
                            content: Text(
                                "Please check that each field is has input."),
                            actions: <Widget>[
                              RaisedButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ]);
                      });
                } else {
                int i = 0;
                  questionwidgets.forEach((element) {
                    questions.add(element.controller);
                    if (element.answers.length > 0) {
                      answers.add([]);
                      element.answers.forEach((a) {
                        answers[i].add(a.answercontroller);
                      });
                      i++;
                    }
                     });
/*
                  if (proj.public == false) {
                   title.text = proj.title;
                     getAddProj();
                      docID = proj.docID;
                     updateProj.setDocID(docID);
                  if (proj.public == true) {
                    docID = updateProj.createProjectDoc(
                        title.text, proj.public, user.uid);
                  } 

                  updateProj.addProjectDataToDoc(user.uid, questions,
                      typecontroller, answers, numQuestions, docID);
                  updateProj.addtodb(numQuestions);
                  Navigator.of(context).pop();
                  } */
                 // else {
                    return showDialog(
                     context: context,
                     builder: (BuildContext context){
                       return AlertDialog(
                         title: Text("You must create a new title"),
                    content: TextField(
                            // focusNode: yourFocus,
                             controller: title,
                             decoration: InputDecoration.collapsed(
                                        hintText: "Choose a new Title"),
                             ),
                    actions: <Widget>[
                      RaisedButton(
                          child: Text("Continue"),
                          onPressed: () {
                            setState(() {
                              newTitle=title.text;
                            });
                            getAddProj();
                  
                    docID = updateProj.createProjectDoc(
                        title.text, proj.public, user.uid);
                  

                  updateProj.addProjectDataToDoc(user.uid, questions,
                      typecontroller, answers, numQuestions, docID);
                  updateProj.addtodb(numQuestions);
                           Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherHome()),
                  (Route<dynamic> route) => false,
                );
                           //Navigator.of(context).pop();
                          }),
                    ]
                       );
                     }
                    
                    );
                    
                    
                 // }

                  
                    //questions.forEach((element) {
                    //print(element.value.text);
                    // });
                    // typecontroller.forEach((element) {
                    //   //print(element);
                    // });
                    // answers.forEach((element) {
                    //   element.forEach((e) {
                    //     //print(e.value.text);
                    //   });
                    // });
                 
                 
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text("Project Successfully UPdated"),
                            content: Text(
                                "You can view this project is projects you've created. You will need to create a new answer key!"),
                            actions: <Widget>[
                              RaisedButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ]);
                      });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class DynamicWidget extends StatefulWidget {
  final controller = new TextEditingController();
  // final answercontroller = new List<TextEditingController>();
  final answers = new List<DynamicAnswers>();
  final Function(bool) callback;

  int numAnswers = 0;
  final String type;
  int numq;

  DynamicWidget({this.type, this.numq, this.callback});
  @override
  _DynamicWidgetState createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.type == "MultipleChoice") {
      return Container(
        // constraints: BoxConstraints(minWidth: 230.0, minHeight: 25.0),
        margin: new EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            new Text("Question: " + widget.numq.toString(),
                style: TextStyle(fontSize: 20)),
            new Text("Type: " + widget.type),
            new TextField(
              controller: widget.controller,
              decoration: new InputDecoration(hintText: 'Enter Question Here'),
              //onChanged: ((val) {}),
            ),
            new RaisedButton(
              child: Text('Add Answers'),
              onPressed: () => {
                //widget.numAnswers++,
                widget.answers
                    .add(new DynamicAnswers(numAnswers: widget.numAnswers)),
                setState(() {}),
              },
            ),
            new ListView.builder(
                shrinkWrap: true,
                itemCount: widget.answers.length,
                itemBuilder: (_, index) => widget.answers[index]),
            new RaisedButton(
              child: Text("Remove question"),
              onPressed: () => {
                _removeQuestion(widget.numq),
                //_removeAnswers(widget.numq),
                needStateChange = true,
                widget.callback(true),
                setState(() {}),
              },
            )
          ],
        ),
      );
    } else {
      return Container(
        margin: new EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            new Text("Question: " + widget.numq.toString(),
                style: TextStyle(fontSize: 20)),
            new Text("Type: " + widget.type),
            new TextField(
              controller: widget.controller,
              decoration: new InputDecoration(hintText: 'Enter Question Here'),
              onChanged: ((val) {
                //questions.add(controller);
              }),
            ),
            new RaisedButton(
              child: Text("Remove question"),
              onPressed: () => {
                _removeQuestion(widget.numq),
                needStateChange = true,
                widget.callback(true),
                // _removeAnswers(widget.numq),
                setState(() {}),
              },
            )
          ],
        ),
      );
    }
  }
}

class DynamicAnswers extends StatelessWidget {
  final answercontroller = new TextEditingController();
  final int numAnswers;
  DynamicAnswers({this.numAnswers});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width / 2,
        child: SizedBox(
          width: 50,
          child: new TextField(
            controller: answercontroller,
            decoration:
                new InputDecoration(hintText: 'Enter A Multiple Choice Answer'),
          ),
        ));
  }
}
