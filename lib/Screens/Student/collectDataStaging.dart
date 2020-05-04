import 'package:flutter/material.dart';
import 'package:sensational_science/models/student.dart';
import 'collectData.dart';
import '../../Services/getproject.dart';

class CollectDataStaging extends StatefulWidget {
  final String projectID; 
  final String title; 
  final String student;
  CollectDataStaging( this.title, this.projectID, this.student); 

  @override
  _CollectDataStagingState createState() => _CollectDataStagingState(this.title, this.projectID, this.student);
}

class _CollectDataStagingState extends State<CollectDataStaging> {
 GetProject project;
String docIDref;
  String title;
  String student;
 String projInfo= "We need to create a form to add project info still";
   _CollectDataStagingState(title, docID, student) {
    this.docIDref = docID;
    this.title = title;
    this.student = student;
        project = new GetProject(title, docID);
        //_getQuestions();
        project.questionData();
        //project.questionData();
    // this.controllers = new List();
   

    // studentObservations = new Observation(docID);
  }
  @override
  Widget build(BuildContext context) {

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
                      child: Text(this.projInfo,
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
                       builder: (context) =>CollectDataPage(this.title, this.docIDref, this.student, this.project ),
                      ),
                  
                    );
                      },
                      child: Text('Click to View Questions'),
                      color: Colors.blue,
                    ),
                  ]),
                ),
           )
      
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