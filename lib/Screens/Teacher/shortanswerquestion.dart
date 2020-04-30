import 'package:flutter/material.dart';
import '../../Services/getproject.dart';

class ShortAnswerQuestion extends StatefulWidget {
  final Questions question;
  ShortAnswerQuestion({this.question});
  @override
  _ShortAnswerQuestionState createState() => _ShortAnswerQuestionState();
}

class _ShortAnswerQuestionState extends State<ShortAnswerQuestion> {

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, 
        child: new TextFormField(
      // controller: widget.controller,
      decoration: new InputDecoration(
        labelText: "Short Answer",
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