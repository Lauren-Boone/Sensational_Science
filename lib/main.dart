import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: new Center( 
        child: Material(
          elevation: 7.0,
          borderRadius: BorderRadius.circular(7.0),
          child: Container(
            height: 300.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Students',
                  style: TextStyle(
                    fontSize: 17.0
                  ),
                ),
                SizedBox(height: 45.0)
              ],))
        ),
      ),
    );
  }
}

class ClassListPage extends StatelessWidget{
  @override

  Widget build(BuildContext context){
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Teachers').snapshots(),
      builder:(BuildContext conetext, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData)return new Text('..Loading');
        return new ListView(
          children: snapshot.data.documents.map((document){
            return new ListTile( 
              title: new ListTile(
                title: new Text(document['name']),

              ),
            );
            
          }).toList(),
          );
      }

    );
  }
}