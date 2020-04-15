import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'roster.dart';

class ClassInfo extends StatefulWidget {
  //QuerySnapshot snapshot;
 //final String classID;
  final String name;

  ClassInfo({ this.name});

  @override
  _ClassInfoState createState() => _ClassInfoState();
}



class _ClassInfoState extends State<ClassInfo>{
  @override

@override
 


getInfoList() {
    return(Firestore.instance.collection("Teachers")
    .document('Dr. Who')
    .collection('Classes')
    .document(widget.name)
    .collection('Class Info')
    .snapshots()
    );
   
  }
  StreamSubscription<QuerySnapshot> subscription;

  List<DocumentSnapshot> snapshot;

  Query collectionReference;

   void initState() {
    collectionReference = Firestore.instance.collection('Teachers')
    .document('Dr. Who')
    .collection('Classes')
    .document(widget.name)
    .collection('Class Info');
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        snapshot = datasnapshot.documents;
      });
    });
    super.initState();
  }


  @override
  void dispose() {
    subscription.cancel(); //Streams must be closed when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (snapshot == null) return Center(
      child: Container(
        color: Colors.black,
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Container(
          color: Colors.green[300],
      
          child: CircularProgressIndicator(),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.green[300],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.green[100],
        ),
        centerTitle: true,
        backgroundColor: Colors.green[100],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
           
            Text(widget.name.toLowerCase(), style: TextStyle(color: Colors.black87, fontFamily: 'Dokyo'),)
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.length,
                      itemBuilder: (context, index) {
                       return  Card(child: ListTile(
              title: snapshot[index].data["name"],
              
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>ViewRoster(name: snapshot[index].data['name']),
                  ),
                );
              },
              ),
              );
                      }),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 15),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}