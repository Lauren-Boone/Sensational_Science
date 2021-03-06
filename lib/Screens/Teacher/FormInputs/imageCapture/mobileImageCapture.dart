import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensational_science/models/student.dart';
import 'package:sensational_science/Services/storeLocally.dart';
import 'package:sensational_science/Shared/styles.dart';


//code based off of https://fireship.io/lessons/flutter-file-uploads-cloud-storage/

class ImageCapture extends StatefulWidget {
  final Student student;
  final String questionNum;
  final TextEditingController imgLocController;
  final File imageFile;

  ImageCapture({this.student, this.questionNum, this.imgLocController, this.imageFile});

  @override
  _ImageCaptureState createState() => _ImageCaptureState(imageFile: imageFile);
}

class _ImageCaptureState extends State<ImageCapture> {
  File imageFile;
  _ImageCaptureState({this.imageFile});

  // Select image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      if (selected != null) {
        imageFile = selected;
      }
    });
  }

  //crop the image
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
    );

    setState(() {
      imageFile = cropped ?? imageFile;
    });
  }

  // Remove image
  void _clear() {
    setState(() => imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: appTheme.scaffoldBackgroundColor,
      child: new Scaffold(
        appBar: AppBar(
            title: Text(widget.student.projectTitle + " #" + (int.parse(widget.questionNum) + 1).toString()),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                //print(widget.imgLocController.text);
                Navigator.pop(context, false);
              },
            )),
        //select image from camera or gallery
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget> [
              IconButton(
                icon: Icon(Icons.photo_camera, color: Colors.black),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              IconButton(
                icon: Icon(Icons.photo_library, color: Colors.black),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        ),

        //preview the image and crop it
        body: Material(
          color: appTheme.scaffoldBackgroundColor,
          child: ListView(
          children: <Widget>[
            if (imageFile != null) ...[
              Image.file(imageFile),
              Card(
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(Icons.crop),
                      onPressed: _cropImage,
                    ),
                    FlatButton(
                      child: Icon(Icons.clear),
                      onPressed: _clear,
                    ),
                  ],
                ),
              ),

              Uploader(file: imageFile, 
                student: widget.student,
                qNum: widget.questionNum,
                controller: widget.imgLocController),
            ]
          ],
        ),
        ),  
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;
  final Student student;
  final String qNum;
  final TextEditingController controller;
  bool uploaded = false;
  Uploader({this.file, this.student, this.qNum, this.controller});
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {

  @override
  Widget build(BuildContext context) {
    if (widget.uploaded == false) {
      return Card(
        child: ListTile(
        title: Text('Save to Project'),
        trailing: Icon(Icons.arrow_downward, color: Colors.black),
        onTap: () => setState(() => widget.uploaded = true)
        ),
      );
    } else { 
      return new FutureBuilder(
        future: writeImage(widget.student.code, widget.qNum, widget.file),
        builder: (context, AsyncSnapshot<File> snapshot) {
          if (snapshot.hasData) {
            widget.controller.text = '${widget.student.teacherID}/${widget.student.className}/${widget.student.projectCode}/${widget.qNum}/${widget.student.studentID}.png';          
            return Card(
              child: ListTile(
                title: Center(
              child: Text('Success!',
                style: TextStyle(
                  fontSize: 24
                ),
              ),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        }
      );
    }
  }
}