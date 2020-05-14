import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

class WebImageCapture extends StatefulWidget {
  @override
  _WebImageCaptureState createState() => _WebImageCaptureState();
}

class _WebImageCaptureState extends State<WebImageCapture> {
  Widget _camera;
  html.VideoElement _cameraVideo = new html.VideoElement();
  String key = UniqueKey().toString();

  @override
  void initState() {
    super.initState();

    _cameraVideo = new html.VideoElement();
    //platformViewRegistry shows an error but should still work
    ui.platformViewRegistry.registerViewFactory('cameraVideo', (int viewId) => _cameraVideo);
    _camera = HtmlElementView(key: UniqueKey(), viewType: 'cameraVideo');
    html.window.navigator.getUserMedia(video: true).then((html.MediaStream stream) {
      _cameraVideo.srcObject = stream;
    });

    _cameraVideo.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _camera,
      ),
      bottomNavigationBar: BottomAppBar(
        child: IconButton(
          icon: Icon(Icons.camera),
          onPressed: () async {
            html.MediaStream cameraFeed = _cameraVideo.captureStream();
            html.MediaStreamTrack track = cameraFeed.getVideoTracks().first;
            html.ImageCapture image = new html.ImageCapture(track);
            html.Blob imageBlob =await image.takePhoto();

            Navigator.pop(context, imageBlob);
          }
        )
      ),
    );
  }
}
