import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensational_science/Screens/Student/locationtest.dart';
import '../../Services/getproject.dart';
import 'package:random_color/random_color.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sensational_science/Services/firebaseStorage/fireStorageService.dart';
import 'locationtest.dart';

var createLocationMap = LocationMap();

class locationInfo {
  // double latitude = 0.0;
  // double longitude = 0.0;
  String latlonInfo;

  locationInfo({this.latlonInfo});
}

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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Container(
        margin: EdgeInsets.all(40),
        child: Center(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
            ),
            Text("All of the students' answers have been compiled. ",
                style: TextStyle(color: Colors.black, fontSize: 20)),
            Padding(
              padding: EdgeInsets.all(20),
            ),
            RaisedButton(
                child: Text('Click to view compiled data for each question'),
                onPressed: () {
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
    List<Widget> images = [];
    for (var imgLoc in imageLocs) {
      if (imgLoc.toString().length > 0) {
        Image nextImage;
        await FireStorageService.loadImage(context, imgLoc).then((downloadURL) {
          nextImage = Image.network(
            downloadURL.toString(),
            fit: BoxFit.scaleDown,
          );
        });
        images.add(new Container(
          height: MediaQuery.of(context).size.height / 1.25,
          width: MediaQuery.of(context).size.width / 1.25,
          child: nextImage,
        ));
      }
    }
    if (images.length < 1) {
      images.add(Text("No photos have been submitted for this project"));
    }
    return images;
  }

  _getGraph(List<charts.Series<GraphVals, String>> multGraph) {
    Map<String, Color> colorKey = new Map();
    List<GraphVals> graphData = [];
    Map<String, int> elementCount = new Map();
    proj.questions[_currentQuestion].compAnswers.forEach((element) {
      String title = "";
      if (proj.questions[_currentQuestion].type == 'MultipleChoice') {
        title = proj.questions[_currentQuestion].answers[int.parse(element)];
      } else {
        title = element.toString();
      }

      if (elementCount.containsKey(title)) {
        elementCount[title] += 1;
      } else {
        elementCount[title] = 1;
      }
    });
    elementCount.forEach((key, value) {
      RandomColor _randColor = RandomColor();

      while (colorKey.containsValue(_randColor.randomColor())) {
        _randColor = RandomColor();
      }
      colorKey['$key'] = _randColor.randomColor();
      graphData
          .add(new GraphVals(key.toString(), value, _randColor.randomColor()));
    });
    /*
   proj.questions[_currentQuestion].compAnswers.forEach((element) {
       String title="";
       if(proj.questions[_currentQuestion].type=='MultipleChoice'){
             title=proj.questions[_currentQuestion].answers[int.parse(element)];
           }
           else{
             title = element.toString();
           }
         
              RandomColor _randColor = RandomColor();
              
              while (colorKey.containsValue(_randColor.randomColor())){
                _randColor=RandomColor();
              }
              colorKey[element]=_randColor.randomColor();
           graphData.add(new GraphVals(title, elementCount[element], _randColor.randomColor() ));
           // }
    });*/

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
          if (_currentQuestion < widget.proj.questions.length &&
              _currentQuestion != 0) {
            setState(() {
              //controllers.add(value);
              _currentQuestion--;
            });
          } else if (_currentQuestion == 0) {
            Navigator.pop(context);
          }
        });
  }

  Widget build(BuildContext context) {
    if (_currentQuestion >= widget.proj.questions.length) {
      return Material(
        child: Container(
            margin: EdgeInsets.all(30),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Text('End of Compiled Answers'),
                RaisedButton(
                  child: Text('Click to Go back'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            )),
      );
    }
    while (proj.questions[_currentQuestion].compAnswers.length == 0) {
      setState(() {});
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
                            'Location Map',
                            style: TextStyle(color: Colors.black)),
                      );
                    },
                  ),
                ),
                getPrevButton(context),
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
                getPrevButton(context),
                getNextButton(context),
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
                getPrevButton(context),
                getNextButton(context),
              ],
            ),
          ),
        );

        break;
      case 'UserLocation':
        // print('${widget.proj.questions[_currentQuestion].compAnswers[0]}');
        var locationInfoMap =
            widget.proj.questions[_currentQuestion].compAnswers[0];
        final lms = locationInfo(
            latlonInfo:
                '${widget.proj.questions[_currentQuestion].compAnswers[0]}');
        return Material(
          child: new Container(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Text(
                        '')),
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width / 3,
                  child: new LocationMap(lms: lms),
                  // child: RaisedButton(
                  //   child: Text('Click to load map'),

                  //   onPressed: () {
                  //     // var locationInfoMap = createLocationMap;
                  //     var locationInfoMap = widget
                  //         .proj.questions[_currentQuestion].compAnswers[0];
                  //         final lms = locationInfo(latlonInfo: '${widget.proj.questions[_currentQuestion].compAnswers[0]}');
                  //     // locationInfoMap.longitude = widget
                  //     //     .proj.questions[_currentQuestion].compAnswers[0][1];
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => LocationMap(
                  //                 lms: lms,
                  //               )),
                  //     );
                  //   },
                  // ),
                ),
                getPrevButton(context),
                getNextButton(context),
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
                  child: charts.OrdinalComboChart(
                    multGraph,
                    animate: true,
                    animationDuration: Duration(seconds: 2),
                    // barRendererDecorator: new charts.BarLabelDecorator<String>(),
                    domainAxis: new charts.OrdinalAxisSpec(),
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

                    defaultRenderer: new charts.BarRendererConfig(
                      groupingType: charts.BarGroupingType.groupedStacked,
                    ),
                  ),
                ),
                getPrevButton(context),
                getNextButton(context),
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
                  child: Text('Images',
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
                      if (snapshot.hasData) {
                        return ListView(
                          children: snapshot.data,
                        );
                      }
                      if (!snapshot.hasData) {
                        List<Widget> waitList = [];
                        for (var i = 0;
                            i <
                                widget.proj.questions[_currentQuestion]
                                    .compAnswers.length;
                            i++) {
                          waitList.add(Container(
                            height: MediaQuery.of(context).size.height / 10,
                            width: MediaQuery.of(context).size.width / 10,
                            child: CupertinoActivityIndicator(),
                          ));
                        }
                        if (waitList.length < 1) {
                          waitList.add(Container(
                            height: MediaQuery.of(context).size.height / 10,
                            width: MediaQuery.of(context).size.width / 10,
                            child: CupertinoActivityIndicator(),
                          ));
                        }
                        return ListView(
                          children: waitList,
                        );
                      }
                    }),
              ),
              getNextButton(context),

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
