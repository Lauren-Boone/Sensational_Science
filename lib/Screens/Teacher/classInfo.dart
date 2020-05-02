import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'roster.dart';
import 'addRoster.dart';
import 'package:sensational_science/models/user.dart';
import 'package:provider/provider.dart';

class ClassInfo extends StatefulWidget {
  //QuerySnapshot snapshot;
 //final String classID;
  final String name;
  final String uid;

  ClassInfo({ this.name,this.uid});

  @override
  _ClassInfoState createState() => _ClassInfoState();
}



class _ClassInfoState extends State<ClassInfo>{
  @override

@override
 


 getInfoList(teachID)  {
    return (Firestore.instance.collection("Teachers")
    .document(teachID)
    .collection('Classes')
    .snapshots()
    );
  
   
   
  }



  @override
   Widget build(BuildContext context){
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Classes")
      ),
          body: Material(
            child: new StreamBuilder<QuerySnapshot>(
          stream: getInfoList(user.uid),
          
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData)return new Text('..Loading');
            return new ListView(
              children: snapshot.data.documents.map((document){
                return new ListTile( 
  
                    title: new Text("Roster"),
                    subtitle: new Text('Click to Add Roster'),
                    trailing: Icon(Icons.arrow_forward_ios), 
              onTap: () =>{
                  
                Navigator.of(context).push(
                  MaterialPageRoute(
                  
                    builder: (context) =>AddRoster( name: widget.name),
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
