import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';
import 'package:sensational_science/Screens/Teacher/viewprojectstaging.dart';
import 'package:sensational_science/models/user.dart';
import 'viewproject.dart';
import 'dart:async';



class ListProjects extends StatefulWidget {
  @override
  _ListProjectsState createState() => _ListProjectsState();
}

class _ListProjectsState extends State<ListProjects> {
  String projInfo = 'Need to add project info field to create a project staging page';
  
  getProjectList(String teachID)async{
  
    return (Firestore.instance.collection('Teachers')
          .document(teachID)
          .collection('Created Projects')
          .snapshots()
          );
  }

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
  String filterId="";
  bool hasfilter = false;
  bool subjectFilter=false;
  bool hasownedfilter=false;
  bool ownedfilter=false;
  List<dynamic> filters= new List();

  String toggleview = "View project you have created and added";

  _getStream(String uid){
    
    
      if(subjectFilter && hasownedfilter){
        return Firestore.instance.collection('Teachers')
          .document(uid)
          .collection('Created Projects')
          .where(filterId, isEqualTo: filter)
          .where('owned', isEqualTo: ownedfilter )
          .snapshots();
      }
      else if(subjectFilter){
     return Firestore.instance.collection('Teachers')
          .document(uid)
          .collection('Created Projects')
          .where(filterId, isEqualTo: filter)
          .snapshots();
      }
      else if(hasownedfilter){
        return Firestore.instance.collection('Teachers')
          .document(uid)
          .collection('Created Projects')
          .where('owned', isEqualTo: ownedfilter )
          .snapshots();
      }
    
    else{
      return Firestore.instance.collection('Teachers')
          .document(uid)
          .collection('Created Projects')
          .snapshots();
    }
  }
  String curVal="All";
@override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Projects You've Created"),
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
          body: Material(
            child: Column(
              children: <Widget>[
                new DropdownButton(
                  value: curVal,
            items: subjects.map<DropdownMenuItem<String>>((String value) {
              
                            return DropdownMenuItem<String>(
                              value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String newValue) {
              curVal=newValue;
              if(newValue == 'All'){
                setState(() {
                  
                  subjectFilter=false;
                  hasfilter=false;
                  _getStream(user.uid);
                });
              }
              else{
              
              setState(() { 
                curVal;
                 hasfilter = true;
                filter = newValue;
                filterId='subject';
                subjectFilter=true;
                _getStream(user.uid);
              });
              }
               
              //print(filter);
            },
          ),
           SwitchListTile(
                  value: hasownedfilter,
                  title:
                      const Text('Toggle to view projects you created or all'),
                  onChanged: (value) {
                    setState(() {
                       hasownedfilter = value;
                      
                      //print( hasownedfilter);
                      if ( hasownedfilter.toString() == 'false') {
                        toggleview = 'Current Setting: Viewing project you have created';
                      } else {
                        toggleview = 'Current Setting: Viewing project you have added';
                      }
                    });
                  },
                  subtitle: Text(toggleview),
                ),
                new StreamBuilder<QuerySnapshot>(
          stream: _getStream(user.uid),
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData)return new Text('..Loading');
                
                return Expanded(
                                  child: new ListView(
                      children: snapshot.data.documents.map((document){
                        
                        return new ListTile( 
  
                            title: new Text(document['title']),
                            subtitle: new Text('Click to View Project'),
                            trailing: Icon(Icons.arrow_forward_ios), 
                      onTap: () =>{
                        //projInfo= _getInfo(document['docID']),
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>ViewProjectStaging(document['title'], document['docIDref'], document['info'], document.documentID, user.uid ),
                          ),
                        )
                      },
                          
                          
                        );
                        
                      }).toList(),
                      ),
                );
          }

        ),
              ],
            ),
      ),
    );
    
  }


}

