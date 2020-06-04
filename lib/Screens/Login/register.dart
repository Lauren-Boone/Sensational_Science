import 'package:flutter/material.dart';
import '../../Services/auth.dart';
import 'sign_in.dart';
import '../../Shared/styles.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({ this.toggleView });
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register> {
   final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  bool loading = false;
  String password='';
  String name = '';
String error='';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     theme: appTheme,
      
          home: Scaffold(
            
            backgroundColor: appTheme.scaffoldBackgroundColor,
        //backgroundColor: Colors.green[100],
        appBar: AppBar(
          //backgroundColor: Colors.green[300],
          title: Text('Create Account'),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Sign In'),
              onPressed: () => widget.toggleView(),
            ),
          ],
        ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                        validator: (val)=> val.length < 6 ? 'Enter Name' : null,
                        decoration: const InputDecoration(
                        hintText: 'Full Name',
                      ),
                        obscureText: false,
                        onChanged: (val){
                          setState(()=>name=val);
                        }
                        
                      ),
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
                        validator: (val)=> val.length < 6 ? 'Enter a password 6+ chars long' : null,
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
                          'Create Account',
                        ),
                        onPressed: () async{
                          if(_formKey.currentState.validate()){
                            dynamic result = await _auth.register(email.toString().trim(), password, name);
                            print(email);
                            if(result == null){
                              setState(()=> error = 'please supply a valid email');
                            }
                          }

                        }
                      ),
                      
                      SizedBox(height: 12),
                      Text(
                        error,
                        
                      ),
                        
                  ]
                ),
                ),
          ),
      ),

        
      ),
    );
  }
}