import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/Screens/Teacher/projectPreview.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';
import 'package:sensational_science/Screens/Teacher/viewprojectstaging.dart';
import 'package:sensational_science/Services/getproject.dart';
import 'package:sensational_science/models/user.dart';

class PublicProjectsList extends StatefulWidget {
  @override
  _PublicProjectsListState createState() => _PublicProjectsListState();
}

class _PublicProjectsListState extends State<PublicProjectsList> {
  List<String> subjects = [
    "All",
    "Physics",
    "Biology",
    "Chemistry",
    "Astronomy",
    "Geography",
    "Geology"
  ];
  String filter = "All";
  bool hasfilter = false;
  
  @override
  Widget build(BuildContext context) {
     //final user = Provider.of<User>(context);
    return Material(
          child: Scaffold(
        appBar: AppBar(
          title: Text("View All Public Projects"),
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
        body: Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height * 0.8,
          child: Column(children: [
            new Text('Projects', style: TextStyle(fontSize: 20)),
            new DropdownButton(
              value: filter,
              items: subjects.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String newValue) {
                filter=newValue;
                if(newValue == 'All'){
                  setState(() {
                    hasfilter=false;
                  });
                }
                else{
                setState(() {
                   hasfilter = true;
                  filter = newValue;
                
                });
                }
                 
                print(filter);
              },
            ),
            new SizedBox(),
            filterWidget(context),
          ]),
        ),
      ),
    );
  }

  Widget filterWidget(BuildContext context) {
     final user = Provider.of<User>(context);
    if (hasfilter) {
      return Expanded(
              child: Column(
          children: <Widget>[
            new StreamBuilder(
              stream: Firestore.instance
                  .collection('Projects')
                  .where('public', isEqualTo: true)
                  .where('subject', isEqualTo: filter)
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) return new Text('...Loading');
                return new Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: new ListView(
                      children: snapshot.data.documents.map<Widget>((doc) {
                        return Card(
                                                  child: new ListTile(
                            title: new Text(doc['title']),
                            trailing: Icon(Icons.arrow_forward_ios), 
                onTap: () =>{
                  //projInfo= _getInfo(document['docID']),
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>ViewPublicStaging(doc['title'], doc.documentID, doc['info'], "", user.uid),
                    ),
                  )
                },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    } else {
      return Expanded(
              child: Column(
          children: <Widget>[
            new StreamBuilder(
              stream: Firestore.instance
                  .collection('Projects')
                  .where('public', isEqualTo: true)
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) return new Text('...Loading');
                return new Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: new ListView(
                      children: snapshot.data.documents.map<Widget>((doc) {
                        return Card(
                                                  child: new ListTile(
                            title: new Text(doc['title']),
                            subtitle: new Text(doc['info']),
                                  trailing: Icon(Icons.arrow_forward_ios), 
                onTap: () =>{
                  //projInfo= _getInfo(document['docID']),
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>ViewPublicStaging(doc['title'], doc.documentID, doc['info'], "", user.uid),
                    ),
                  )
                },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }
}




class ViewPublicStaging extends StatefulWidget {
  final String projectID; 
  final String title; 
  final String projInfo;
  final String createdProjID;
  final String uid;
  ViewPublicStaging(this.title, this.projectID,this.projInfo, this.createdProjID, this.uid); 

  @override
  _ViewPublicStagingState createState() => _ViewPublicStagingState(this.title, this.projectID, this.projInfo, this.createdProjID, this.uid);
}

class _ViewPublicStagingState extends State<ViewPublicStaging> {
 GetProject project;
String docIDref;
  String title;
  String projInfo;
  String createdProjID;
  bool hasKey = false;
   bool titleExists = false;
  String uid;
  List<dynamic> answers = new List();
   _ViewPublicStagingState(title, docID, projInfo, createdProjID, uid) {
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
        }
        checkforProject();//project.questionData();
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
checkforProject()async{
final existingProjects =
                          await Firestore.instance
                          .collection('Teachers')
                          .document(uid)
                          .collection('Created Projects')
                          .getDocuments();
                      for (var doc in existingProjects.documents) {
                        if (doc.data['docIDref'] == docIDref){
                          titleExists = true;
                        }
                      }
}

addProjectToTeacher() async{
  
                      
                     
                     

                  Firestore.instance
              .collection("Teachers")
              .document(uid)
              .collection('Created Projects')
              .add(
          {
            'docIDref': docIDref,
            'title': title,
            'info': this.projInfo,
            'subject': this.project.subject,
            'owned': false,
          });
                      
                      

    
}
  @override
  Widget build(BuildContext context) {
final user = Provider.of<User>(context);
       return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
            title: Text("View Project Information"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            ),
            backgroundColor: Colors.deepPurple,
              actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.home),
              label: Text('Home'),
              onPressed: () {
               Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>TeacherHome()),
             
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
                        
                        
                        if(titleExists){
                           return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text("Project Exists in your List"),
                                  content: Text(
                                      "This project is already in your list of projects!."),
                                  actions: <Widget>[
                                    RaisedButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ]);
                            });
                        }
                        else{
                          addProjectToTeacher();
                        }
                      
                      },
                      child: Text('Click to add this project your project list!'),
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