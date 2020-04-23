import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:sensational_science/Screens/Teacher/FormInputs/multiplechoice.dart';
import 'FormInputs/userlocation.dart'; 
import 'FormInputs/textInputItem.dart'; 

var createLocationHandler = new UserLocation();
var locationResult= createLocationHandler.getUserLocation(); 

var createTextInputHandler = new TextInputItem(); 

var createMultipleChoice = new MultipleChoice(); 

class CreateProject extends StatefulWidget {
  final String title;
  final bool pub;
  CreateProject({this.title, this.pub});
  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
        List<Widget> acceptData = [];
  @override

  Widget build(BuildContext context) {


    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        backgroundColor: Colors.grey[100],
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: DragTarget(
                  onWillAccept: (Widget addItem) {
                    print('checking if will accept item');
                    print(addItem);
                    if (addItem == null) {
                      return false;
                    }
                    return true;
                  },
                  onAccept: (Widget addItem) {
                    print('accepting an item');
                    acceptData.add(addItem);
                  },
                  builder: (context, List<dynamic> candidateData,
                      List<dynamic> rejectedData) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.lightBlue[50],
                      child: acceptData.isEmpty
                          ? Center(
                              child: Text('Add Form Fields Here'),
                            )
                          : Column(children: acceptData),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width / 3,
                      child: Draggable<Widget>(
                        child: Text('Text Input Field'),
                        data: createTextInputHandler,
                        feedback: Text('Text'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width / 3,
                      child: Draggable<Widget>(
                        child: Text('User Location'),
                        data: createLocationHandler,
                        feedback: Text('Text'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width / 3,
                      child: Draggable<Widget>(
                        child: Text('Add Multiple Choice'),
                        data: createMultipleChoice,
                        feedback: Text('Mult choice'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width / 3,
                      child: Draggable<Widget>(
                        data: new TextFormField(
                            decoration: new InputDecoration(
                                labelText: "Short Answer",
                                fillColor: Colors.white,
                                enabledBorder: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ))),
                        child: TextFormField(
                            decoration: new InputDecoration(
                                labelText: "Short Answer",
                                fillColor: Colors.white,
                                enabledBorder: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                )),
                                keyboardType: TextInputType.multiline,
                                
                                ),
                        feedback: Text('Short Answer'),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(40),
                      width: MediaQuery.of(context).size.width / 3,
                      child: Draggable<Widget>(
                        data: new TextFormField(
                          decoration: new InputDecoration(
                            labelText: "Numerical Input",
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                        ),
                        child: new TextFormField(
                          decoration: new InputDecoration(
                            labelText: "Numerical Input",
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                        ),
                        feedback: Text('Numerical Input'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
