import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TextInputItem extends StatelessWidget {
  final controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(8.0),
      child: new TextField(
        controller: controller,
        decoration: new InputDecoration(
          hintText: 'Text Input Prompt',
        ),
      ),
    );
  }
}

class CreateProject extends StatefulWidget {
  @override

  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {

  @override
  Widget build(BuildContext context) {
    //final List<Widget> acceptData;

    return MaterialApp(
      home: Scaffold(
      appBar: AppBar (
        title: Text("Create New Project"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: DragTarget(
                builder: (context, List<Widget> candidateData, rejectedData) {
                  return Center(
                    child: candidateData != null
                      ? Column(
                        children: candidateData,
                      )
                      : Container(
                        color: Colors.lightBlue,
                      ),
                  );
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width/3,
              child: Draggable(
                child: new TextInputItem(),
                data: [new TextInputItem()],
                feedback: Text('Text Input Field'),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}