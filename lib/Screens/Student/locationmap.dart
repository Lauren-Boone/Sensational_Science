import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sensational_science/Screens/Student/student_view_class_data.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/userlocation.dart';
import 'package:sensational_science/Services/projectDB.dart';
import '../../models/project.dart';
import '../../Services/getproject.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Map<MarkerId, Marker> marker = <MarkerId, Marker>{};

// void add(lat, lon){
//   final String markerIdValue = "1";
//   final MarkerId markerId = MarkerId(markerIdValue);
//   final Marker marker = Marker(
//     markerId: markerId,
//     position: LatLng(43.65, -70.25)
//     );
// }
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
  final List<Marker> markers = [];
  void add(lat, lon) {
    // RegExp exp = new RegExp(r"^Lat: (.*), Long: (.*)");
    // var lms_actual = widget.lms.toString();
    // var lms_test = widget.lms.latlonInfo;
    // print(lms_actual);
    // Iterable<RegExpMatch> matches = exp.allMatches(lms_test);

    // double lat = double.parse(matches.toList()[0].group(1));
    // double lon = double.parse(matches.toList()[0].group(2));
    final String markerIdValue = "1";
    // final MarkerId markerId = MarkerId(markerIdValue);

    setState(() {
      markers.clear();
      final Marker marker = Marker(
          // markerId: markerId,
          // position: LatLng(lat, lon),
          // draggable: false,
          // infoWindow: InfoWindow(title: "Current Location"));
          GeoCoord(lat, lon));
      markers.add(marker);
    });
  }

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
  Widget build(BuildContext context) {
    // print(locationInfo);
    //print("in location" + widget.lms.toString());
    RegExp exp = new RegExp(r"^Lat: (.*), Long: (.*)");
    var lms_actual = widget.lms.toString();
    var lms_test = widget.lms.latlonInfo;
    print("LMS TEST: " + lms_test); 
    var check = true; 
    double lat, lon; 
    print(lms_actual);
    if (lms_test != "" && lms_test != "null"){
    Iterable<RegExpMatch> matches = exp.allMatches(lms_test);

     lat = double.parse(matches.toList()[0].group(1));
     lon = double.parse(matches.toList()[0].group(2));
    }else{
      //print("No valid location info available. Location Info set to (0.0, 0.0)");
      lat = 0.0; 
      lon = 0.0; 
      check = false; 
    }

    add(lat, lon);
    // if (lms_test == "") {
    //   print("No valid location info available. Location Info set to (0.0, 0.0)");
    //   lat = 0.0;
    //   lon = 0.0;
    //   check = false; 
    // }

    MediaQueryData queryData; 
    queryData = MediaQuery.of(context); 
    final heightSize = MediaQuery.of(context).size.height / 3 - 10; 
    final widthSize = MediaQuery.of(context).size.width/2; 
    return Material(
      child: new AspectRatio(
        aspectRatio: 100/100,
              child: new Container(
        child: Column(
          children: <Widget>[
            if(check)
              new Container(
                margin: EdgeInsets.only(top: 10),
              height: heightSize,
              width: widthSize,
              child: GoogleMap(
                  mapType: MapType.hybrid,
                  initialPosition:
                      GeoCoord(lat, lon),
                  markers: Set.from(markers)),
              )
              else if(!check)
                Text("No valid location entered. Location Info temporarily set to (0.0, 0.0)") 
              else
                

              //                 Container(
              // height: heightSize,
              // width: widthSize,
              // child: GoogleMap(
              //     mapType: MapType.hybrid,
              //     initialCameraPosition:
              //         CameraPosition(target: LatLng(lat, lon), zoom: 11),
              //     markers: Set.from(markers)),
              // ),
            Expanded(child: Text('Location')),
            // Container(
            //   height: MediaQuery.of(context).size.height / 3,
            //   width: MediaQuery.of(context).size.width / 3,
            //   child: GoogleMap(
            //       mapType: MapType.hybrid,
            //       initialCameraPosition:
            //           CameraPosition(target: LatLng(lat, lon), zoom: 11),
            //       markers: Set.from(markers)),
            // )
          ],
        ),
      ),
      )
      // child: new Container(
      //   child: Column(
      //     children: <Widget>[
      //       if(check)
      //         new Container(
      //         height: heightSize,
      //         width: widthSize,
      //         child: GoogleMap(
      //             mapType: MapType.hybrid,
      //             initialCameraPosition:
      //                 CameraPosition(target: LatLng(lat, lon), zoom: 11),
      //             markers: Set.from(markers)),
      //         )
      //         else
      //           Text("No valid location entered. Location Info set to (0.0, 0.0)"), 
      //                         Container(
      //         height: heightSize
      //         width: widthSize,
      //         child: GoogleMap(
      //             mapType: MapType.hybrid,
      //             initialCameraPosition:
      //                 CameraPosition(target: LatLng(lat, lon), zoom: 11),
      //             markers: Set.from(markers)),
      //         ),
      //       Expanded(child: Text('Location')),
      //       // Container(
      //       //   height: MediaQuery.of(context).size.height / 3,
      //       //   width: MediaQuery.of(context).size.width / 3,
      //       //   child: GoogleMap(
      //       //       mapType: MapType.hybrid,
      //       //       initialCameraPosition:
      //       //           CameraPosition(target: LatLng(lat, lon), zoom: 11),
      //       //       markers: Set.from(markers)),
      //       // )
      //     ],
      //   ),
      // ),
    );
  }
}

class locationInfo {
  // double latitude = 0.0;
  // double longitude = 0.0;
  String latlonInfo;

  locationInfo({this.latlonInfo});
}