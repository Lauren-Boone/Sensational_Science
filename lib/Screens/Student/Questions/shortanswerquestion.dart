import 'package:flutter/material.dart';
import '../../../Services/getproject.dart';
import 'QuestionWidget.dart';

class ShortAnswerQuestion extends StatefulQuestionWidget {
  TextEditingController shortAnswerController; 
  ShortAnswerQuestion() {
    this.shortAnswerController = new TextEditingController();
  }

  @override
  _ShortAnswerQuestionState createState() => _ShortAnswerQuestionState();

  @override
  getAnswer() {
    // TODO: implement getAnswer
    print(shortAnswerController.text);
    return shortAnswerController.text; 
  }
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