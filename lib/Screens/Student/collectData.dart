import 'package:flutter/material.dart';
import 'package:sensational_science/Screens/Student/student_collect_data.dart';
import 'package:sensational_science/Services/projectDB.dart';
import '../../models/project.dart';
import '../../Services/getproject.dart';
import 'package:sensational_science/Screens/Teacher/textquestion.dart';
import 'package:sensational_science/Screens/Teacher/multiplechoicequestion.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/image_capture.dart';
import 'package:sensational_science/Screens/Teacher/shortanswerquestion.dart';
import 'package:sensational_science/Screens/Teacher/numericalquestion.dart';
import 'package:sensational_science/Screens/Teacher/UserLocationInfo.dart';
import '../../Services/projectDB.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/models/student.dart';

//import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

// var createLocationHandler = new UserLocationInfo();

// var locationResult = createLocationHandler.getUserLocation();

// var createTextInputHandler = new TextQuestionWidget();

// var createMultipleChoice = new MultQuestionWidget();

//var createImageCapture = new AddImageInput();

// var createShortAnswer = new ShortAnswerQuestion();

// var createNumericalInput = new NumericalQuestion();

class CollectDataPage extends StatelessWidget{
  final String projectID; 
  final String title; 
  final String code;
  final GetProject project;
  CollectDataPage(this.title, this.projectID, this.code, this.project); 

  Widget build(BuildContext context){
    final Student student = new Student(code: code);
    return new Observation(
      key: new Key(projectID), projectID: this.projectID, answers: new Map(), 
      child: new CollectData(student, this.project)
    );
  }
}

class CollectData extends StatefulWidget {
  
 
  final Student student;
  final GetProject project;
    //bool done = false;
  List<TextEditingController> controllers = [new TextEditingController()];
  // Observation studentObservations;
//GetProject project;
  CollectData(this.student, this.project) {
  
    //this.student = student;
   
    //this.project=project;
        //project = new GetProject(title, docID);
    // this.controllers = new List();
   // project.questionData().then((ignore) {
      for (int i = 1; i < project.questions.length; i++) {
        controllers.add( new TextEditingController());
        print("Values of i " + i.toString()); 
      }
    //});

    // studentObservations = new Observation(docID);
  }

  AddProject proj;

  @override
  _CollectDataState createState() =>
      _CollectDataState();
}

