import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth authorization = FirebaseAuth.instance; 
class CreateAccount extends StatefulWidget {
  @override
  CreateAccountState createState() {
    return CreateAccountState();
  }
}

class CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController(); 
  final TextEditingController passwordCheckController = TextEditingController(); 
  final TextEditingController firstNameController = TextEditingController(); 
  final TextEditingController lastNameController = TextEditingController(); 

  findUser(idUser) async {
    var data = Firestore.instance.collection('Teachers').document(idUser).get();
    await data.then((user) {
      return user.exists;
    });
  }

  getUserData(String idUser) async {
    var data = Firestore.instance.collection('Teachers').document(idUser).get();
    return await data.then((pw) {
      if (!pw.exists) {
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Create Account"),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(children: <Widget>[
                  //Text form fields and raised button
                    TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    maxLines: 1,
                    controller: passwordController,
                    decoration:
                        const InputDecoration(hintText: 'First Name'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your first name.';
                      }
                      return null;
                    },
                    
                  ),TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    maxLines: 1,
                    controller: passwordController,
                    decoration:
                        const InputDecoration(hintText: 'Last Name'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your last name.';
                      }
                      return null;
                    },
                    
                  ),TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    controller: emailController,
                    decoration: const InputDecoration(
                        hintText: 'Enter an email address'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an email address.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    maxLines: 1,
                    controller: passwordController,
                    decoration:
                        const InputDecoration(hintText: 'Enter a password'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a password.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    maxLines: 1,
                    controller: passwordCheckController,
                    decoration:
                        const InputDecoration(hintText: 'Re-enter password'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please re-enter password.';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Processing Data')));
                          }
                        },
                        child: Text('Create Account')),
                  )
                ]))));
  }
}

// @override
// // void creatAccount() async{
// //   final FirebaseUser user = (await FirebaseAuth.instance
// //     .createUserWithEmailAndPassword(
// //     email: emailController.text,
// //     password: passwordController.text

// //   ));
// // }
