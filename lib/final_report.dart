import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:charts_flutter/flutter.dart'as charts;
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:pie_chart/pie_chart.dart'as pi2;
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fl_chart/fl_chart.dart' ;


import 'package:firebase_auth/firebase_auth.dart';
import 'survey_record.dart';

//linechart data definition

List<bool> complete = List<bool>();
List<int> question2 = List<int>();
List<int> question3_1 = List<int>();
List<int> question3_2 = List<int>();
List<int> question3_3 = List<int>();
List<int> question4_1 = List<int>();
List<int> question4_2 = List<int>();
List<int> question4_3 = List<int>();


class finalresult {
  final int date;
  final int value;

  finalresult(this.date, this.value);
}

class question4_1result {
  final int date;
  final int value;

  question4_1result(this.date, this.value);
}


class ReportScreen extends StatefulWidget{
  static const routeName = '/reportScreen';
  @override
  ReportScreenState createState() => ReportScreenState();
}

class ReportScreenState extends State<ReportScreen> {

  List<charts.Series<finalresult, int>> _finalLineData;
  List<charts.Series<question4_1result, int>> question4_1list;

  Future<void> getData(BuildContext context) async{
    Firestore.instance.collection("User").document(await _makeUserID(context)).collection('survey').getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        var survey = SurveyRecord.fromSnapshot(f);
        question2.add(survey.question2);
        question3_1.add(survey.question3_1);
        question3_2.add(survey.question3_2);
        question3_3.add(survey.question3_3);
        question4_1.add(survey.question4_1);
        question4_2.add(survey.question4_2);
        question4_3.add(survey.question4_3);
        complete.add(survey.complete);
      });
    });
  }


  Future<String> _makeUserID(BuildContext context) async{
    FirebaseUser userId = await FirebaseAuth.instance.currentUser();
    var authName = userId.uid.toString();
    return authName;
  }

  //linechart data input
  _generateData() {
    final finaldata = [
      new finalresult(0, 5),
      new finalresult(1, 25),
      new finalresult(2, 100),
      new finalresult(3, 75),
    ];
    final question4_1data = [
      new question4_1result(0, 5),
      new question4_1result(1, 25),
      new question4_1result(2, 100),
      new question4_1result(3, 75),
    ];


    _finalLineData.add(
      charts.Series(
        id: 'finaldata',
        domainFn: (finalresult finals, _) => finals.date,
        measureFn: (finalresult finals, _) => finals.value,
        data: finaldata,
      ),
    );

    question4_1list.add(
      charts.Series(
        id: 'question4_1',
        domainFn: (question4_1result one, _) => one.date,
        measureFn: (question4_1result one, _) => one.value,
        data: question4_1data,
      ),
    );
  }


  void initState() {
    super.initState();
    _finalLineData = List<charts.Series<finalresult, int>>();
    question4_1list = List<charts.Series<question4_1result, int>>();
    _generateData();
  }


  final controller = PageController(
    initialPage: 1,
  );

  @override
  Widget build(BuildContext context) {
    getData(context);

    return
      CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: false,
            snap: false,
            expandedHeight: 150.0,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Final Graph'),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 300.0,
            delegate: SliverChildListDelegate(
              [
                finalGraph(),
              ],
            ),
          ),

          SliverFixedExtentList(
            itemExtent: 500.0,
            delegate: SliverChildListDelegate(
              [
                tabController(),
              ],
            ),
          ),
        ],
      );
  }

  Widget finalGraph() {
    return Scaffold(
      body: charts.LineChart(_finalLineData,
          //   animate: animate,
          defaultRenderer: new charts.LineRendererConfig(
              includePoints: true, areaOpacity:0.1 )),);
  }

  Widget tabController() {
    TabController _tabController;

    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
        appBar: TabBar(
          isScrollable: true,
          tabs: choices.map((Choice choice) {
            return Tab(
              text: choice.title,
              //    icon: Icon(choice.icon),
            );
          }).toList(),

        ),
        body: TabBarView(
          children: choices.map((Choice choice) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ChoiceCard(choice: choice),
            );
          }).toList(),
          controller: _tabController,

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
  //Map<String, double> habit = {'eating': 36, 'not eating':10 };
  //Map<String, double> dailyFood = {'탄수화물': 36, '지방':10, '채소':14 };
  Map<String, double> habit = {'eating': 0, 'not eating': 0};
  Map<String, double> dailyFood = { '인스턴트' : 0, '단백질' : 0, '탄수화물': 0, '지방': 0, '채소': 0};

  void getHabitDailyFoodDate(List<int> array) {
    for (var i = 0; i < 15; i++){
      var food = array[i];
      if(food == 1){
        habit['not eating'] += 1;
      }
      else if(food!=0){
        habit['eating'] += 1;
        if(food == 2){
          dailyFood['인스턴트'] += 1;
        }
        else if(food==3){
          dailyFood['단백질'] += 1;
        }
        else if(food==4){
          dailyFood['탄수화물'] += 1;
        }
        else if(food==5){
          dailyFood['지방'] += 1;
        }
        else if(food==6){
          dailyFood['채소'] += 1;
        }
      }
    }
  }

  void getAllHabitDailyFoodDate() {
    getHabitDailyFoodDate(question3_1);
    getHabitDailyFoodDate(question3_2);
    getHabitDailyFoodDate(question3_3);
  }


  @override
  Widget build(BuildContext context) {
    getAllHabitDailyFoodDate();
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


/*Widget Defecationhabit() {
  return Scaffold(
    body: charts.LineChart(question4_1list,
        //   animate: animate,
        defaultRenderer: new charts.LineRendererConfig(
            includePoints: true)),);
}*/


class Defecationhabit extends StatefulWidget{
  @override
  DefecationhabitState createState() => DefecationhabitState();
}

class DefecationhabitState extends State<Defecationhabit> {

  List<charts.Series<question4_1result, int>> question4_1list;

  //final bool animate;

  //linechart data input
  _generateData() {

    final question4_1data = [
      new question4_1result(1, 3),
      new question4_1result(2, 5),
      new question4_1result(3, 4),
      new question4_1result(4, 2),
    ];


    question4_1list.add(
      charts.Series(
        id: 'question4_1',
        domainFn: (question4_1result one, _) => one.date,
        measureFn: (question4_1result one, _) => one.value,
        data: question4_1data,
      ),
    );
  }


  void initState() {
    super.initState();
    question4_1list = List<charts.Series<question4_1result, int>>();
    _generateData();
  }
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth: 250.0,
          minWidth: 100.0,
          maxHeight: 400.0,
          minHeight: 100.0
      ),
      child:

      Column(
        mainAxisSize: MainAxisSize.min,

        children:[

          Expanded(
            child:Container(

              child:charts.LineChart(question4_1list,
                defaultRenderer: new charts.LineRendererConfig(
                  includePoints: true,               areaOpacity: 0.8,
                ),
                behaviors: [
                  new charts.ChartTitle(
                    '배변횟수',
                    behaviorPosition: charts.BehaviorPosition.top,
                    titleOutsideJustification: charts.OutsideJustification.middle,

                    innerPadding: 20,
                    titleStyleSpec: charts.TextStyleSpec(fontSize: 13),    ),
                ],
              ),),),
          SizedBox(height: 10),
          Expanded(
            child:Container(

              child:charts.LineChart(question4_1list,
                defaultRenderer: new charts.LineRendererConfig(
                  includePoints: true,               areaOpacity: 0.8,
                ),
                behaviors: [
                  new charts.ChartTitle(
                    '배변감',
                    behaviorPosition: charts.BehaviorPosition.top,
                    titleOutsideJustification: charts.OutsideJustification.middle,

                    innerPadding: 20,
                    titleStyleSpec: charts.TextStyleSpec(fontSize: 13),    ),
                ],
              ),),),
          SizedBox(height: 10),
          Expanded(
            child:Container(
              child:
              charts.LineChart(question4_1list,
                defaultRenderer: new charts.LineRendererConfig(
                  includePoints: true,               areaOpacity: 0.8,
                ),
                behaviors: [
                  new charts.ChartTitle(
                    '배변상태',
                    behaviorPosition: charts.BehaviorPosition.top,
                    titleOutsideJustification: charts.OutsideJustification.middle,

                    innerPadding: 20,
                    titleStyleSpec: charts.TextStyleSpec(fontSize: 13),    ),
                ],
              ),),),
        ],),
    );
  }
}