import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Services/getproject.dart';

class ViewClassData extends StatefulWidget {
  final String user;
  final String className;
  final String  classProjDocID;
  final GetProject proj;
  ViewClassData({this.user, this.className, this.classProjDocID, this.proj});
  //final String docID;
  @override
  _ViewClassDataState createState() => _ViewClassDataState(this.proj);
}

class _ViewClassDataState extends State<ViewClassData> {
  int _currentQuestion = 0;
  List<dynamic> questionData = [];
  GetProject proj;
  _ViewClassDataState(GetProject proj){
    this.proj = proj;
    proj.questionData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("View Data"),
        ),
        body: Container(
         child: Column(
            children: <Widget> [
             
             
             RaisedButton(
               child: Text('Click to view compiled data for each question'),
               onPressed: (){
                 CompiledProject data = new CompiledProject(proj: proj);
                 data.getStudentsAnswers(widget.className, widget.classProjDocID);
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>CompileData(proj: proj, compData: data),
                    ),
                  );
               } 
             )
            ]
         
           
         
           
            
         ),
        
        
        
        ),


    );
  }


}
class CompileData extends StatefulWidget {
final GetProject proj;
final CompiledProject compData;
CompileData({this.proj, this.compData});
  @override
  _CompileDataState createState() => _CompileDataState();
}

class _CompileDataState extends State<CompileData> {
  int _currentQuestion=0;
  @override

Widget getNextButton(BuildContext context){
return RaisedButton(
        child: Text("NEXT"),
        color: Colors.red,
        onPressed: () {
          if (_currentQuestion < widget.proj.questions.length) {
            setState(() {
              //controllers.add(value);
              _currentQuestion++;
              
            });
          }
          else{
            
          }
        });

}
  Widget build(BuildContext context){
    switch(widget.proj.questions[_currentQuestion].type.toString()){
      case 'TextInputItem':
          return Container(
            
            child: Column(
              children: <Widget>[
                Text('Text Input', style: TextStyle(color: Colors.white)),
               // new ListView.builder(
               //   itemCount: widget.proj.questions.length,
               //    itemBuilder: (_, index) => widget.compData.proj.questions[_currentQuestion].compAnswers[index]),
                getNextButton(context),
              ],
               
            ),
           
          );
          
          break;
        case 'MultipleChoice':
           return new Container(
            child: Column(
              children: <Widget>[
                Text('Mult'),
                 getNextButton(context),
              ],
            ),
           
          );
          break;
        case 'ShortAnswerItem':
          return new Container(
            child: Column(
              children: <Widget>[
                Text('Short Answer'),
                 getNextButton(context),
              ],
            ),
           
          );
          break;
        case 'UserLocation':
          return new Container(
            child: Column(
              children: <Widget>[
                Text('Location'),
                 getNextButton(context),
              ],
            ),
           
          );
          break;
        case 'NumericalInputItem':
           return new Container(
            child: Column(
              children: <Widget>[
                Text('Number'),
                 getNextButton(context),
              ],
            ),
           
          );
          break;
        case 'AddImageInput':
          return new Container(
            child: Column(
              children: <Widget>[
                Text('Image'),
                 getNextButton(context),
              ],
            ),
           
          );
          break;
          default: return new Container(

          );
    }
  }
}
