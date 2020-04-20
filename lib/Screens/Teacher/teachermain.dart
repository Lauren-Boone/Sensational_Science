import 'package:flutter/material.dart';
import 'package:sensational_science/Screens/Teacher/teacherclasslist.dart';
import 'package:sensational_science/Screens/Teacher/teacher_add_class.dart';


class TeacherHome extends StatelessWidget{
  @override

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Home")
      ),
      body: ListView(
          children:  <Widget>[
            Card(child: ListTile(
              title: Text('Classes'),
              subtitle: Text('View All Classes'),
              trailing: Icon(Icons.arrow_forward_ios), 
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>ClassListPage(),
                  ),
                );
              },
              ),
            ),
            Card(child: ListTile(
              title: Text('Add Class'),
              subtitle: Text('Add A New Class'),
              trailing: Icon(Icons.arrow_forward_ios), 
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>AddClassPage(),
                  ),
                );
              },
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