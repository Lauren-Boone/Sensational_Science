import 'package:flutter/material.dart';
import 'package:sensational_science/Services/getproject.dart';

class PreviewProject extends StatefulWidget {
  final String title;
  final GetProject proj;
  final List<dynamic> answers;
  final bool hasKey;
  PreviewProject({this.proj, this.title, this.answers, this.hasKey});
  @override
  _PreviewProjectState createState() =>
      _PreviewProjectState(this.proj, this.answers, this.hasKey);
}

class _PreviewProjectState extends State<PreviewProject> {
  GetProject proj;
  List<DynamicWidget> questions = new List();
  List<dynamic> answers;
  bool hasKey;
  _PreviewProjectState(GetProject proj, List<dynamic> answers, bool hasKey) {
    this.proj = proj;
    this.answers = answers;
    this.hasKey = hasKey;
    int j = 0;
    String temp = "";

    proj.questions.forEach((element) {
      if (hasKey) {
        questions.add(new DynamicWidget(
            type: element.type,
            numq: element.number,
            question: element.question,
            answers: element.answers,
            keyAnswers: answers[j].toString(),
            hasKey: hasKey));
        j++;
      } else {
        questions.add(new DynamicWidget(
            type: element.type,
            numq: element.number,
            question: element.question,
            answers: element.answers,
            keyAnswers: "",
            hasKey: hasKey));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Preview Project'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: new ListView.builder(
                itemCount: widget.proj.questions.length,
                itemBuilder: (_, index) => this.questions[index]),
          ),
        ]),
      ),
    );
  }
}

class DynamicWidget extends StatefulWidget {
  final String question;
  // final answercontroller = new List<TextEditingController>();
  final answerWidget = new List<DynamicAnswers>();
  final List<String> answers;
  String keyAnswers;
  final bool hasKey;
  int numAnswers = 0;
  final String type;
  final int numq;

  DynamicWidget(
      {this.type,
      this.numq,
      this.question,
      this.answers,
      this.keyAnswers,
      this.hasKey});
  @override
  _DynamicWidgetState createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  @override
  Widget build(BuildContext context) {
    if (!widget.hasKey) {
      widget.keyAnswers = 'No answer key created yet';
    }
    if (widget.type == "MultipleChoice") {
      int ansNum = 0;
      widget.answers.forEach((element) {
        widget.answerWidget
            .add(new DynamicAnswers(answer: element, numAnswer: ansNum));
        ansNum++;
      });
      return Container(
        // constraints: BoxConstraints(minWidth: 230.0, minHeight: 25.0),
        margin: new EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            new Text("Question Number: " + widget.numq.toString(),
                style: TextStyle(fontSize: 18)),
            new Text("Type: " + widget.type),
            new Text("Question: " + widget.question,
                style: TextStyle(fontSize: 18, color: Colors.red)),
            new ListView.builder(
                shrinkWrap: true,
                itemCount: widget.answers.length,
                itemBuilder: (_, index) => widget.answerWidget[index]),
          ],
        ),
      );
    } else {
      return Container(
        margin: new EdgeInsets.all(8.0),
        decoration: BoxDecoration(border: Border.all(
          color: Colors.black,
          )),
        child: Column(
          children: <Widget>[
            new Text("Question Number: " + widget.numq.toString(),
                style: TextStyle(fontSize: 16)),
            new Text("Type: " + widget.type),
            new Text("Question: " + widget.question,
                style: TextStyle(fontSize: 20, color: Colors.red)),
            new Text("Answers: " + widget.keyAnswers,
                style: TextStyle(color: Colors.green)),
          ],
        ),
      );
    }
  }
}

class DynamicAnswers extends StatelessWidget {
  final String answer;
  final int numAnswer;
  DynamicAnswers({this.answer, this.numAnswer});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        width: MediaQuery.of(context).size.width / 2,
        child: SizedBox(
          width: 50,
          child: new Text(
              "Answer " + this.numAnswer.toString() + ": " + this.answer,
              style: TextStyle(fontSize: 14, color: Colors.green)),
        ));
  }
}
