import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sensational_science/Screens/Student/student_view_class_data.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/userlocation.dart';
import 'package:sensational_science/Services/projectDB.dart';
import '../../models/project.dart';
import '../../Services/getproject.dart';

Map<MarkerId, Marker> marker = <MarkerId, Marker>{};

void add(lat, lon){
  final String markerIdValue = "1"; 
  final MarkerId markerId = MarkerId(markerIdValue); 
  final Marker marker = Marker(
    markerId: markerId, 
    position: LatLng(43.65, -70.25) 
    );
}
class LocationMap extends StatefulWidget {
  final TextEditingController controller;
  final locationInfo lms;
  // final List<String> locations;

  LocationMap({this.controller, this.lms});

  @override
  LocationMapState createState() => LocationMapState();
}

class LocationMapState extends State<LocationMap> {
  var results;

  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //       home: Scaffold(
  //           appBar: AppBar(
  //               title: Text("Location Test"),
  //               leading: IconButton(
  //                 icon: Icon(Icons.arrow_back),
  //                 onPressed: () => Navigator.pop(context, false),
  //               )),
  //           backgroundColor: Colors.grey[100],
  //           body: GoogleMap(
  //             mapType: MapType.hybrid,
  //             initialCameraPosition:
  //                 CameraPosition(target: LatLng(43.6591, -70.2568), zoom: 11),
  //           )));
  // }
  Widget build(BuildContext context){
    // print(locationInfo); 
    print("in location" + widget.lms.toString());
    RegExp exp = new RegExp(r"^Lat: (.*), Long: (.*)");
    var lms_actual = widget.lms.toString();
    var lms_test = widget.lms.latlonInfo; 
    print(lms_actual); 
    Iterable<RegExpMatch> matches = exp.allMatches(lms_test);
    
    double lat = double.parse(matches.toList()[0].group(1));
    double lon = double.parse(matches.toList()[0].group(2));

                return Material(
                  
                      child: new Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Text('Location')),
                    Container(
                      height: MediaQuery.of(context).size.height/3,
                      width: MediaQuery.of(context).size.width/3, 
                      child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition:CameraPosition(target: LatLng(lat, lon), zoom: 11),
             
                    ),
                    )],
              ),
             
            ),
          );

  }

}
