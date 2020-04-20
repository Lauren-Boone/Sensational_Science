import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:provider/provider.dart';
import 'package:sensational_science/models/user.dart';



class AddRoster extends StatefulWidget{
  final String name;
  AddRoster({this.name});
 @override
  _AddRosterState createState() => _AddRosterState();
}


class _AddRosterState extends State<AddRoster>{
  String name;
  List<DynamicWidget> roster=[];

addStudent(){
  
  roster.add(new DynamicWidget());
  setState((){

  });
}

submitData(teachID) async {

  Firestore.instance
  .runTransaction((transaction) async{
    await transaction.set(Firestore.instance
    .collection("Teachers")
  .document(teachID)
  .collection('Classes')
  .document(widget.name)
  .collection('Roster')
  .document(),
  {
    
    'name': 'Lauren',
  
  });
  });

print(teachID);
  }


  /*
  List<String> tags = List.from(doc.data['name']);
  
    if(tags.contains(element.controller.text)==true){
    
    docRef.addData({
      'Name' : FieldValue.arrayRemove([element.controller.text])
    });
    
  }
  else{
    docRef.updateData(
      {
      'Name' : FieldValue.arrayUnion([element.controller.text])
      });
  }
  });
  
  roster.forEach(
    (widget)=>print(widget.controller.text)
  );
}
*/
@override

  Widget build(BuildContext context){
  final user = Provider.of<User>(context);
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Add Roster"),
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: new ListView.builder(
                  itemCount: roster.length,
                  itemBuilder: (_, index)=>roster[index]

                  ),
                ),
                new Container(
                  child: new RaisedButton(
                    child: new Text('Submit'),
                    onPressed: 
                    submitData(user.uid),
                    ),
                ),
            ],
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: addStudent,
          child: new Icon(Icons.add),
        ),
      ),
    );
    
  
}
}

class DynamicWidget extends StatelessWidget{
  final controller = new TextEditingController();
  @override
  Widget build(BuildContext context){
    return Container(
      margin: new EdgeInsets.all(8.0),
      child: new TextField(
        controller: controller,
        decoration: new InputDecoration(hintText: 'Enter Student Name'),
      ),
    );
  }
}