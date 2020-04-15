import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'roster.dart';


class AddRoster extends StatefulWidget{
  final String name;
  AddRoster({this.name});
 @override
  _AddRosterState createState() => _AddRosterState();
}


class _AddRosterState extends State<AddRoster>{
  List<DynamicWidget> roster=[];

addStudent(){
  roster.add(new DynamicWidget());
  setState((){

  });
}

submitData(){
  roster.forEach(
    (widget)=>print(widget.controller.text)
  );
}
@override
  Widget build(BuildContext context){

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.name.toUpperCase()),
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
                    onPressed: submitData,
                    child: new Text('Submit'),
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
  TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context){
    return Container(
      margin: new EdgeInsets.all(8.0),
      child: new TextField(
        controller: controller,
        decoration: new InputDecoration(hintText: 'Enter Student Name'),
      )
    );
  }
}