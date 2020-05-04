import 'package:flutter/material.dart';






class ExpansionTileSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ExpansionTile'),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              EntryItem(data[index]),
          itemCount: data.length,
        ),
      ),
    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry(
    'Question',
    <Entry>[
      Entry(
        'Question',
        <Entry>[
          Entry('Item A0.1'),
          Entry('Item A0.2'),
          Entry('Item A0.3'),
        ],
      ),
      Entry('Section A1'),
      Entry('Section A2'),
    ],
  ),
  
  
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
/*
class AddQuestionsToProject extends StatefulWidget {

  @override
  _AddQuestionsToProjectState createState() => _AddQuestionsToProjectState();
}

class _AddQuestionsToProjectState extends State<AddQuestionsToProject> {
  
  //List<DynamicWidget> addQuestiontoAccordion = new List();

addQuestion(){
  //addQuestiontoAccordion.add(new DynamicWidget());
   
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ExpansionTile'),
        ),
        body: Column(
          children: <Widget>[
            ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  QuestionItem(data[index]),
              itemCount: data.length,
            ),
            new RaisedButton(
              child: new Text('Add a Question'),
              onPressed: addQuestion,
            ),
          ],
        ),
      ),
    );
  }
}

class Question{
 

  Question(this.number, this.question, this.type);
  final int number;
  final String question;
  final String type;
  
}

// The entire multilevel list displayed by this app.
List<Question> data = <Question>[
  Question(
    
    4,
    'asdf',
    'Chapter A',
   
  ),
];

// Displays one Question. If the Question has children then it's displayed
// with an ExpansionTile.
class QuestionItem extends StatelessWidget {
  const QuestionItem(this.entry);

  final Question entry;

  Widget _buildTiles(Question root) {
    //if (root.children.isEmpty) return ListTile(title: Text("Question " + entry.number.toString()));
    return ExpansionTile(
      key: PageStorageKey<Question>(root),
      title: Text(root.question),
     // children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

*/

/*
class DynamicWidget extends StatelessWidget{
  final controller = new TextEditingController();
  @override
  Widget build(BuildContext context){
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Question>(root),
      title: Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
}
}*/