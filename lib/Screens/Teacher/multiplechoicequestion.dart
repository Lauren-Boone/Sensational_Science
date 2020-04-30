
import 'package:flutter/material.dart';
import '../../Services/getproject.dart';

class MultQuestionWidget extends StatefulWidget {
  final Questions question;
  MultQuestionWidget({this.question});
  @override
  _MultQuestionWidgetState createState() => _MultQuestionWidgetState();
}

class _MultQuestionWidgetState extends State<MultQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('I am multiple choice'),
    );
  }
}