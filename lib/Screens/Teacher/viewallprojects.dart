import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PublicProjectsList extends StatefulWidget {
  @override
  _PublicProjectsListState createState() => _PublicProjectsListState();
}

class _PublicProjectsListState extends State<PublicProjectsList> {
  List<String> subjects = [
    "All",
    "Physics",
    "Biology",
    "Chemistry",
    "Astronomy",
    "Geography",
    "Geology"
  ];
  String filter = "All";
  bool hasfilter = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View All Public Projects"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height * 0.8,
        child: Column(children: [
          new Text('Projects', style: TextStyle(fontSize: 20)),
          new DropdownButton(
            items: subjects.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String newValue) {
              if(newValue == 'All'){
                setState(() {
                  hasfilter=false;
                });
              }
              else{
              setState(() {
                 hasfilter = true;
                filter = newValue;
              
              });
              }
               
              print(filter);
            },
          ),
          new SizedBox(),
          filterWidget(context),
        ]),
      ),
    );
  }

  Widget filterWidget(BuildContext context) {
    if (hasfilter) {
      return Expanded(
              child: Column(
          children: <Widget>[
            new StreamBuilder(
              stream: Firestore.instance
                  .collection('Projects')
                  .where('public', isEqualTo: true)
                  .where('subject', isEqualTo: filter)
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) return new Text('...Loading');
                return new Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: new ListView(
                      children: snapshot.data.documents.map<Widget>((doc) {
                        return new ListTile(
                          title: new Text(doc['title']),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    } else {
      return Expanded(
              child: Column(
          children: <Widget>[
            new StreamBuilder(
              stream: Firestore.instance
                  .collection('Projects')
                  .where('public', isEqualTo: true)
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) return new Text('...Loading');
                return new Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: new ListView(
                      children: snapshot.data.documents.map<Widget>((doc) {
                        return new ListTile(
                          title: new Text(doc['title']),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }
}
