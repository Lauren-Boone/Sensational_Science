import 'package:flutter/material.dart';
import 'package:sensational_science/Screens/Student/student_collect_data.dart';
// import 'package:sensational_science/Screens/Teacher/FormInputs/userlocation.dart';
import '../../Services/getproject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

// Future<Position> getUserLocation() async {
//   try {
//     Position currentUserPosition = await Geolocator()
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     print(currentUserPosition);
//     return currentUserPosition;
//   } catch (ex) {
//     Position currentUserPosition;
//     currentUserPosition = null;
//     print('Error getting user location');
//     return currentUserPosition;
//   }
// }

class UserLocationInfo extends StatefulWidget {
  final Questions question;
  final TextEditingController userLocationController; 
  UserLocationInfo({this.question, this.userLocationController});
  Position currentUserPosition;
  // Function(int, dynamic) locationCallback;
  // UserLocationInfo({this.question, this.userLocationController, this.locationCallback});
  @override
  _UserLocationInfoState createState() => _UserLocationInfoState();

  Future<Position> getUserLocation() async {
    try {
      Position currentUserPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(currentUserPosition);
      return currentUserPosition;
    } catch (ex) {
      Position currentUserPosition;
      currentUserPosition = null;
      print('Error getting user location');
      return currentUserPosition;
    }
  }
}

class _UserLocationInfoState extends State<UserLocationInfo> {
  var results;
  //     getUserLocation(){
  //   final Geolocator test = Geolocator()..forceAndroidLocationManager;
  //   test
  //   .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //   .then((Position position){
  //     print(position.toString());
  //     widget.locationCallback(0, position.toString());
  //     setState((){
  //       widget.currentUserPosition = position;
  //     });
  //   }).catchError((ex){
  //     print(ex);
  //   });
  // }

 
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
                controller: widget.userLocationController;
                var questionObservations = Observation.of(context);
                widget.getUserLocation().then((result) {
                  // setState(() {
                  //   results = result;
                  // });
                  widget.userLocationController.text = result.toString();
                  questionObservations.addAnswer(0, result.toString()); 
                });
                print("Success!");
              },
            ),
            if (results != null) 
            new Text('$results'),
          ],
        ));
  }
}
