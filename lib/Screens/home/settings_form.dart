import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/Services/database.dart';
import 'package:sensational_science/Shared/loading.dart';
import 'package:sensational_science/models/user.dart';
import '../../Shared/constants.dart';
import '../../Services/database.dart';


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
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          return Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text('Update your Account Settings',
              style: TextStyle(fontSize: 18)
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: userData.email,
                 validator: (val)=> val.isEmpty ? 'New Email' : null,
               decoration: const InputDecoration(
                      hintText: 'New Email',
                    ),
                    onChanged: (val) => setState(() => _currentEmail = val),
              ),
                 SizedBox(height: 20),
              TextFormField(
                initialValue: userData.name,
              
                 validator: (val)=> val.isEmpty ? 'Update Name' : null,
               decoration: const InputDecoration(
                      hintText:  'Name',
                    ),
                    onChanged: (val) => setState(() => _currentName = val),
              ),

            RaisedButton(
              
                  color: Colors.pink[400],
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    await DatabaseService(uid: user.uid).updateUserData(
                      _currentName ?? userData.name,
                       _currentEmail ?? userData.email,
                       );
                    print(_currentName);
                    print(_currentEmail);
                    
                  
                  }
                ),
            ],
          )
        );
        }
        else{
          //return Loading();

        }
        
      }
    );
  }
}