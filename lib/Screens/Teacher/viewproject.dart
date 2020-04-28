import 'package:flutter/material.dart';
import 'package:sensational_science/Services/projectDB.dart';
import '../../models/project.dart';
import '../../Services/getproject.dart';
import 'textquestion.dart';
import 'multiplechoicequestion.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/multiplechoice.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/userlocation.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/textInputItem.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/image_capture.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/shortAnswer.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/numericalInput.dart';
//import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

var createLocationHandler = new UserLocation();

var locationResult = createLocationHandler.getUserLocation();

var createTextInputHandler =
    new TextInputItem(controller: new TextEditingController());

var createMultipleChoice = new MultipleChoice();

var createImageCapture = new AddImageInput();

var createShortAnswer = new ShortAnswerItem();

var createNumericalInput = new NumericalInputItem();

class ViewProject extends StatefulWidget {
   String docIDref;
   String title;
    GetProject project;
  //ViewProject({this.docIDref, this.title});
  ViewProject(String docIDref, String title){
    this.docIDref = docIDref;
    this.title=title;
    project=new GetProject(this.title, this.docIDref);
  }

  @override
  _ViewProjectState createState() => _ViewProjectState();
}

class _ViewProjectState extends State<ViewProject> {
  GetProject project;
  int _currentQuestion = 0;
  Future projectFuture;
  
  
  int _getType(_currentQuestion) {
     //project.getdataFromProject();
    //setState(() {});
    //return project.getType(_currentQuestion);
    switch(project.questions[_currentQuestion].type){
      case 'TextInputItem':
        return 0;
      case 'MultipleChoice':
        return 1;
      case 'ShortAnswerItem':
        return 2;
      case 'UserLocation':
        return 3; 
    }
    return -1;
  }
   
Widget build(BuildContext context) {

  return new MaterialApp(
      
      home: new Scaffold(
          appBar: AppBar(title: Text("Random Widget")),
          body: 
          project.questions.length == 0

         ? Center(child: CircularProgressIndicator()
          
              
         )
         : 
          Center(child:
      
          FutureBuilder(
              initialData: 0,
              future: projectFuture,
              builder: (context, snapshot) {
            
                if(project.questions.length>0){
                  return getQuestionWidget();
               }
              else{
                  
                  return CircularProgressIndicator();
               }
              }
          )
      )),
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
   Widget getQuestionWidget() {

    switch(_getType(_currentQuestion++)){
      case 0:
        return Column(children: <Widget>[
          Text("TextInputItem", textScaleFactor: 4),
          getNextButton()
        ]);
        break;
      case 1:
        return Column(children: <Widget>[
          Text("MultipleChoice", textScaleFactor: 4),
          getNextButton()
        ]);
        break;
      case 2:
        return Column(children: <Widget>[
          Text("ShortAnswer", textScaleFactor: 4),
          getNextButton()
        ]);
        break;
      case 3:
        return Column(children: <Widget>[
          Text("UserLocation", textScaleFactor: 4),
          Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width / 3,
            child: Draggable<Widget>(
              child: Text('User Location'),
              data: createLocationHandler,
              feedback: Text('Text'),
            ),
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


Widget getNextButton(){
      return RaisedButton(
          child: Text("NEXT"),
          color: Colors.red,
          onPressed: () {
            if(_currentQuestion < project.questions.length){
                return getQuestionWidget();
            }
            return Text("All done!"); 
            //setState(() {
              
              //_currentQuestion++;
              //return getQuestionWidget();

              //_getType(_currentQuestion);
           // });

          }
      );
  }

  @override
  void initState() {
    //project = new GetProject(widget.title, widget.docIDref);
    //project.getdataFromProject();
    //_getQuestions();
  //  projectFuture=_getQuestions();
    super.initState();
    
  }

  Future<void> _getQuestions() async {
    // you mentioned you use firebase for database, so
    // you have to wait for the data to be loaded from the network
    return await project.getdataFromProject;
   
   
  }

  // Call this function when you want to move to the next page
  void goToNextPage() {
    //setState(() {
      _currentQuestion++;
   // });
  }


}