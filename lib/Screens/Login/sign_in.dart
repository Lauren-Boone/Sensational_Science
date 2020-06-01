import 'package:flutter/material.dart';
import 'package:sensational_science/Services/auth.dart';
import 'package:sensational_science/Screens/Student/student_enter_code.dart';
import 'package:sensational_science/Shared/styles.dart';
import 'create_account.dart';
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
      return MaterialApp(
        theme: appTheme,
              home: Scaffold(
         // backgroundColor: Colors.green[200],
          appBar: AppBar(
            //backgroundColor: Colors.deepPurple,
            title: Text('Log In'),
            actions: <Widget>[
              FlatButton.icon(
                color: Colors.white,
                icon: Icon(Icons.person),
                label: Text('Register'),
                onPressed: () => Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => CreateAccount()
                          ),
                )
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Column(
                children: <Widget>[
                  RaisedButton(
                   // color: Colors.blue[400],
                    child: Text('Access Project Using Student Code'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentEnterCode()
                        ),
                      );
                    },
                  ),
                  Container(height: 120.0,
        width: 120.0, child: Image.asset('assets/images/logo.jpg'),), 
                  Form(
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
                          //color: Colors.blue[400],
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
                ],
              ),
              ),
          ),
            ),
      );
      // ),

        
      // );
  }
}