class _CollectDataState extends State<CollectData> {
  // GetProject project;
  // bool done = false;
  // List<TextEditingController> controllers = [];
  // Observation studentObservations;
  _CollectDataState() {
    // project = new GetProject(title, docID);
    // this.controllers = new List();
    // project.questionData().then((ignore) {
    //   for (int i = 0; i < project.questions.length; i++) {
    //     controllers[i] = new TextEditingController();
    //     print("Values of i " + i.toString()); 
    //   }
    // });

    // studentObservations = new Observation(docID);
    //project.questionData();
    //project.questionData();
  }
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
        appBar: AppBar(
            title: Text("Random Widget"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: widget.project.questions.length == 0
            ? Center(
                child: Column(children: <Widget>[
                  Card(
                    child: Text(widget.project.title),
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
                    // initialData: 0,
                    future: _getType(_currentQuestion),
                    builder: (context, snapshot) {
                      /*switch(snapshot.connectionState){
                case ConnectionState.waiting: 
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  return getQuestionWidget();
                default:
              }*/
                      if (snapshot.data != null) {
                        return getQuestionWidget(context, snapshot.data);
                      } else if (_currentQuestion >= widget.project.questions.length) {
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

  Widget getNextButton(BuildContext context) {
    //We need to add a var value as a parameter for this function to add to the controller
    return RaisedButton(
        child: Text("NEXT"),
        color: Colors.red,
        onPressed: () {
          var questionObservations = Observation.of(context);

          if(!questionObservations.answers.containsKey(_currentQuestion)){
            questionObservations.addAnswer(
                  widget.project.questions[_currentQuestion].number,
                  widget.controllers[_currentQuestion].value.text);
          }

          print(questionObservations.toJson());
            
          // setState(() {
          //   widget.studentObservations.addAnswer(
          //       widget.project.questions[_currentQuestion].number,
          //       widget.controllers[_currentQuestion].value.text);
          //   print(widget.studentObservations.toJson());
          // });
          if (_currentQuestion < widget.project.questions.length) {
            setState(() {
              //controllers.add(value);
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
            Text("TextInputItem " + (_currentQuestion + 1).toString(),
                textScaleFactor: 4),
            Text("Question: " + widget.project.questions[_currentQuestion].question),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 3,
              // child: Draggable<Widget>(
              child: Center(child: new TextQuestionWidget(
                textAnswerController: widget.controllers[_currentQuestion]
              )),
              // ),
            ),
            getNextButton(context)
          ]);
          break;
        case 1:
          return Column(children: <Widget>[
            Text("MultipleChoice " + (_currentQuestion + 1).toString(),
                textScaleFactor: 4),
            Text("Question: " + widget.project.questions[_currentQuestion].question),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 3 * 2,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: new MultQuestionWidget(
                  question: widget.project.questions[_currentQuestion], 
                  multChoiceController: widget.controllers[_currentQuestion]
                ),
              ),
            ),
            // Center(
            //   child: SizedBox(
            //     height: 400.0,
            //     child: ListView.builder(
            //         itemCount:
            //             widget.project.questions[_currentQuestion].answers.length,
            //         itemBuilder: (context, index) {
            //           //for(int i =0; i< project.questions[_currentQuestion].answers.length; ++i){
            //           return RadioListTile(
            //               title: Text(widget.project
            //                   .questions[_currentQuestion].answers[index]),
            //               // groupValue: selectedValue,
            //               value: widget.project
            //                   .questions[_currentQuestion].answers[index],
            //               onChanged: (value) {
            //                 setState(() {});
            //               },
            //               groupValue: null);
            //           // }
            //         }),
            //   ),
            // ),
            getNextButton(context)
          ]);
          break;
        case 2:
          return Column(children: <Widget>[
            Text("ShortAnswer " + (_currentQuestion + 1).toString(),
                textScaleFactor: 4),
            Text("Question: " + widget.project.questions[_currentQuestion].question),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 3,
              // child: Draggable<Widget>(
              //   child: Text('Short Answer'),
              child: new ShortAnswerQuestion(
                  shortAnswerController: widget.controllers[_currentQuestion]),
              //   feedback: Text('Short Answer'),
              // ),
            ),
            getNextButton(context)
          ]);
          break;
        case 3:
          return Column(children: <Widget>[
            Text("UserLocation " + (_currentQuestion + 1).toString(),
                textScaleFactor: 4),
            Text("Question: " + widget.project.questions[_currentQuestion].question),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 3,
              // child: Draggable<Widget>(
              // child: Text('User Location'),
              child: new UserLocationInfo(
                userLocationController: widget.controllers[_currentQuestion],
              ),
              //   feedback: Text('Text'),
              // ),
            ),
            getNextButton(context)
          ]);
          break;
        case 4:
          return Column(children: <Widget>[
            Text("Numerical " + (_currentQuestion + 1).toString(),
                textScaleFactor: 4),
            Text("Question: " + widget.project.questions[_currentQuestion].question),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 3,
              // child: Draggable<Widget>(
              //   child: Text('Numerical Input'),
              child: new NumericalQuestion(
                numAnswerController: widget.controllers[_currentQuestion]),
              //   feedback: Text('Numerical Input'),
              // ),
            ),
            getNextButton(context)
          ]);
        case 5:
          return Column(children: <Widget>[
            Text("Image" + (_currentQuestion + 1).toString(),
                textScaleFactor: 4),
            Text("Question: " + widget.project.questions[_currentQuestion].question),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width / 3,
              // child: Draggable<Widget>(
              //   child: Text('Image Upload'),
              child: RaisedButton(
                child: Text('Click to upload or take photo'),
                onPressed: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ImageCapture(
                        student: widget.student,
                        questionNum: _currentQuestion.toString(),
                        imgLocController: widget.controllers[_currentQuestion],
                      ),
                    ),
                  )
                },
              ),
              //   feedback: Text('Image'),
              // ),
            ),
            getNextButton(context)
          ]);
          break;
      }
    } else {
      return Column(children: <Widget>[
        Text("Submit Page", textScaleFactor: 4),
        //getNextButton()
      ]);
    }
  }

  @override
  void initState() {
    // setState(() {
    //   _getQuestions();
    // });
    // done=false;
    super.initState();
  }

  Future<void> _getQuestions() async {
    // you mentioned you use firebase for database, so
    // you have to wait for the data to be loaded from the network
    await widget.project.questionData();
    setState(() {});
  }

  // Call this function when you want to move to the next page
  void goToNextPage() {
    //setState(() {
    _currentQuestion++;
    // });
  }
}