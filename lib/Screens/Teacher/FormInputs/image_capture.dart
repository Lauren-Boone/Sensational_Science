import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensational_science/models/student.dart';
import 'package:sensational_science/Services/storeLocally.dart';

//code based off of https://fireship.io/lessons/flutter-file-uploads-cloud-storage/

class AddImageInput extends StatefulWidget {
  final TextEditingController controller;

  AddImageInput({this.controller});

  @override
  _AddImageInputState createState() => _AddImageInputState();
}

class _AddImageInputState extends State<AddImageInput>{
  
  @override
  Widget build(BuildContext context) {
    return new Container(

      margin: EdgeInsets.all(2.0),
     decoration: BoxDecoration(
        
        //color: Colors.blue[100],
    border: Border.all(color: Colors.black),
   //backgroundBlendMode: BlendMode.darken
  ),
          
         child: TextFormField(
            controller: widget.controller,
            decoration: new InputDecoration(
              hintText: ' Image Upload Prompt',
            ),
          ),
       
    );
  }
}

