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
  final codeController = new TextEditingController();

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
    return MaterialApp(
        theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        
         brightness: Brightness.light,
        //  accentColor: Colors.lightBlueAccent,
        accentColor: Colors.deepPurpleAccent,
        primarySwatch: Colors.deepPurple,
        buttonTheme: ButtonThemeData(
           buttonColor: Colors.indigo[600],
           shape: RoundedRectangleBorder(),
           textTheme: ButtonTextTheme.primary,
           hoverColor: Colors.blue[900],
           highlightColor: Colors.blueGrey,
          splashColor: Colors.purpleAccent,
          
          
          
        ),
        cardTheme: CardTheme(
          color: Colors.green[100],
          
        ),
        iconTheme: IconThemeData(
          color: Colors.grey,
          
          
        ),
        
        
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
       
        highlightColor: Colors.deepPurpleAccent,
        // highlightColor: Colors.blueAccent,
      ),
          home: Scaffold(
        //backgroundColor: Colors.green[100],
        appBar: AppBar(
         // backgroundColor: Colors.green[300],
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
                Center(child: RaisedButton(
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
                        var code = codeController.text;
                        codeController.text = '';
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> StudentHome(classData: code))
                        );
                      }
                    },
                    child: Text('Go to Project'),
                  ),)
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
      ),
    );
  }
}

