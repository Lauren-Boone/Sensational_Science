import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccount extends StatefulWidget{
  @override
  CreateAccountState createState(){
    return CreateAccountState(); 
  }
}

class CreateAccountState extends State<CreateAccount>{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          //Text form fields and raised button
          TextFormField(
            validator: (value){
              if(value.isEmpty){
                return 'Please enter some text'; 
              }
              return null; 
            },
          ),
          RaisedButton(
            onPressed: (){
              if(_formKey.currentState.validate()){

                Scaffold 
                  .of(context)
                  .showSnackBar(SnackBar(content: Text('Processing Data')));
              }
            },
            child: Text('Submit')
            )
        ]
      )
    );
  }
}