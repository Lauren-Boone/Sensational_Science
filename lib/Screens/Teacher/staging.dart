import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sensational_science/Screens/Login/login_auth.dart';
import 'dart:async';
import 'create_project.dart';

class StagingPage extends StatefulWidget {
  @override
  StagePageState createState() {
    return StagePageState();
  }
}

class StagePageState extends State<StagingPage> {
  String _currentTitle = '';
  bool pub = true;
  String pubpriv='Current Setting: Public';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text("Add Project Info"),
      ),
      body: Material(
        
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                
                SizedBox(height: 20),
                TextFormField(
                  initialValue: '',
                  validator: (val) =>
                      val.isEmpty ? 'Enter Project Title' : null,
                  decoration: const InputDecoration(
                    hintText: 'Project Title',
                  ),
                  onChanged: (val) => setState(() => _currentTitle = val),
                ),
                SizedBox(height: 20),
                TextFormField(
                  
                  initialValue: '',
                  validator: (val) =>
                      val.isEmpty ? 'Enter Project Due Date' : null,
                  decoration: const InputDecoration(
                    hintText: 'Project Due Date',
                  ),
                  onChanged: (val) => setState(() => _currentTitle = val),
                ),
                 
                SwitchListTile(
                  value: pub,
                  title: const Text('Is this a public project? (Defuault Public)'),
                  onChanged: (value){
                    setState((){
                      pub = value;
                      print(pub);
                      if(pub.toString()=='true'){
                        pubpriv='Currect Setting: Public';
                      }
                      else{
                        pubpriv='Current Setting: Private';
                      }
                    });
                  },
                  subtitle: Text(pubpriv),
                  ),
                Card(
                  child: ListTile(
                    title: Text('Continue'),
                    subtitle: Text('Add Questions'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateProject(title: _currentTitle, pub: pub),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
