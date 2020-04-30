import 'package:flutter/material.dart';
import '../../Services/getproject.dart';

class TextQuestionWidget extends StatefulWidget {
  final Questions question;
  TextQuestionWidget({this.question});
  @override
  _TextQuestionWidgetState createState() => _TextQuestionWidgetState();
}

class _TextQuestionWidgetState extends State<TextQuestionWidget> {
      final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, 
        child: new TextFormField(
      // controller: widget.controller,
      decoration: new InputDecoration(
        labelText: "Text Answer",
        fillColor: Colors.white,
        enabledBorder: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
    )
    );
  }
}