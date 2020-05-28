import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sensational_science/models/student.dart';
import 'package:sensational_science/Services/storeLocally.dart';
//import 'package:provider/provider.dart';

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
        border: Border.all(color: Colors.black),
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


class ImageCapture extends StatefulWidget {
  final Student student;
  final String questionNum;
  final TextEditingController imgLocController;

  ImageCapture({this.student, this.questionNum, this.imgLocController});

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;

  // Select image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  //crop the image
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  // Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      //select image from camera or gallery
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget> [
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),

      //preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                FlatButton(
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                ),
              ],
            ),

            Uploader(file: _imageFile, 
              location: '${widget.student.teacherID}/${widget.student.className}/${widget.student.projectCode}/${widget.questionNum}/${widget.student.studentID}.png',
              controller: widget.imgLocController),
          ]
        ],
      ),
      floatingActionButton: RaisedButton(
        onPressed: (){
          //print('text of controller when leaving: ' + widget.imgLocController.text);
          //print('value.text of controller when leaving: ' + widget.imgLocController.value.text);
          Navigator.pop(context);
        },
        child: Text("Go Back"),
        
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;
  final String location;
  final TextEditingController controller;
  Uploader({this.file, this.location, this.controller});
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://citizen-science-app.appspot.com');

  StorageUploadTask _uploadTask;

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      //Manage task state and event subscription with StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (_, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent = event != null
            ? event.bytesTransferred /event.totalByteCount
            : 0;

          return Column(
            children: [
              if(_uploadTask.isComplete)
                Text('Party Time!'),
              if (_uploadTask.isPaused)
                FlatButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: _uploadTask.resume,
                ),
              if(_uploadTask.isInProgress)
                FlatButton(
                  child: Icon(Icons.pause),
                  onPressed: _uploadTask.pause,
                ),

              LinearProgressIndicator(value: progressPercent),
              Text('${(progressPercent*100).toStringAsFixed(2)} %'),
            ],
          );
        },
      );
    } else {
      //let user decide when to start upload
      return FlatButton.icon(
        label: Text('Save to Project'),
        icon: Icon(Icons.cloud_upload),
        onPressed:((){
          setState(() {
            _uploadTask = _storage.ref().child(widget.location).putFile(widget.file);
            widget.controller.text = widget.location;
            //print('location in image_capture: ' + widget.controller.value.text);
          });
        }),
      );
    }
  }
}