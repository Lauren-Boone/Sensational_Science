import 'package:flutter/material.dart';
import 'viewproject.dart';
import '../../Services/getproject.dart';

class ViewProjectStaging extends StatefulWidget {
  final String projectID; 
  final String title; 
  final String projInfo;
  ViewProjectStaging(this.projInfo, this.title, this.projectID); 

  @override
  _ViewProjectStagingState createState() => _ViewProjectStagingState(this.title, this.projectID, this.projInfo);
}

class _ViewProjectStagingState extends State<ViewProjectStaging> {
 GetProject project;
String docIDref;
  String title;
  String projInfo;
   _ViewProjectStagingState(title, docID, projInfo) {
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
                       builder: (context) =>ViewProjectPage(this.title, this.docIDref, this.project ),
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