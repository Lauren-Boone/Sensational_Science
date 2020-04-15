import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sensational_science/main.dart';
import 'transition_route_observer.dart';
import 'login_screen.dart'; 

void main(){
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
        SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  runApp(MyApp());
}

class MyApp() extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Login', 
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.deepPurple,
        cursorColor: Colors.green,
        textTheme: TextTheme(
          headline3:TextStyle(
              fontFamily: 'OpenSans',
          ),
          caption: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          headline4: TextStyle(fontFamily: 'OpenSans')
        ),
      ),
      home: Login(),
      routes: {
        Login.routeName: (context) => Login()
      }
    )
  }
}