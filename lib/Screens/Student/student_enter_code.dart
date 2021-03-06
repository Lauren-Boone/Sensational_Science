import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensational_science/Screens/Student/student_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensational_science/Shared/styles.dart';

class StudentEnterCode extends StatefulWidget {
  StudentEnterCode({Key key}) : super(key: key);

  @override
  _StudentEnterCodeState createState() => _StudentEnterCodeState();
}

class _StudentEnterCodeState extends State<StudentEnterCode> {
  final _formKey = GlobalKey<FormState>();
  final codeController = new TextEditingController();

  getCodeData(String idCode) async {
    var data = Firestore.instance.collection('codes').document(idCode).get();
    return await data.then((doc) {
      if (!doc.exists) {
        return null;
      }
      //print(doc.data);
      return doc.data;
      //return [doc['teacher'], doc['project'], doc['class']];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Access Project"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 120.0,
                      width: 120.0,
                      child: Image.asset('assets/images/logo.jpg'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    controller: codeController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your project code',
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Please enter your project code' : null,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: RaisedButton(
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
                                    ]);
                              });
                        } else {
                          var code = codeController.text;
                          codeController.text = '';
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StudentHome(classData: code)));
                        }
                      },
                      child: Text('Go to Project'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back'),
        ),
      ),
    );
  }
}
