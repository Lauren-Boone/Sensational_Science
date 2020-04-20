import 'package:flutter/material.dart';
import 'package:sensational_science/Services/auth.dart';
import 'register.dart';

import '../../Shared/loading.dart';
import '../../Shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
 final _formKey = GlobalKey<FormState>();
  //2 states store values in input fields
   bool loading = false;
  String email = '';
  String password='';
  String error='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: Text('Log In'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
            onPressed: () => Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => Register()
                      ),
            )
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              TextFormField(  
                validator: (val)=> val.isEmpty ? 'Enter an email' : null,
                 decoration: const InputDecoration(
                  hintText: 'Email',
                ),            
                onChanged: (val){
                  setState(()=> email = val);

                },
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (val)=> val.length < 6 ? 'Must be 6 characters' : null,
                   decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                  obscureText: true,
                  onChanged: (val){
                    setState(()=>password=val);
                  }
                  
                ),
                SizedBox(height: 20),
                RaisedButton(
                  color: Colors.blue[200],
                  child: Text(
                    'Sign In',
                  ),
                  onPressed: () async{
                    if(_formKey.currentState.validate()){
                     // setState(() => loading = true);
                      dynamic result = await _auth.signIn(email.toString().trim(), password);
                      print(email);
                      if(result == null){
                         loading = false;
                        setState(()=> error = 'please supply a valid email');
                      }
                    }

                  }
                ), 
                // RaisedButton(
                //   child: Text(
                //     'Create Account',
                //   ), onPressed: (){
                //     Navigator.push(
                //       context, MaterialPageRoute(
                //         builder: (context) => CreateAccount()
                //       )
                //     ); 
                //   }

                //   )
                
                
            ],
          ),
          ),
      ),

      
    );
  }
}