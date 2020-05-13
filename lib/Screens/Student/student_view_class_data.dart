import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sensational_science/Screens/Student/locationtest.dart';
import '../../Services/getproject.dart';
import 'package:random_color/random_color.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sensational_science/Services/firebaseStorage/fireStorageService.dart';

var createLocationMap = LocationMap();

class ViewClassData extends StatefulWidget {
  final String user;
  final String className;
  final String classProjDocID;
  final GetProject proj;
  ViewClassData({this.user, this.className, this.classProjDocID, this.proj});
  //final String docID;
  @override
  _ViewClassDataState createState() =>
      _ViewClassDataState(this.proj, this.className, this.classProjDocID);
}

class _ViewClassDataState extends State<ViewClassData> {
  CompiledProject data;
  String className;
  String classDocProjID;
  List<dynamic> questionData = [];
  GetProject proj;
  _ViewClassDataState(
      GetProject proj, String classname, String classDocProjID) {
    this.proj = proj;

    data = new CompiledProject(proj: proj);
    this.className = classname;
    this.classDocProjID = classDocProjID;
  }
  @override
  void initState() {
    super.initState();
    data
        .getStudentsAnswers(this.className, this.classDocProjID)
        .whenComplete(() => print("Got answers!"));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Data"),
      ),
      body: Container(
        child: Column(children: <Widget>[
          RaisedButton(
              child: Text('Click to view compiled data for each question'),
              onPressed: () {
                //print(data.proj.questions[0].compAnswers[0]);
                //CompiledProject data = new CompiledProject(proj: proj);
                //data.getStudentsAnswers(widget.className, widget.classProjDocID);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CompileData(proj: proj, compData: data),
                  ),
                );
              })
        ]),
      ),
    );
  }
}

class CompileData extends StatefulWidget {
  final GetProject proj;
  final CompiledProject compData;
  CompileData({this.proj, this.compData});
  @override
  _CompileDataState createState() =>
      _CompileDataState(this.proj, this.compData);
}

class _CompileDataState extends State<CompileData> {
  int _currentQuestion = 0;
  GetProject proj;
  CompiledProject compData;

  List<GraphVals> numerical = [];
  List<charts.Series<GraphVals, String>> graphSeries;
  //List<List<charts.Series<GraphVals,String>>> allGraphs;

  int _currentGraph = 0;

  _CompileDataState(GetProject proj, CompiledProject compData) {
    this.proj = proj;
    this.compData = compData;
  }
  @override
  void initState() {
    super.initState();
    // graphSeries= List<charts.Series<GraphVals, String>>();
    // _generateChartData();

    _currentGraph = 0;
  }

  _getImages(BuildContext context, List<dynamic> imageLocs) async {
    print("I am in getImages");
    List<Widget> images = [];
    for (var imgLoc in imageLocs) {
      print("I'm processing a photo");
      Image nextImage;
      await FireStorageService.loadImage(context, imgLoc).then((downloadURL) {
        nextImage = Image.network(
          downloadURL.toString(),
          fit: BoxFit.scaleDown,
        );
      });
      print("I got the image");
      images.add(new Container(
        height: MediaQuery.of(context).size.height / 1.25,
        width: MediaQuery.of(context).size.width / 1.25,
        child: nextImage,
      ));
      print("I added the image to the list");
    }
    if (images.length < 1) {
      print("I have no images, so I am adding a text widget");
      images.add(Text("No photos have been submitted for this project"));
    }
    print("I'm returning the list of images");
    return images;
  }

  _getGraph(List<charts.Series<GraphVals, String>> multGraph) {
    Map<String, Color> colorKey = new Map();
    List<GraphVals> graphData = [];
    Map<String, int> elementCount = new Map();
    proj.questions[_currentQuestion].compAnswers.forEach((element) {
      if (elementCount.containsKey(element)) {
        elementCount[element] += 1;
      } else {
        elementCount[element] = 1;
      }
    });
    proj.questions[_currentQuestion].compAnswers.forEach((element) {
      String title = "";
      if (proj.questions[_currentQuestion].type == 'MultipleChoice') {
        title = proj.questions[_currentQuestion].answers[int.parse(element)];
      } else {
        title = element.toString();
      }

      RandomColor _randColor = RandomColor();

      while (colorKey.containsValue(_randColor.randomColor())) {
        _randColor = RandomColor();
      }
      colorKey[element] = _randColor.randomColor();
      graphData.add(new GraphVals(
          title, elementCount[element], _randColor.randomColor()));
      // }
    });

    multGraph.add(
      charts.Series(
        data: graphData,
        domainFn: (GraphVals vals, _) => vals.title,
        measureFn: (GraphVals vals, _) => vals.value,
        colorFn: (GraphVals vals, _) =>
            charts.ColorUtil.fromDartColor(vals.colorval),
        id: 'Class Data',
        labelAccessorFn: (GraphVals vals, _) => '${vals.value}',
      ),
    );
  }

  Widget getNextButton(BuildContext context) {
    return RaisedButton(
        child: Text("NEXT"),
        color: Colors.red,
        onPressed: () {
          if (_currentQuestion < widget.proj.questions.length) {
            setState(() {
              //controllers.add(value);
              _currentQuestion++;
            });
          } else {}
        });
  }

  Widget getPrevButton(BuildContext context) {
    return RaisedButton(
        child: Text("Prev"),
        color: Colors.red,
        onPressed: () {
          if (_currentQuestion < widget.proj.questions.length) {
            setState(() {
              //controllers.add(value);
              _currentQuestion--;
            });
          } else {}
        });
  }

