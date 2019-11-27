import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import  'survey_record.dart';

String uid = " ";
DateTime fromDate = DateTime.now().subtract(Duration(days:14));
DateTime toDate = DateTime.now();

List<int> score = [];
List <int> breakfast = [], lunch = [], dinner = [];
List<int> stress = [];
List <int> poopState = [], poopFeeling=  [], poopCount=[];

Future<String> _makeUserID(BuildContext context) async{
  FirebaseUser userId = await FirebaseAuth.instance.currentUser();
  uid = userId.uid;
  return uid;
}




class ReportScreen extends StatefulWidget{
  static const routeName = '/reportScreen';
  @override
  ReportScreenState createState() => ReportScreenState();
}


class ReportScreenState extends State<ReportScreen> {
  // TODO: Add a variable for Category (104)
  @override
  Widget build(BuildContext context) {
    return PageView(
        children: <Widget>[
          ReportScreen1(),
          ReportScreen2(),
        ],
        scrollDirection: Axis.horizontal,
      );
  }
}


class ReportScreen1 extends StatefulWidget{
  @override
  ReportScreen1State createState() => ReportScreen1State();
}


class ReportScreen1State extends State<ReportScreen1> {
  // TODO: Add a variable for Category (104)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Final Report"),
      ),
      body:  Center(
        child: Container(
          color: Colors.red,
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width * 0.9,
          child: sample2(context),
        ),
      ),
    );
  }
}


Widget sample2(BuildContext context){
  return BezierChart(
    fromDate: fromDate,
    bezierChartScale: BezierChartScale.WEEKLY,
    toDate: toDate,
    selectedDate: toDate,
    series: [
      BezierLine(
        label: "Duty",
        onMissingValue: (dateTime) {
          if (dateTime.day.isEven) {
            return 10.0;
          }
          return 5.0;
        },
        data: [
          DataPoint<DateTime>(value: 45.5, xAxis: DateTime(2019, 11, 24)),
          DataPoint<DateTime>(value: 48.5, xAxis: DateTime(2019, 11, 23)),
          DataPoint<DateTime>(value: 44.5, xAxis: DateTime(2019, 11, 22)),
          DataPoint<DateTime>(value: 40, xAxis: DateTime(2019, 11, 19)),
          DataPoint<DateTime>(value: 43.5, xAxis: DateTime(2019, 11, 18)),
        ],
      ),
    ],
    config: BezierChartConfig(
      verticalIndicatorStrokeWidth: 3.0,
      verticalIndicatorColor: Colors.black26,
      showVerticalIndicator: true,
      verticalIndicatorFixedPosition: false,
      backgroundColor: Colors.red,
      footerHeight: 50.0,
    ),
  );
}


class ReportScreen2 extends StatefulWidget{
  @override
  ReportScreen2State createState() => ReportScreen2State();
}

class ReportScreen2State extends State<ReportScreen2> {
  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];
  final fromDate = DateTime(2019, 05, 1);
  final toDate =  DateTime(2019, 05, 15);
  final date1 =DateTime(2019, 05, 15).subtract(Duration(days: 2));
  final date2 = DateTime(2019, 05, 15).subtract(Duration(days: 3));

  @override
  Widget build(BuildContext context) {
    return tabController();
  }

  Widget tabController(){
    return  DefaultTabController(
      length: choices.length,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          title : Center(
            child: TabBar(
              isScrollable: true,
              tabs: choices.map((Choice choice) {
                return Tab(
                  text: choice.title,
                  //    icon: Icon(choice.icon),
                );
              }).toList(),
            ),
          ),
        ),
        body: TabBarView(
          children: choices.map((Choice choice) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ChoiceCard(choice: choice),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget Defecationhabit(){
    return Center(
      child: Container(
        width: 300.0,
        height: 100.0,
        child:  Sparkline(
          data: data,
          lineColor: Colors.black,
          pointsMode: PointsMode.all,
          pointSize: 4.0,
          pointColor: Colors.white,
        ),
      ),
    );
  }


}

class Choice {
  const Choice({this.title, this.icon, this.widget});

  final String title;
  final IconData icon;
  final Widget widget;
}

List<Choice> choices =  <Choice>[
  Choice(title: 'life', icon: Icons.restaurant, widget: Lifestyle()),
  Choice(title: 'Defecation', icon: Icons.restaurant, widget: Defecationhabit()),
  Choice(title: 'stress', icon: Icons.person, widget:Defecationhabit()),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            choice.widget
            //  Icon(choice.icon, size: 128.0, color: textStyle.color),
            // Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}

class Lifestyle extends StatefulWidget{
  @override
  LifestyleState createState() => LifestyleState();
}

class LifestyleState extends State<Lifestyle> {
  Map<String, double> habit = {'eating': 36, 'not eating':10 };
  Map<String, double> dailyFood = {'탄수화물': 36, '지방':10, '채소':14 };

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Container(
        child : Column(
          children:[
            PieChart(
              dataMap: habit,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32.0,
              chartRadius: MediaQuery.of(context).size.width / 2.7,
              showChartValuesInPercentage: true,
              showChartValues: true,
              showChartValuesOutside: false,
              chartValueBackgroundColor: Colors.grey[200],
              //  colorList: colorList,
              showLegends: true,
              legendPosition: LegendPosition.right,
              decimalPlaces: 1,
              showChartValueLabel: true,
              initialAngle: 0,
              chartValueStyle: defaultChartValueStyle.copyWith(
                color: Colors.blueGrey[900].withOpacity(0.9),
              ),
              chartType: ChartType.disc,
            ),

            PieChart(
              dataMap: dailyFood,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32.0,
              chartRadius: MediaQuery.of(context).size.width / 2.7,
              showChartValuesInPercentage: true,
              showChartValues: true,
              showChartValuesOutside: false,
              chartValueBackgroundColor: Colors.grey[200],
              //  colorList: colorList,
              showLegends: true,
              legendPosition: LegendPosition.right,
              decimalPlaces: 1,
              showChartValueLabel: true,
              initialAngle: 0,
              chartValueStyle: defaultChartValueStyle.copyWith(
                color: Colors.blueGrey[900].withOpacity(0.9),
              ),
              chartType: ChartType.disc,
            ),

          ],
        ),
      ),
    );
  }
}

class Defecationhabit extends StatefulWidget{
  @override
  DefecationhabitState createState() => DefecationhabitState();
}

class DefecationhabitState extends State<Defecationhabit> {
  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];
  final fromDate = DateTime(2019, 05, 1);
  final toDate =  DateTime(2019, 05, 15);

  final date1 =DateTime(2019, 05, 15).subtract(Duration(days: 2));
  final date2 = DateTime(2019, 05, 15).subtract(Duration(days: 3));

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        child: BezierChart(
          fromDate: fromDate,
          bezierChartScale: BezierChartScale.WEEKLY,
          toDate: toDate,
          selectedDate: toDate,
          series: [
            BezierLine(
              label: "Duty",
              onMissingValue: (dateTime) {
                if (dateTime.day.isEven) {
                  return 10.0;
                }
                return 5.0;
              },
              data: [
                DataPoint<DateTime>(value: 10, xAxis: date1),
                DataPoint<DateTime>(value: 50, xAxis: date2),
              ],
            ),
          ],
          config: BezierChartConfig(
            verticalIndicatorStrokeWidth: 3.0,
            verticalIndicatorColor: Colors.black26,
            showVerticalIndicator: true,
            verticalIndicatorFixedPosition: false,
            backgroundColor: Colors.red,
            footerHeight: 50.0,
          ),
        ),
      ),
    );
  }
}