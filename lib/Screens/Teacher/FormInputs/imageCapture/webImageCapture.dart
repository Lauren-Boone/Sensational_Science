import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:sensational_science/models/student.dart';
import 'dart:io';
import 'package:sensational_science/Shared/styles.dart';


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
  Widget _camera;
  html.VideoElement _cameraVideo = new html.VideoElement();
  String key = UniqueKey().toString();
  Uint8List uploadedImage;
  String option1Text = "Select an image to upload";
  html.Blob imageBlob;
  bool _selectFromCamera = false;

  @override
  void initState() {
    super.initState();
    // _cameraVideo = new html.VideoElement();
    // //platformViewRegistry shows an error but should still work
    // ui.platformViewRegistry.registerViewFactory('cameraVideo', (int viewId) => _cameraVideo);
    // _camera = HtmlElementView(key: UniqueKey(), viewType: 'cameraVideo');
    // html.window.navigator.getUserMedia(video: true).then((html.MediaStream stream) {
    //   _cameraVideo.srcObject = stream;
    // });

    // _cameraVideo.play();
  }

  _startFilePicker() async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files.length == 1) {
        imageBlob = files[0];
        html.FileReader reader = html.FileReader();

        reader.onLoadEnd.listen((e) {
          setState(() {
            uploadedImage = reader.result;
            _selectFromCamera = false;
          });
        });

        reader.onError.listen((fileEvent) {
          setState(() {
            option1Text = "Some Error occured while reading the file";
            _selectFromCamera = false;
          });
        });

        reader.readAsArrayBuffer(imageBlob);
      }
    });
  }

  Future<void> _startImageCapture() async {
    html.MediaStream cameraFeed = _cameraVideo.captureStream();
    html.MediaStreamTrack track = cameraFeed.getVideoTracks().first;
    html.ImageCapture image = new html.ImageCapture(track);
    imageBlob = await image.takePhoto();

    html.FileReader reader = html.FileReader();

    reader.onLoadEnd.listen((e) {
      setState(() {
        uploadedImage = reader.result;
        _selectFromCamera = false;
      });
    });

    reader.onError.listen((fileEvent) {
      setState(() {
        option1Text = "Some Error occured while reading the file";
        _selectFromCamera = false;

      });
    });

    reader.readAsArrayBuffer(imageBlob);

    // cameraFeed.getVideoTracks().forEach((track) {
    //   track.stop();
    // });
    // _cameraVideo.pause();
    // _cameraVideo.removeAttribute('src');
    // _cameraVideo.load();
    //super.dispose();
  }

  //remove image
  void _clear() {
    setState(() {
      _selectFromCamera = false;
      uploadedImage = null;
    });
      //re-start the camera
    //   _cameraVideo = new html.VideoElement();
    //   //platformViewRegistry shows an error but should still work
    //   ui.platformViewRegistry.registerViewFactory('cameraVideo', (int viewId) => _cameraVideo);
    //   _camera = HtmlElementView(key: UniqueKey(), viewType: 'cameraVideo');
    //   html.window.navigator.getUserMedia(video: true).then((html.MediaStream stream) {
    //     _cameraVideo.srcObject = stream;
    //   });

    //   _cameraVideo.play();
    // });
  }

  void _cameraReStart() {
    setState(() async {
      //clear out old camera
            _cameraVideo.captureStream().getVideoTracks().forEach((track) {
              track.stop();
            });            
            _cameraVideo.pause();
            _cameraVideo.removeAttribute('src');
            _cameraVideo.load();
      //start a new camera
      _cameraVideo = new html.VideoElement();
      //platformViewRegistry shows an error but should still work
      ui.platformViewRegistry.registerViewFactory('cameraVideo', (int viewId) => _cameraVideo);
      _camera = HtmlElementView(key: UniqueKey(), viewType: 'cameraVideo');
      html.window.navigator.getUserMedia(video: true).then((html.MediaStream stream) {
        _cameraVideo.srcObject = stream;
      });

      _cameraVideo.play();
      _selectFromCamera = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appTheme.scaffoldBackgroundColor,
      child: Scaffold(
      appBar: AppBar(
        title: Text(widget.student.projectTitle + " Question " + widget.questionNum),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            //print(widget.imgLocController.text);
            _cameraVideo.captureStream().getVideoTracks().forEach((track) {
              track.stop();
            });            
            _cameraVideo.pause();
            _cameraVideo.removeAttribute('src');
            _cameraVideo.load();
            super.dispose();
            Navigator.pop(context, false);
          },
        )),
      body: Material(
        color: appTheme.scaffoldBackgroundColor,
        child: ListView(
        children: [
          if (uploadedImage != null) ... [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Card(
                child: Image.memory(uploadedImage),
              ),
            ),
            Card(
              child: ListTile(
                trailing: Icon(Icons.clear),
                title: Text('Clear image'),
                onTap: _clear,
              ),
            ),
            Uploader(
                file: uploadedImage,
                student: widget.student,
                qNum: widget.questionNum,
                controller: widget.imgLocController,
              )
          ]
          else if (_selectFromCamera) ... [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Card(
                child: Center(
                child: _camera,
                ),
              ),
            ),
            Card(
              child: ListTile(
              title: Center(child: Icon(Icons.camera, color: Colors.black)),
              onTap: () => _startImageCapture(),
              ),
            ),
          ]
          else 
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: Text("Choose to take a photo or a photo from file from the bottom pane",
                  style: TextStyle(fontSize: 24)
                ),
              ),
            )          
        ],
      ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _cameraReStart(),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _startFilePicker(),
            )
          ]
        ),
      ),
    ),
    );
  }
}

class Uploader extends StatefulWidget {
  final Uint8List file;
  final Student student;
  final String qNum;
  final TextEditingController controller;
  bool uploaded = false;
  Uploader({this.file, this.student, this.qNum, this.controller});
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {

  uploadImageFile(Uint8List image, String imageName) async {
    fb.StorageReference storageRef = fb.storage().ref(imageName);
    fb.UploadTaskSnapshot uploadTaskSnasphot = await storageRef.put(image).future;

    return await uploadTaskSnasphot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    String imageName = '${widget.student.teacherID}/${widget.student.className}/${widget.student.projectCode}/${widget.qNum}/${widget.student.studentID}.png';
    if (widget.uploaded == false) {
      return Card(
        child: ListTile(
        title: Text('Save to Project'),
        subtitle: Text('The image must be saved here prior to returning to answer more questions'),
        trailing: Icon(Icons.arrow_downward),
        onTap: () => setState(() => widget.uploaded = true)
        )
      );
    } else { 
      return new FutureBuilder(
        future: uploadImageFile(widget.file, imageName),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            widget.controller.text = imageName;  
            return Card(
              child: ListTile(
              title: Text('Success!',
                style: TextStyle(
                  fontSize: 24,
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