import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensational_science/Services/getproject.dart';
import 'package:sensational_science/Services/firebaseStorage/fireStorageService.dart';
import 'package:sensational_science/Shared/styles.dart';

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
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Preview Project'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
          //backgroundColor: Colors.deepPurple,
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

  _getImage(BuildContext context, String imageLoc) async {
      if (imageLoc.length > 0) {
        Image image;
        await FireStorageService.loadImage(context, imageLoc).then((downloadURL) {
          image = Image.network(
            downloadURL.toString(),
            fit: BoxFit.scaleDown,
          );
        });
        return image;
      } else {
        return null;
      }
  }

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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 3,
                offset: Offset(0, 3))
          ],
          // border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(20,10,0,0), child: new Text("#" + (widget.numq + 1).toString(),
                style: TextStyle(fontSize: 15)),),
            Padding(padding: EdgeInsets.fromLTRB(20,5,0,0), child: new Text("Multiple Choice Question"),),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
              child: new Text(widget.question,
                  style: TextStyle(fontSize: 18, color: Colors.red)),
            ),),
            new ListView.builder(
                shrinkWrap: true,
                itemCount: widget.answers.length,
                itemBuilder: (_, index) => widget.answerWidget[index]),
            Center(
              child: new Text("Answer Key: Index " + widget.keyAnswers,
                  style: TextStyle(color: Colors.green, fontSize: 20)),
            ),
          ],
        ),
      );
    } else if (widget.type == "AddImageInput"){
        return Container(
          margin: new EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3))
              ]
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(20,5,0,0), child: new Text("#" + (widget.numq + 1).toString(),
                  style: TextStyle(fontSize: 16)),),
              Padding(padding: EdgeInsets.fromLTRB(20,5,0,0), child: new Text("Image Upload Question"),),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
              child: new Text(widget.question,
                  style: TextStyle(fontSize: 18, color: Colors.red)),
            ),),
              Center(
                child: new Text("Answer Key:",
                    style: TextStyle(color: Colors.green, fontSize: 20)),
              ),
              !widget.hasKey?
              Center(
                child: new Text( widget.keyAnswers, style: TextStyle(color: Colors.green, fontSize:20)),
              )
              : Center(
                child: new FutureBuilder(
                  future: _getImage(context, widget.keyAnswers),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) return CupertinoActivityIndicator();
                    if(snapshot.data == null) return Text("No answer image stored", style: TextStyle(color: Colors.green));
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: snapshot.data,
                      );
                  },
                ),
              )

            ],
          ),
        );
      } else {
      return Container(
        
        margin: new EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3))
            ]

            // border: Border.all(
            // color: Colors.black,
            // )
            ),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(20, 5, 0, 0), child: new Text("#" + (widget.numq+1).toString(),
                style: TextStyle(fontSize: 16)),),
            Padding(padding: EdgeInsets.fromLTRB(20,5,0,0), 
              child: widget.type == "TextInputItem"? new Text("Text Input Question")
              : widget.type == "ShortAnswerItem"? new Text("Short Answer Question")
              : widget.type == "UserLocation" ? new Text("Location Question")
              : new Text("Numerical Input Question"),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
              child: new Text(widget.question,
                  style: TextStyle(fontSize: 18, color: Colors.red)),
            ),),
            Center(
              child: new Text("Answer Key: " + widget.keyAnswers,
                  style: TextStyle(color: Colors.green, fontSize: 20)),
            ),
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
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.zero),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3))
          ],
          // border: Border.all(color: Colors.black),
        ),
        width: MediaQuery.of(context).size.width / 2,
        child: SizedBox(
          width: 50,
          child: new Text(
              "Answer " + this.numAnswer.toString() + ": " + this.answer,
              style: TextStyle(fontSize: 14, color: Colors.black)),
        ));
  }
}
