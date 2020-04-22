import 'package:flutter/material.dart';
import 'package:sensational_science/Screens/Teacher/teacherclasslist.dart';
import 'package:sensational_science/Screens/Teacher/teacher_add_class.dart';
import 'package:sensational_science/Screens/Teacher/create_project.dart';
import '../../Services/database.dart';
import 'package:provider/provider.dart';
import '../home/user_list.dart';
import '../../models/teacher.dart';
import '../../models/user.dart';
import 'popup.dart';
import 'staging.dart';


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
              Card(
                child: ListTile(
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
              Card(
                child: ListTile(
                  title: Text('Create Project'),
                  subtitle: Text('Create A New Project From Scratch'),
                  trailing: Icon(Icons.arrow_forward_ios), 
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StagingPage(),
                      ),
                    );
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Pop up test'),
                  subtitle: Text('test popup'),
                  trailing: Icon(Icons.arrow_forward_ios), 
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PopUp(),
                      ),
                    );
                  },
                ),
              ),
            ],
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