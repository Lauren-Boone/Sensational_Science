import 'package:flutter/material.dart';
import 'package:sensational_science/Services/projectDB.dart';
import '../../models/project.dart';
import '../../Services/getproject.dart';
import 'textquestion.dart';
import 'multiplechoicequestion.dart';
//import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

class ViewProject extends StatefulWidget {
  final String docIDref;
  final String title;

  ViewProject({this.docIDref, this.title});

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
    return project.getType(_currentQuestion);
    
  }
   
Widget build(BuildContext context) {

  return new MaterialApp(
      
      home: new Scaffold(
          appBar: AppBar(title: Text("Random Widget")),
          body: 
          //project.questions.length == 0

        //  ? Center(child: CircularProgressIndicator()
          
              
         // )
         // :
          Center(child:
      
          FutureBuilder(
              initialData: 0,
              future: projectFuture,
              builder: (context, snapshot) {
              switch(snapshot.connectionState){
                case ConnectionState.waiting: 
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  return getQuestionWidget();
                default:

              }

                //if(snapshot.ConnectionState.waiting){
           //       return mainScreen(context);
             ///   }
//else{
                  
               //   return CircularProgressIndicator();
              //  }
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

    switch(_getType(_currentQuestion)){
      case 0:
        return Column(children: <Widget>[
          Text("TextInputItem",textScaleFactor: 4),
          getNextButton()
        ]);
        break;
      case 1:
        return Column(children: <Widget>[
          Text("MultipleChoice",textScaleFactor: 4),
          getNextButton()
        ]);
        break;
      case 2:
        return Column(children: <Widget>[
          Text("ShortAnswer",textScaleFactor: 4),
          getNextButton()
        ]);
        break;
      case 3:
        return Column(children: <Widget>[
        Text("UserLocation",textScaleFactor: 4),
        getNextButton()
        ]);
        break;
        case -1:
        return Column(children: <Widget>[
        Text("Submit Page",textScaleFactor: 4),
        //getNextButton()
        ]);
        

      
    }
    
        
    
  }


Widget getNextButton(){
      return RaisedButton(
          child: Text("NEXT"),
          color: Colors.red,
          onPressed: () {
            _currentQuestion++;
            return getQuestionWidget();
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
    project = new GetProject(docID: widget.docIDref, title: widget.title);
    //project.getdataFromProject();
    //_getQuestions();
    super.initState();
    projectFuture=_getQuestions();
  }


  Future<void> _getQuestions() async {
    // you mentioned you use firebase for database, so 
    // you have to wait for the data to be loaded from the network
    return await project.getdataFromProject;
   
   //super.initState();
   
    //setState(() {
      
   // });
  }

  // Call this function when you want to move to the next page
  void goToNextPage() {
    setState(() {
      _currentQuestion++;
    });
  }

/*
  Widget _question(Questions question) {
    switch (question.type) {
      case 'TextInputItem':
        return TextQuestionWidget(question: question);
      case 'MultipleChoice':
        return MultQuestionWidget(question: question);
      //case 'ShortAnswer':
      //  return ShortAnswerQuestion(question: question);
      //case 'UserLocation':
      //  return UserLocationInfo(question: question);
    }
  }*/
}