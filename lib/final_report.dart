import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:pie_chart/pie_chart.dart'as pi2;
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fl_chart/fl_chart.dart' ;


class ReportScreen extends StatefulWidget{
  static const routeName = '/reportScreen';
  @override
  ReportScreenState createState() => ReportScreenState();
}

class ReportScreenState extends State<ReportScreen> {
  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];


  final fromDate = DateTime(2019, 05, 1);
  final toDate =  DateTime(2019, 05, 15);

  final date1 =DateTime(2019, 05, 15).subtract(Duration(days: 2));
  final date2 = DateTime(2019, 05, 15).subtract(Duration(days: 3));



  // TODO: Add a variable for Category (104)
  int maxId = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title:
      ),
      body:
      tabController(),

    );
  }


  Widget Defecationhabit(){
    return Center(
      // child: SimpleLineChart(),
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
  Widget tabController(){

    return  DefaultTabController(
      length: choices.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: choices.map((Choice choice) {
              return Tab(
                text: choice.title,
                //    icon: Icon(choice.icon),
              );
            }).toList(),
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

}

class Choice {
  const Choice({this.title, this.icon, this.widget});

  final String title;
  final IconData icon;
  final Widget widget;
}

List<Choice> choices =  <Choice>[
  Choice(title: 'life', icon: Icons.restaurant, widget: Lifestyle()),
  Choice(title: 'Defecation', icon: Icons.restaurant, widget: LineChartSample2()),
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
            pi2.PieChart(
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
              legendPosition: pi2.LegendPosition.right,
              decimalPlaces: 1,
              showChartValueLabel: true,
              initialAngle: 0,
              chartValueStyle: pi2.defaultChartValueStyle.copyWith(
                color: Colors.blueGrey[900].withOpacity(0.9),
              ),
              chartType: pi2.ChartType.disc,
            ),

            pi2.PieChart(
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
              legendPosition: pi2.LegendPosition.right,
              decimalPlaces: 1,
              showChartValueLabel: true,
              initialAngle: 0,
              chartValueStyle: pi2.defaultChartValueStyle.copyWith(
                color: Colors.blueGrey[900].withOpacity(0.9),
              ),
              chartType: pi2.ChartType.disc,
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

class LineChartSample2 extends StatefulWidget {
  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    Colors.black26,
    Colors.black26,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return
      Container(
        decoration: BoxDecoration(
          /* borderRadius: const BorderRadius.all(
                  Radius.circular(18),
                ),*/
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.only(
              right: 12.0, left: 12.0, top: 10, bottom: 10),

          child: Column(

            children: [

              LineChart(
                mainData(),
              ),
              LineChart(
                mainData(),
              ),
              LineChart(
                mainData(),
              ),
            ],
          ),
        ),
      );


  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalGrid: true,
        getDrawingHorizontalGridLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalGridLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 120,
          textStyle: TextStyle(
              color: const Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: const Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: false,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
            dotColor: Colors.black54,
            dotSize: 2,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
            gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
