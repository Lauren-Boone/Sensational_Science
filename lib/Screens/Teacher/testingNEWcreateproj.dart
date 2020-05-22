import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/Screens/Teacher/addRoster.dart';
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

class AddQuestionsToProject extends StatefulWidget {
  final String title;
  final AddProject proj;
  final bool pub;
  final String uid;
  AddQuestionsToProject({Key key, this.title, this.proj, this.pub, this.uid}) : super(key: key);
  
  @override
  _AddQuestionsToProjectState createState() => _AddQuestionsToProjectState();
}

//List<TextEditingController> questions = new List<TextEditingController>();

class _AddQuestionsToProjectState extends State<AddQuestionsToProject> {
  //List<DynamicWidget> addQuestiontoAccordion = new List();
  List<DynamicWidget> questionwidgets = [];
  List<ItemData> items = [];
  List<String> typecontroller=[];
  List<TextEditingController> questions=[];
  List<List<TextEditingController>> answers = [];
  List<String> types = ["MultipleChoice", "TextInputItem", "ShortAnswerItem", "UserLocation", "NumericalInputItem", "AddImageInput"];
  String curVal='MultipleChoice';

  //String selected;
  int numQuestions = 0;
bool _checkforInput(){
  bool retVal = true;
  if(questionwidgets.length==0){
    retVal=false;
  }
  questionwidgets.forEach((element) {
    if(element.controller.text == ""){
      retVal = false;
      
    }
    if(element.type== "MultipleChoice"){
      if(element.answers.length == 0){
         retVal = false;
      }
      element.answers.forEach((e){
        if(e.answercontroller.text==""){
           retVal = false;
        }
      });
    }
  });
  return retVal;
}
  @override
  Widget build(BuildContext context) {
     final user = Provider.of<User>(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Add Questions To the Project'),
                          leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context, false),
                )
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
                setState((){}),
                showDialog(
                  
                    context: context,
                    
                    builder: (BuildContext context) {
                      //addQuestiontoAccordion.add(new DynamicWidget());
                      return AlertDialog(
                          actions: <Widget>[
                        new StatefulBuilder(
                         builder: (BuildContext context, StateSetter setState) {
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
                               
                               print(curVal);
                                setState(() {
                                  
                                });
                              },
                            ),
                           
                            
                             ],
                         
                          
                           );
                         }

                        ),
                         RaisedButton(
                              child: Text('Continue'),
                              onPressed: () {
                                if (curVal == "") {
                                } else {
                                  numQuestions++;
                                  setState(() {
                                   questionwidgets.add(new DynamicWidget(
                                      type: curVal, numq: numQuestions));
                                      typecontroller.add(curVal);
                                  });
                             
                                  Navigator.of(context).pop();
                                    
                                  
                                }
                              },
                            ),
                          ]
                          );
                    }),
              },
            ),
            RaisedButton(
                              child: Text('Submit Created Project'),
                              onPressed: (){
                                
                                if(questionwidgets.length == 0){
                                  return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text("A project must has questions!"),
                                  content: Text(
                                      "A project must questions."),
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
                                else if(!_checkforInput()){
                                  return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text("All Questions Must have input and all multiple choice questions must have answers!"),
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
                                }
                                else{
                                int i = 0;
                                questionwidgets.forEach((element) {
                                  questions.add(element.controller);
                                  if(element.answers.length>0){
                                     answers.add([]);
                                    element.answers.forEach((a) {
                                       
                                        answers[i].add(a.answercontroller);
                                    
                                    });
                                    i++;
                                  }
                                  questions.forEach((element) {
                                    print(element.value.text);
                                  });
                                  typecontroller.forEach((element) {
                                    print(element);
                                  });
                                  answers.forEach((element) {
                                    element.forEach((e) {
                                      print(e.value.text);
                                    });
                                  });

                                });
                             String docID=  widget.proj.createProjectDoc(widget.title, widget.pub, user.uid);
            widget.proj.addProjectDataToDoc(
                                  user.uid,
                                  questions,
                                  typecontroller,
                                  answers,
                                  numQuestions,
                                  widget.proj.getDocID());
  widget.proj.addtodb(numQuestions);
    Navigator.of(context).pop();
  Navigator.of(context).pop();
          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text("Project Successfully Created"),
                                  content: Text(
                                      "You can view this project is projects you've created. Try create a key to sampe the project!"),
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
  int numAnswers = 0;
  final String type;
  final int numq;

  DynamicWidget({this.type, this.numq});
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
