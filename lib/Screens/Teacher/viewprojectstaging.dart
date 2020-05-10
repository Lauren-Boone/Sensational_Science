import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/models/user.dart';
import 'viewproject.dart';
import '../../Services/getproject.dart';

class ViewProjectStaging extends StatefulWidget {
  final String projectID; 
  final String title; 
  final String projInfo;
  final String createdProjID;
  ViewProjectStaging( this.title, this.projectID,this.projInfo, this.createdProjID); 

  @override
  _ViewProjectStagingState createState() => _ViewProjectStagingState(this.title, this.projectID, this.projInfo, this.createdProjID);
}

class _ViewProjectStagingState extends State<ViewProjectStaging> {
 GetProject project;
String docIDref;
  String title;
  String projInfo;
  String createdProjID;
   _ViewProjectStagingState(title, docID, projInfo, createdProjID) {
    this.docIDref = docID;
    this.title = title;
    this.projInfo=projInfo;
        project = new GetProject(title, docID);
        //_getQuestions();
        project.questionData();
        //project.questionData();
    // this.controllers = new List();
   

    // studentObservations = new Observation(docID);
  }

  @override
  Widget build(BuildContext context) {
final user = Provider.of<User>(context);
       return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
            title: Text("Random Widget"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body:
           Container(
             padding: EdgeInsets.all(20),
             child: Center(
                  child: Column(children: <Widget>[
                    Card(
                      child:  Text(
                        widget.title,style: TextStyle(
                          fontSize: 40,
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
                       builder: (context) =>ViewProjectPage(this.title, this.docIDref, this.project, this.createdProjID ),
                      ),
                  
                    );
                      },
                      child: Text('Click to View Questions'),
                      color: Colors.blue,
                    ),
                    RaisedButton(
                      child: Text('Click to delete project'),
                      color: Colors.red,
                      onPressed: (){
                         showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      //addQuestiontoAccordion.add(new DynamicWidget());
                      return AlertDialog(
                        
                          title: Text("Are you sure you want to remove this project?"),
                          content: Text('This will action will permantly delete this project and you will no longer have access to it.'),
                  
                                  actions: <Widget>[
                                    RaisedButton(
                                      child: Text('continue'),
                                      onPressed: () {
                                        
                                        Navigator.of(context).pop();
                                      },
                                    )
                            
                          ]);
                      },
                    );
                    
                    
                    Navigator.of(context).pop();
                      },
                ),
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