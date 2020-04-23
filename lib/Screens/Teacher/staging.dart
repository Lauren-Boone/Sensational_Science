import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sensational_science/Screens/Login/login_auth.dart';
import 'dart:async';
import 'create_project.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class BasicDateField extends StatefulWidget {
  @override
  BasicDateFieldState createState() => BasicDateFieldState();
}

class BasicDateFieldState extends State<BasicDateField> {
  final format = DateFormat("yyyy-MM-dd");
  DateTime date; 
  @override
  Widget build(BuildContext context) {
  
    return Column(children: <Widget>[
      // Text('Basic Date Field (${format.pattern})'),
      DateTimeField(
        format: format,
        decoration: const InputDecoration(
          hintText: 'Project Due Date',
        ),
        onChanged: (dt) => setState(() => date = dt),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      )
    ]);
  }
}

class StagingPage extends StatefulWidget {
  @override
  StagePageState createState() {
    return StagePageState();
  }
}

class StagePageState extends State<StagingPage> {
  String _currentTitle = '';
  bool pub = true;
  String pubpriv = 'Current Setting: Public';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Project Info"),
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        margin: EdgeInsets.all(10),
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
                // TextFormField(
                //   initialValue: '',
                //   validator: (val) =>
                //       val.isEmpty ? 'Enter Project Due Date' : null,
                //   decoration: const InputDecoration(
                //     hintText: 'Project Due Date',
                //   ),
                //   onChanged: (val) => setState(() => _currentTitle = val),
                // ),
                BasicDateField(),
                SizedBox(height: 24),
                // RaisedButton(child: Text('Save Date'), 
                //   onPressed: () => _formKey.currentState.validate(),
                // ),
                SwitchListTile(
                  value: pub,
                  title:
                      const Text('Is this a public project? (Default Public)'),
                  onChanged: (value) {
                    setState(() {
                      pub = value;
                      print(pub);
                      if (pub.toString() == 'true') {
                        pubpriv = 'Current Setting: Public';
                      } else {
                        pubpriv = 'Current Setting: Private';
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
                          builder: (context) =>
                              CreateProject(title: _currentTitle, pub: pub),
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
