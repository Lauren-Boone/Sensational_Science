import 'package:flutter/material.dart';
import 'Shared/constants.dart';



class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  
  String _currentName;
  String _currentEmail;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text('Update your Account Settings',
          style: TextStyle(fontSize: 18)
          ),
          SizedBox(height: 20),
          TextFormField(
             validator: (val)=> val.isEmpty ? 'Enter an email' : null,
           decoration: const InputDecoration(
                  hintText: 'New Email',
                ),
                onChanged: (val) => setState(() => _currentEmail = val),
          ),
             SizedBox(height: 20),
          TextFormField(
             validator: (val)=> val.isEmpty ? 'Update Name' : null,
           decoration: const InputDecoration(
                  hintText:  'Name',
                ),
                onChanged: (val) => setState(() => _currentName = val),
          ),


        ],
      )
    );
  }
}