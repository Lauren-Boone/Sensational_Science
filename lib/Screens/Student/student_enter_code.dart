import 'package:flutter/material.dart';
import 'package:sensational_science/Screens/Student/student_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';


class StudentEnterCode extends StatefulWidget{
  StudentEnterCode({Key key}) : super(key: key);

  @override
  _StudentEnterCodeState createState() => _StudentEnterCodeState();
}

class _StudentEnterCodeState extends State<StudentEnterCode> {
  final _formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();

  findCode(idCode) async {
    var data = Firestore.instance.collection('codes').document(idCode).get();
    await data.then((doc) {
      return doc.exists;
    });
  }

 getCodeData(String idCode) async {
    var data = Firestore.instance.collection('codes').document(idCode).get();
    return await data.then((doc) {
      if(!doc.exists) {
        return null;
      }
      print(doc['teacher'] +' '+doc['project']+' '+doc['class']);
      return [doc['teacher'], doc['project'], doc['class']];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Access Project"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                controller: codeController,
                decoration: const InputDecoration(
                  hintText: 'Enter your project code',
                ),

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your project code';
                  }
                  // if (!findCode(value)) {
                  //   print('findCode was false');
                  //   return 'Please enter a valid project code';
                  // }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () async {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    var data = await getCodeData(codeController.text);
                    if (data == null) {
                      return;
                    }
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> StudentHome(teacher: data[0], project: data[1], className: data[2],)));
                  },
                  child: Text('Go to Project'),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Go back'),
      ),
    );
  }
}

