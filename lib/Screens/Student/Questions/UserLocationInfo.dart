import 'package:flutter/material.dart';
import '../../../Services/getproject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'QuestionWidget.dart';


class UserLocationInfo extends StatefulQuestionWidget {
  final Questions question;
  final TextEditingController userLocationController;
  Position currentUserPosition; 
  Function(int, dynamic) locationCallback; 
  UserLocationInfo({this.question, this.userLocationController, this.locationCallback});
  @override
  _UserLocationInfoState createState() => _UserLocationInfoState();

  @override
  getAnswer() {
  }
}

class _UserLocationInfoState extends State<UserLocationInfo> {
  var results;

    getUserLocation(){
    final Geolocator test = Geolocator()..forceAndroidLocationManager; 
    test 
    .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
    .then((Position position){
      print(position.toString()); 
      widget.locationCallback(0, position.toString()); 
      setState((){
        widget.currentUserPosition = position; 
      }); 
    }).catchError((ex){
      print(ex); 
    }); 
  }

  @override
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Location"),
              onPressed: () {
                print("Test"); 
                // controller: widget.userLocationController;
                getUserLocation(); 

              },
            ),
            if (results != null) new Text('$results'),
            if (results == null) new Text('Error')
          ],
        ));
  }
}
