import 'package:flutter/material.dart';


class TeacherHome extends StatelessWidget{
  @override

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Home")
      ),
      body: ListView(
          children: const <Widget>[
            Card(child: ListTile(
              title: Text('Classes'),
              subtitle: Text('View All Classes'),
              trailing: Icon(Icons.arrow_forward_ios), 
              ),
              ),
          ]
          ),
        
       floatingActionButton: RaisedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text("Go Back"),
          
        ),
      
        );
  }
}