import 'package:flutter/material.dart';
import '../../Services/getproject.dart';

class TextQuestionWidget extends StatefulWidget {
  final Questions question;
  final TextEditingController textAnswerController;
  TextQuestionWidget({this.question, this.textAnswerController});

  @override
  _TextQuestionWidgetState createState() => _TextQuestionWidgetState();
}

class _TextQuestionWidgetState extends State<TextQuestionWidget> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: new TextFormField(
          controller: widget.textAnswerController,
          decoration: new InputDecoration(
            labelText: "Text Answer",
            fillColor: Colors.white,
            enabledBorder: new OutlineInputBorder(borderSide: BorderSide( color: Colors.black, width: 1.0)),
            focusedBorder: new OutlineInputBorder(borderSide: BorderSide( color: Colors.black, width: 1.0)),
          
          ),
        ),
        ),
    );
  }
}
