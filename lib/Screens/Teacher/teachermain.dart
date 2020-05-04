import 'package:flutter/material.dart';
import 'package:sensational_science/Screens/Teacher/addProjectToClass.dart';
import 'package:sensational_science/Screens/Teacher/teacherclasslist.dart';
import 'package:sensational_science/Screens/Teacher/teacher_add_class.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/image_capture.dart';
import 'package:sensational_science/Screens/Teacher/testingNEWcreateproj.dart';
import '../../Services/database.dart';
import 'package:provider/provider.dart';
import '../home/user_list.dart';
import '../../models/teacher.dart';
import '../../models/user.dart';
import 'popup.dart';
import 'staging.dart';
import 'listprojects.dart';


class TeacherHome extends StatelessWidget{
  
  @override

  Widget build(BuildContext context){
    return StreamProvider<List<Teacher>>.value(
        value: DatabaseService().user,
          child: Scaffold(
        appBar: AppBar(
          title: Text("Home")
        ),
        backgroundColor: Colors.grey[100],
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
                  title: Text('New Create Project TEst'),
                  subtitle: Text('Create project'),
                  trailing: Icon(Icons.arrow_forward_ios), 
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>ExpansionTileSample(),
                      ),
                    );
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Assign Project to Class'),
                  subtitle: Text('Assign an Existing Project to an Existing Class'),
                  trailing: Icon(Icons.arrow_forward_ios), 
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>AddProjectToClass(),
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
                  title: Text('View Projects You Created'),
                  subtitle: Text(''),
                  trailing: Icon(Icons.arrow_forward_ios), 
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListProjects(),
                      ),
                    );
                  },
                ),
              ),
              
              Card(
                child: ListTile(
                  title: Text('Test Camera'),
                  subtitle: Text('Test opening camera & picture from file'),
                  trailing: Icon(Icons.arrow_forward_ios), 
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageCapture(),
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