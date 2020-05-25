import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/Screens/Teacher/projectPreview.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';
import 'package:sensational_science/models/user.dart';
import 'viewproject.dart';
import '../../Services/getproject.dart';

class ViewProjectStaging extends StatefulWidget {
  final String projectID; 
  final String title; 
  final String projInfo;
  final String createdProjID;
  final String uid;
  ViewProjectStaging( this.title, this.projectID,this.projInfo, this.createdProjID, this.uid); 

  @override
  _ViewProjectStagingState createState() => _ViewProjectStagingState(this.title, this.projectID, this.projInfo, this.createdProjID, this.uid);
}

class _ViewProjectStagingState extends State<ViewProjectStaging> {
 GetProject project;
String docIDref;
  String title;
  String projInfo;
  String createdProjID;
  bool hasKey = false;
  String uid;
  List<dynamic> answers = new List();
   _ViewProjectStagingState(title, docID, projInfo, createdProjID, uid) {
    this.docIDref = docID;
    this.title = title;
    this.projInfo=projInfo;
    this.createdProjID=createdProjID;
    this.uid=uid;
    
        project = new GetProject(title, docID);
        //_getQuestions();
        
        project.questionData();
        if(createdProjID == ""){

        }
        else{
        getAnswers(uid);
        }//project.questionData();
    // this.controllers = new List();
   

    // studentObservations = new Observation(docID);
  }
getAnswers(String user)async{
  DocumentSnapshot docRef = await Firestore.instance
  .collection('Teachers')
  .document(user)
  .collection('Created Projects')
  .document(this.createdProjID)
  .get();
  if(docRef.data.containsKey('Answers')){
    docRef.data.forEach((key, value) {
      if('$key' == 'Answers'){
        answers.addAll(value);
        hasKey=true;
      }
    });
  }
  setState(() {
    
  });
}
  @override
  Widget build(BuildContext context) {
final user = Provider.of<User>(context);
       return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
            title: Text("View Your Project"),
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
        body:
           Container(
             padding: EdgeInsets.all(20),
             child: Center(
                  child: Column(children: <Widget>[
                    Card(
                      child:  Text(
                        widget.title,style: TextStyle(
                          fontSize: 30,
                        ),),
                    ),
                    Card(
                      child: Text(widget.projInfo,
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    ),
                    
                    RaisedButton(
                      onPressed: () {
                        //color: Colors.blue;
                        setState(() {});
                        project.questions.forEach((element) {
                          print(element.question);
                        });
                        Navigator.of(context).push(
                      MaterialPageRoute(
                       builder: (context) =>ViewProjectPage(this.title, this.docIDref, this.project, widget.createdProjID, widget.uid),
                  
                    )
                        );
                      },
                      child: Text('Click to Create Answer Key'),
                      color: Colors.blue,
                    ),
                    RaisedButton(
                      child: Text("Click to Preview Questions"),
                      onPressed: ()=>{
                        //getAnswers(user.uid),
                        setState((){
                      
                       
                        }),
                        
                        Navigator.of(context).push(
                      MaterialPageRoute(
                       builder: (context) =>PreviewProject(title: this.title, proj: this.project, answers: this.answers, hasKey: hasKey),
                      ),
                  
                    ),

                      
                      },
                    )
                  
                  ]),
             ),
           ),
      ),
           
      
    );
       
  }


   @override
  void initState() {
    
     // _getQuestions();
     
    // done=false;
    super.initState();
  }

  Future<void> _getQuestions() async {
    // you mentioned you use firebase for database, so
    // you have to wait for the data to be loaded from the network
    await project.questionData();
    setState(() {});
  }

}