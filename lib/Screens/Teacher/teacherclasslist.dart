import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'classInfo.dart';

class ClassListPage extends StatefulWidget{
 @override
  _ClassListState createState() => _ClassListState();
}


class _ClassListState extends State<ClassListPage>{
    
 

  
  @override
getClassList(String teachName){
 
  return (Firestore.instance.collection('Teachers')
        .document('Dr. Who')
        .collection('Classes')
        .snapshots()
        );
}



  Widget build(BuildContext context){

    
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Classes")
      ),
          body: Material(
            child: new StreamBuilder<QuerySnapshot>(
          stream: getClassList("Dr. Who"),
          
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData)return new Text('..Loading');
            return new ListView(
              children: snapshot.data.documents.map((document){
                return new ListTile( 
  
                    title: new Text(document['name']),
                    subtitle: new Text('Click to View Class Info'),
                    trailing: Icon(Icons.arrow_forward_ios), 
              onTap: () =>{
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>ClassInfo( name: document['name']),
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

