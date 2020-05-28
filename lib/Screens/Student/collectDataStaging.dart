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
  String projInfo= "Please continue to collect your data";
  _CollectDataStagingState(title, docID, student) {
    this.docIDref = docID;
    this.title = title;
    this.student = student;
    project = new GetProject(title, docID);
    project.questionData();
  }
  @override
  Widget build(BuildContext context) {
    return new Material(
    child: new Scaffold(
         
          appBar: AppBar(
       title: Text("Collect Data"),
       leading: IconButton(
         icon: Icon(Icons.arrow_back),
         onPressed: () => Navigator.pop(context, false),
       ),
       //backgroundColor: Colors.deepPurple,
       ),
          body:
      Container(
        padding: EdgeInsets.all(20),
        child: Center(
             child: Column(children: <Widget>[
               Card(
                 child:  Text(
                   widget.title,style: TextStyle(
                     fontSize: 34,
                   ),),
               ),
               Card(
                 child: Text(this.projInfo,
                   style: TextStyle(
                     fontSize: 18,
                   )),
               ),
               RaisedButton(
                 onPressed: () {
                   //color: Colors.blue;
                   setState(() {});
                   project.questions.forEach((element) {
                     //print(element.question);
                   });
                   Navigator.of(context).push(
                 MaterialPageRoute(
                  builder: (context) =>CollectDataPage(this.title, this.docIDref, this.student, this.project ),
                 ),
             
               );
                 },
                 child: Text('Click to View Questions'),
                
               ),
             ]),
           ),
      )
        
    ),

    );
       
  }


   @override
  void initState() {
    super.initState();
  }

  Future<void> _getQuestions() async {
    await project.questionData();
    setState(() {});
  }

}