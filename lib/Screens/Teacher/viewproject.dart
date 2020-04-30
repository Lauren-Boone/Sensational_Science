import 'package:flutter/material.dart';
import 'package:sensational_science/Services/projectDB.dart';
import '../../models/project.dart';
import '../../Services/getproject.dart';
import 'textquestion.dart';
import 'multiplechoicequestion.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/image_capture.dart';
import 'shortanswerquestion.dart';
import 'numericalquestion.dart';
import 'UserLocationInfo.dart';
import 'multiplechoicequestion.dart';
//import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

var createLocationHandler = new UserLocationInfo();

var locationResult = createLocationHandler.getUserLocation();

var createTextInputHandler = new TextQuestionWidget();

var createMultipleChoice = new MultQuestionWidget();

var createImageCapture = new AddImageInput();

var createShortAnswer = new ShortAnswerQuestion();

var createNumericalInput = new NumericalQuestion();

class ViewProject extends StatefulWidget {
  String docIDref;
  String title;
 
//GetProject project;
  ViewProject(title, docID) {
    this.docIDref = docID;
    this.title = title;
    
  }

  @override
  _ViewProjectState createState() =>
      _ViewProjectState(this.title, this.docIDref);
}

class _ViewProjectState extends State<ViewProject> {
  GetProject project;
  bool done = false;
 List<TextEditingController> controllers = [];
  _ViewProjectState(String title, String docID) {
    project = new GetProject(title, docID);
    this.controllers = new List();
    //project.questionData();
    //project.questionData();
  }
  int _currentQuestion = 0;


  Future<int> _getType(_currentQuestion) async {
    if (_currentQuestion < project.questions.length) {
      switch (project.questions[_currentQuestion].type) {
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
    } else {
      return -1;
    }
  }

 
  /* 
   Widget build(BuildContext context){
   
     if(done){
       
       return mainScreen(context);
     }
     else{
       renderPage();
       
       return CircularProgressIndicator();
     }
   }
*/

  Widget build(BuildContext context) {
    List<TextEditingController> answers = [];
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(title: Text("Random Widget")),
        body: project.questions.length == 0
            ? Center(
              
              child: Column(children: <Widget>[
                
                  Card(
                    
                    child: Text(widget.title),
                  ),
                  RaisedButton(
                    onPressed: () {
                      //color: Colors.blue;

                      setState(() {});
                    },
                    child: Text('Click to View Questions'),
                    color: Colors.blue,
                  ),
                ]),
            )
            : Center(
                child: FutureBuilder(
                    initialData: 0,
                    future: _getType(_currentQuestion),
                    builder: (context, snapshot) {
                      /*switch(snapshot.connectionState){
                case ConnectionState.waiting: 
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  return getQuestionWidget();
                default:
              }*/

                      if (project.questions.length > 0) {
                        return getQuestionWidget(snapshot.data);
                      } else {
                        return CircularProgressIndicator();
                      }
                    })
                // )
                ),
      ),
    );
  }

/*
Widget mainScreen(BuildContext context){
 
    /*return new MaterialApp(
      
      home: new Scaffold(
          appBar: AppBar(title: Text("Random Widget")),
          body: project.questions.length == 0
          ? Center(child: CircularProgressIndicator()
          
              
          )
          :
      */
      Center(child:
          FutureBuilder(
              initialData: 0,
              future: _getType(_currentQuestion),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return getQuestionWidget(snapshot.data);
                }
                else{
                  
                  return getQuestionWidget(-1);
                }
              },
          ),
      );
        //  )
     // )),
   // );
  }
