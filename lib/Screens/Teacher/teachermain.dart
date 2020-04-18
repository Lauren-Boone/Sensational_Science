import 'package:flutter/material.dart';
import 'package:sensational_science/Screens/Teacher/teacherclasslist.dart';
import '../../Services/database.dart';
import 'package:provider/provider.dart';
import '../user_list.dart';
import '../../models/teacher.dart';
import '../../models/user.dart';


class TeacherHome extends StatelessWidget{
  
  @override

  Widget build(BuildContext context){
    return StreamProvider<List<Teacher>>.value(
        value: DatabaseService().user,
          child: Scaffold(
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
            ]
            ),
           
          
         floatingActionButton: RaisedButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text("Go Back"),
            
          ),
        
          ),
    );
  }
}