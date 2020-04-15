

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class ViewRoster extends StatefulWidget {
 //DocumentSnapshot snapshot;
 //final String classID;
  final String name;

  ViewRoster({ this.name});

  @override
  _ViewRosterState createState() => _ViewRosterState();
}



class _ViewRosterState extends State<ViewRoster>{
  @override
StreamSubscription<QuerySnapshot> subscription;
Query snap ;
List<DocumentSnapshot> snapshot;
@override
 void initState() {
  snap = Firestore.instance.collection("Teachers")
  .document("Dr. Who")
  .collection('Classes')
  .document(widget.name)
  .collection("Class Info");
    subscription = snap.snapshots().listen((datasnapshot) {
      setState(() {
        snapshot = datasnapshot.documents;
      });
    });
    super.initState();
  }
@override
Stream<DocumentSnapshot> getRosterList() {
    return(Firestore.instance.collection("Teachers")
    .document('Dr. Who')
    .collection('Classes')
    .document(widget.name)
    .collection("Class Info")
    .document('Roster')
    .snapshots()
    );
   
  }


  Widget build(BuildContext context){
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
         body: Material(
            child: new StreamBuilder(
          stream: Firestore.instance.collection("Teachers")
    .document('Dr. Who')
    .collection('Classes')
    .document(widget.name)
    .collection("Class Info")
    .document('Roster')
    .snapshots(),
          
          builder:(BuildContext context, snapshot){
            if(!snapshot.hasData)return new Text('..Loading');

                        return new ListView(
                          children: snapshot.data.document.map((document){
                return new ListTile( 
  
                    title: new Text(document['name']),
                    trailing: Icon(Icons.arrow_forward_ios), 
              onTap: () =>{
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>AddRoster(name: document['name']),
                  ),
                )
              },
                  
                  
                );
                
              }).toList(),
              );
          }

        
      ),
    ),
    );
    
  }
}

class Roster {
String name;
 static const NAME_KEY = 'name';
  Roster(Map<String, dynamic> json) {
        name = json[NAME_KEY];
       
    }
}