  Widget build(BuildContext context) {
    while (proj.questions[_currentQuestion].compAnswers.length == 0) {
      setState(() {});
    }
    if (_currentQuestion >= widget.proj.questions.length) {
      return Container(
        child: Text("End Page"),
      );
    }
    switch (widget.proj.questions[_currentQuestion].type.toString()) {
      case 'TextInputItem':
        return Material(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                new Text('Text Input', style: TextStyle(color: Colors.black)),
                Expanded(
                  child: new ListView.builder(
                    itemCount: widget
                        .proj.questions[_currentQuestion].compAnswers.length,
                    itemBuilder: (context, index) {
                      print(widget
                          .proj.questions[_currentQuestion].compAnswers[index]);
                      return ListTile(
                        title: Text(
                            '${widget.proj.questions[_currentQuestion].compAnswers[index]}',
                            style: TextStyle(color: Colors.black)),
                      );
                    },
                  ),
                ),
                getNextButton(context),
                getPrevButton(context),
              ],
            ),
          ),
        );

        break;
      case 'MultipleChoice':
        List<charts.Series<GraphVals, String>> multGraph = [];
        _getGraph(multGraph);
        return Material(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Center(
                  child: new Card(
                    child: Text('Mult Choice',
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                new Card(
                    child: new Text(
                        widget.proj.questions[_currentQuestion].question)),
                new Expanded(
                  child: charts.PieChart(
                    multGraph,
                    animate: true,
                    animationDuration: Duration(seconds: 2),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 2,
                        cellPadding:
                            new EdgeInsets.only(right: 4.0, bottom: 4.0),
                        entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 11,
                        ),
                      ),
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 100,
                      arcRendererDecorators: [
                        new charts.ArcLabelDecorator(
                          labelPosition: charts.ArcLabelPosition.inside,
                        ),
                      ],
                    ),
                  ),
                ),
                getNextButton(context),
                getPrevButton(context),
              ],
            ),
          ),
        );

        break;
      case 'ShortAnswerItem':
        return Material(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                new Text('Short answer Input',
                    style: TextStyle(color: Colors.black)),
                Expanded(
                  child: new ListView.builder(
                    itemCount: widget
                        .proj.questions[_currentQuestion].compAnswers.length,
                    itemBuilder: (context, index) {
                      print(widget
                          .proj.questions[_currentQuestion].compAnswers[index]);
                      return ListTile(
                        title: Text(
                            '${widget.proj.questions[_currentQuestion].compAnswers[index]}',
                            style: TextStyle(color: Colors.black)),
                      );
                    },
                  ),
                ),
                getNextButton(context),
                getPrevButton(context),
              ],
            ),
          ),
        );

        break;
      case 'UserLocation':
        return Material(
          child: new Container(
            child: Column(
              children: <Widget>[
                Expanded(child: Text('Location')),
                Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 3,
                    child: createLocationMap),
                getNextButton(context),
                getPrevButton(context),
              ],
            ),
          ),
        );
        break;
      case 'NumericalInputItem':
        List<charts.Series<GraphVals, String>> multGraph = [];
        _getGraph(multGraph);
        return Material(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Center(
                  child: new Card(
                    child: Text('Numerical Graph',
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
                new Card(
                    child: new Text(
                        widget.proj.questions[_currentQuestion].question)),
                new Expanded(
                  child: charts.PieChart(
                    multGraph,
                    animate: true,
                    animationDuration: Duration(seconds: 2),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 2,
                        cellPadding:
                            new EdgeInsets.only(right: 4.0, bottom: 4.0),
                        entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 11,
                        ),
                      ),
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 100,
                      arcRendererDecorators: [
                        new charts.ArcLabelDecorator(
                          labelPosition: charts.ArcLabelPosition.inside,
                        ),
                      ],
                    ),
                  ),
                ),
                getNextButton(context),
                getPrevButton(context),
              ],
            ),
          ),
        );

        break;
      case 'AddImageInput':
        return new Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Center(
                child: new Card(
                  child: Text('Text Input Answers',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              new Card(
                  child: new Text(
                      widget.proj.questions[_currentQuestion].question)),
              Expanded(
                child: FutureBuilder(
                    future: _getImages(context,
                        widget.proj.questions[_currentQuestion].compAnswers),
                    builder: (context, snapshot) {
                      print("I started the builder");
                      if (snapshot.hasData) {
                        print("Data is here, returning the listview");
                        return ListView(
                          children: snapshot.data,
                        );
                      }
                      if (!snapshot.hasData) {
                        print(
                            "snapshot does not have data, rmaking circular progress indicators");
                        List<Widget> waitList = [];
                        for (var i = 0;
                            i <
                                widget.proj.questions[_currentQuestion]
                                    .compAnswers.length;
                            i++) {
                          waitList.add(Container(
                            height: MediaQuery.of(context).size.height / 10,
                            width: MediaQuery.of(context).size.width / 10,
                            child: CircularProgressIndicator(),
                          ));
                        }
                        if (waitList.length < 1) {
                          print(
                              "There are no images, adding one for list length");
                          waitList.add(Container(
                            height: MediaQuery.of(context).size.height / 10,
                            width: MediaQuery.of(context).size.width / 10,
                            child: CircularProgressIndicator(),
                          ));
                        }
                        print("returning circular progress indicators");
                        return ListView(
                          children: waitList,
                        );
                      }
                    }),
              ),
              getNextButton(context),
              getPrevButton(context),
            ],
          ),
        );
        break;
      default:
        return new Container();
    }
  }
}

class GraphVals {
  int value;
  String title;
  Color colorval;

  GraphVals(this.title, this.value, this.colorval);
}
