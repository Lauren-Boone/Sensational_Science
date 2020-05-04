import 'package:flutter/material.dart';
import 'package:sensational_science/Screens/Student/student_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class StudentEnterCode extends StatefulWidget{
  StudentEnterCode({Key key}) : super(key: key);

  @override
  _StudentEnterCodeState createState() => _StudentEnterCodeState();
}

class _StudentEnterCodeState extends State<StudentEnterCode> {
  final _formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();

  getCodeData(String idCode) async {
    var data = Firestore.instance.collection('codes').document(idCode).get();
    return await data.then((doc) {
      if(!doc.exists) {
        return null;
      }
      print(doc.data);
      return doc.data;
      //return [doc['teacher'], doc['project'], doc['class']];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: Text("Access Project"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20,),
              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(
                  hintText: 'Enter your project code',
                ),
                validator: (value) => value.isEmpty ? 'Please enter your project code' : null,
              ),
              SizedBox(height: 20,),
              RaisedButton(
                color: Colors.blue[200],
                  onPressed: () async {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    var data = await getCodeData(codeController.text);
                    if (data == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Invalid Code"),
                            content: Text(
                                "The code you entered does not exist, please check the code and try again."),
                            actions: <Widget>[
                              RaisedButton(
                                child: Text("Close"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ]
                          );
                        }
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> StudentHome(classData: codeController.text))
                      );
                    }
                  },
                  child: Text('Go to Project'),
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

