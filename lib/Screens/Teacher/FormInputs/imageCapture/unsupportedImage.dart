import 'package:flutter/material.dart';
import 'package:sensational_science/models/student.dart';
import 'dart:io';

class ImageCapture extends StatefulWidget {
  final Student student;
  final String questionNum;
  final TextEditingController imgLocController;
  final File imageFile;

  ImageCapture({this.student, this.questionNum, this.imgLocController, this.imageFile});

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {

  @override
  Widget build(BuildContext context) {
    throw ("Platform not recognized");
  }
}