import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../../Services/getproject.dart';
import 'textquestion.dart';

class ViewProject extends StatefulWidget {
  final String docIDref;
  final String title;
  ViewProject({this.docIDref, this.title});
  @override
  _ViewProjectState createState() => _ViewProjectState();
}

class _ViewProjectState extends State<ViewProject> {

  
   @override

  Widget build(BuildContext context) {
  GetProject project = new GetProject(docID: widget.docIDref, title: widget.title);
  project.getdataFromProject();
  project.questions.forEach((e){
    var type = e.type;
    switch(type){
      case 'TextInputItem':
      return new TextQuestionWidget(question: e);
    }
  });
  //project.printproj();
 return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      
      body: Container(
        child: Card(
                  child: ListTile(
                    title: Text('Print Values to debug console'),
                    subtitle: Text(''),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      project.printproj();
                    }
                  ),
            ),
      
      ),
 );
   
  }
}

