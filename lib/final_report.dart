import 'package:flutter/material.dart';
import 'package:fcharts/fcharts.dart';

class ReportScreen extends StatefulWidget{
  static const routeName = '/reportScreen';
  @override
  ReportScreenState createState() => ReportScreenState();
}

class ReportScreenState extends State<ReportScreen> {
  // TODO: Add a variable for Category (104)
  int maxId = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title:
      ),
      body: Center(
        child: SimpleLineChart(),
      ),
    );
  }
}


class SimpleLineChart extends StatelessWidget {
  // X value -> Y value
  static const myData = [
    ["1일차", "1", "2"],
    ["2일차", "3", "3"],
    ["3일차", "5", "1"],
    ["4일차", "4", "4"],
    ["5일차", "3", "1"],
    ["6일차", "2", "5"],
    ["7일차", "1", "6"],
  ];

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: 4 / 3,
      child: new LineChart(
        lines: [
          new Line<List<String>, String, String>(
            data: myData,
            xFn: (datum) => datum[0],
            yFn: (datum) => datum[1],
          ),
        ],
        chartPadding: new EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 30.0),
      ),
    );
  }
}