import 'package:flutter/material.dart';
import '../../Services/getproject.dart';

class ShortAnswerQuestion extends StatefulWidget {
  final Questions question;
  final TextEditingController shortAnswerController; 
  ShortAnswerQuestion({this.question, this.shortAnswerController});
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
      controller: widget.shortAnswerController,
      decoration: new InputDecoration(
        labelText: "Short Answer",
        fillColor: Colors.white,
      
      ),
    )
    );
  }
}