*/

  Widget getNextButton() {
    //We need to add a var value as a parameter for this function to add to the controller
    return RaisedButton(
        child: Text("NEXT"),
        color: Colors.red,
        onPressed: () {
          if (_currentQuestion < project.questions.length) {
            
            setState(() {
              //controllers.add(value);
              _currentQuestion++;
              _getType(_currentQuestion);
            });
          }
        });
  }

  Widget getQuestionWidget(int number) {
    switch (number) {
      case 0:
        return Column(children: <Widget>[
          Text("TextInputItem " + (_currentQuestion + 1).toString(),
              textScaleFactor: 4),
          Text("Question: " + project.questions[_currentQuestion].question),
          Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width / 3,
            // child: Draggable<Widget>(
            child: Center(child: createTextInputHandler),
            // ),
          ),
          getNextButton()
        ]);
        break;
      case 1:
        return Column(children: <Widget>[
          Text("MultipleChoice " + (_currentQuestion + 1).toString(),
              textScaleFactor: 4),
          Text("Question: " + project.questions[_currentQuestion].question),
          Center(
            child: Flexible(
              child: SizedBox(
                height: 400.0,
                child: ListView.builder(
                    itemCount:
                        project.questions[_currentQuestion].answers.length,
                    itemBuilder: (context, index) {
                      //for(int i =0; i< project.questions[_currentQuestion].answers.length; ++i){
                      return RadioListTile(
                          title: Text(project
                              .questions[_currentQuestion].answers[index]),
                          // groupValue: selectedValue,
                          value: project
                              .questions[_currentQuestion].answers[index],
                          onChanged: (value) {
                            setState(() {});
                          },
                          groupValue: null);
                      // }
                    }),
              ),
            ),
          ),
          getNextButton()
        ]);
        break;
      case 2:
        return Column(children: <Widget>[
          Text("ShortAnswer " + (_currentQuestion + 1).toString(),
              textScaleFactor: 4),
          Text("Question: " + project.questions[_currentQuestion].question),
          Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width / 3,
            // child: Draggable<Widget>(
            //   child: Text('Short Answer'),
            child: createShortAnswer,
            //   feedback: Text('Short Answer'),
            // ),
          ),
          getNextButton()
        ]);
        break;
      case 3:
        return Column(children: <Widget>[
          Text("UserLocation " + (_currentQuestion + 1).toString(),
              textScaleFactor: 4),
          Text("Question: " + project.questions[_currentQuestion].question),
          Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width / 3,
            // child: Draggable<Widget>(
            // child: Text('User Location'),
            child: createLocationHandler,
            //   feedback: Text('Text'),
            // ),
          ),
          getNextButton()
        ]);
        break;
      case 4:
        return Column(children: <Widget>[
          Text("Numerical " + (_currentQuestion + 1).toString(),
              textScaleFactor: 4),
          Text("Question: " + project.questions[_currentQuestion].question),
          Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width / 3,
            // child: Draggable<Widget>(
            //   child: Text('Numerical Input'),
            child: createNumericalInput,
            //   feedback: Text('Numerical Input'),
            // ),
          ),
          getNextButton()
        ]);
      case 5:
        return Column(children: <Widget>[
          Text("Image" + (_currentQuestion + 1).toString(), textScaleFactor: 4),
          Text("Question: " + project.questions[_currentQuestion].question),
          Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width / 3,
            // child: Draggable<Widget>(
            //   child: Text('Image Upload'),
            child: RaisedButton(
              child: Text('Click to upload or take photo'),
                 onPressed: () =>{
                  
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>ImageCapture(),
                    ),
                  )
                },
            ),
            //   feedback: Text('Image'),
            // ),
          ),
          getNextButton()
        ]);
        break;

      case -1:
        return Column(children: <Widget>[
          Text("Submit Page", textScaleFactor: 4),
          //getNextButton()
        ]);
    }
  }

  @override
  void initState() {
    setState(() {
      _getQuestions();
    });
    // done=false;
    super.initState();
  }

  Future<void> _getQuestions() async {
    // you mentioned you use firebase for database, so
    // you have to wait for the data to be loaded from the network
    await project.questionData();
    setState(() {});
  }

  // Call this function when you want to move to the next page
  void goToNextPage() {
    //setState(() {
    _currentQuestion++;
    // });
  }
}
