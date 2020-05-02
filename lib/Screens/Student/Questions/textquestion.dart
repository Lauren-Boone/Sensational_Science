import 'package:flutter/material.dart';
import '../../../Services/getproject.dart';
import 'QuestionWidget.dart';

class TextQuestionWidget extends StatefulQuestionWidget {
  final Questions question;
  final TextEditingController textAnswerController = new TextEditingController();
  TextQuestionWidget({this.question});

  @override
  _TextQuestionWidgetState createState() => _TextQuestionWidgetState();

  @override
  getAnswer() {
    // TODO: implement getAnswer
    return textAnswerController.text; 
  }
}

class _TextQuestionWidgetState extends State<TextQuestionWidget> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: new TextFormField(
          controller: widget.textAnswerController,
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
        ));
  }
}
