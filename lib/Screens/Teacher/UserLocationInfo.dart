import 'package:flutter/material.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/userlocation.dart';
import '../../Services/getproject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

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

class UserLocationInfo extends StatefulWidget {
  final Questions question;
  UserLocationInfo({this.question});
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
                getUserLocation().then((result) {
                  setState(() {
                    results = result;
                  });
                });
                print("Success!");
              },
            ),
            if (results != null) new Text('$results'),
          ],
        ));
  }
}
