import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:charts_flutter/flutter.dart'as charts;
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart'as pi2;
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fl_chart/fl_chart.dart' ;


import 'package:firebase_auth/firebase_auth.dart';
import 'survey_record.dart';
import 'user_inform.dart';

int dataFinishFlag = 0;
//linechart data definition

List<bool> complete = List<bool>();
List<int> question2 = List<int>();
List<int> question3_1 = List<int>();
List<int> question3_2 = List<int>();
List<int> question3_3 = List<int>();
List<int> question4_1 = List<int>();
List<int> question4_2 = List<int>();
List<int> question4_3 = List<int>();
List<String> documentID = List<String>();

class FinalResult {
  final DateTime time;
  final int totalScore;
  FinalResult(this.time, this.totalScore);
}

class question4_1result {
  final DateTime date;
  final int value;

  question4_1result(this.date, this.value);
}


class question4_2result {
  final DateTime date;
  final int value;

  question4_2result(this.date, this.value);
}

class question4_3result {
  final DateTime date;
  final int value;

  question4_3result(this.date, this.value);
}

class question2result {
  final DateTime date;
  final int value;

  question2result(this.date, this.value);
}

class ReportScreen extends StatefulWidget{
  static const routeName = '/reportScreen';
  @override
  ReportScreenState createState() => ReportScreenState();
}

class ReportScreenState extends State<ReportScreen> {
  Future<String> _makeUserID(BuildContext context) async{
    FirebaseUser userId = await FirebaseAuth.instance.currentUser();
    var authName = userId.uid.toString();
    return authName;
  }



  @override
  void initState() {
    super.initState();
    getData(context);
  }

  final controller = PageController(
    initialPage: 1,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator()
              );
            default:
              return makeCustomScrollView(context);
          }
        }
    );
  }

  Widget makeCustomScrollView(BuildContext context){
    return  CustomScrollView(
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

  List<charts.Series<question4_1result, int>> question4_1list;
  List<charts.Series<question4_1result, int>> question4_2list;
  List<charts.Series<question4_1result, int>> question4_3list;
  List<charts.Series<question2result, int>> question2_list;

  Future<int> getData(BuildContext context) async{
    Firestore.instance.collection("User").document(await _makeUserID(context)).collection('survey').getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        var survey = SurveyRecord.fromSnapshot(f);
        documentID.add(survey.id);
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
    return 1;
  }

  Widget finalGraph() {
    _createSampleData();
    return Scaffold(
        body: charts.TimeSeriesChart(
            _finalLineData,
            defaultRenderer: new charts.LineRendererConfig(
                includePoints: true, areaOpacity:0.1
            )
        )
    );
  }

  List<charts.Series<FinalResult, DateTime>> _finalLineData = List<charts.Series<FinalResult, DateTime>> ();
  void _createSampleData() {
    List<FinalResult> data = List<FinalResult> ();
    for(int i=0; i<14; i++){
      DateTime nowDate =  DateFormat("yyyy-MM-dd").parse(documentID[i]);
      double totalScore =0;
      totalScore =getTotalScore(i,totalScore);
      data.add(new FinalResult(nowDate, totalScore.toInt()));
    }

    _finalLineData.add(
      charts.Series(
        id: 'finaldata',
        domainFn: (FinalResult finals, _) => finals.time,
        measureFn: (FinalResult finals, _) => finals.totalScore,
        data: data,
      ),
    );
  }

  double getTotalScore(int i, double totalScore){
    totalScore += question2[i]*3.333;
    getQuestion3Score(i,totalScore, question3_1);
    getQuestion3Score(i,totalScore, question3_2);
    getQuestion3Score(i,totalScore, question3_3);
    totalScore += 20-(3-question4_1[i]).abs()*3.333;
    totalScore += question4_2[i]*3.333;
    if(question4_3[i]==1||question4_3[i]==2)
      totalScore+= 20;
    else
      totalScore+=0;
    return totalScore;
  }

  void getQuestion3Score(int i, double totalScore, List<int> q3){
    if(q3[i]==1 || q3[i]==2)
      totalScore += 1;
    else if(q3[i]==4 || q3[i]==5)
      totalScore += 10;
    else
      totalScore += 20;
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
  Choice(title: 'stress', icon: Icons.person, widget:StressEvaluation()),

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
    for (var i = 0; i < 14; i++){
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

  // List<charts.Series<question4_1result, DateTime>> question4_1list;
  //final bool animate;

  //linechart data input
  List<charts.Series<question4_1result, DateTime>> _createQuestion4_1Data() {
    List<question4_1result> question4_1data = List<question4_1result> ();


    for (int i = 0; i < 14; i++) {
      DateTime nowDate=  DateFormat("yyyy-MM-dd").parse(documentID[i]);
      question4_1data.add(new question4_1result(nowDate, question4_1[i].toInt()));
    }

    return [
      new charts.Series<question4_1result, DateTime>(
        id: 'question4-1',
        domainFn: (question4_1result sales, _) => sales.date,
        measureFn: (question4_1result sales, _) => sales.value,
        data: question4_1data,
      )
    ];

  }
  List<charts.Series<question4_1result, DateTime>> _createQuestion4_2Data() {
    List<question4_1result> question4_1data = List<question4_1result> ();


    for (int i = 0; i < 14; i++) {
      DateTime nowDate=  DateFormat("yyyy-MM-dd").parse(documentID[i]);
      question4_1data.add(new question4_1result(nowDate, question4_2[i].toInt()));
    }

    return [
      new charts.Series<question4_1result, DateTime>(
        id: 'question4-2',
        domainFn: (question4_1result sales, _) => sales.date,
        measureFn: (question4_1result sales, _) => sales.value,
        data: question4_1data,
      )
    ];

  }
  List<charts.Series<question4_1result, DateTime>> _createQuestion4_3Data() {
    List<question4_1result> question4_1data = List<question4_1result> ();


    for (int i = 0; i < 14; i++) {
      DateTime nowDate=  DateFormat("yyyy-MM-dd").parse(documentID[i]);
      question4_1data.add(new question4_1result(nowDate, question4_3[i].toInt()));
    }

    return [
      new charts.Series<question4_1result, DateTime>(
        id: 'question4-3',
        domainFn: (question4_1result sales, _) => sales.date,
        measureFn: (question4_1result sales, _) => sales.value,
        data: question4_1data,
      )
    ];

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

              child: charts.TimeSeriesChart(

                _createQuestion4_1Data(),

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

              child: charts.TimeSeriesChart(

                _createQuestion4_2Data(),
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
              charts.TimeSeriesChart(
                _createQuestion4_3Data(),
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

class StressEvaluation extends StatefulWidget{
  @override
  StressEvaluationState createState() => StressEvaluationState();
}

class StressEvaluationState extends State<StressEvaluation> {

  List<charts.Series<question2result, DateTime>> _createQuestion2Data() {
    List<question2result> question4_1data = List<question2result>();


    for (int i = 0; i < 14; i++) {
      DateTime nowDate = DateFormat("yyyy-MM-dd").parse(documentID[i]);
      question4_1data.add(new question2result(nowDate, question2[i].toInt()));
    }

    return [
      new charts.Series<question2result, DateTime>(
        id: 'question2',
        domainFn: (question2result sales, _) => sales.date,
        measureFn: (question2result sales, _) => sales.value,
        data: question4_1data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return
      Expanded(
        child: Container(

          child:  charts.TimeSeriesChart(_createQuestion2Data(),
            defaultRenderer: new charts.LineRendererConfig(
              includePoints: true, areaOpacity: 0.8,
            ),
            behaviors: [
              new charts.ChartTitle(
                '스트레스 지수',
                behaviorPosition: charts.BehaviorPosition.top,
                titleOutsideJustification: charts.OutsideJustification.middle,

                innerPadding: 30,
                titleStyleSpec: charts.TextStyleSpec(fontSize: 15),),
            ],
          ),),

      );
  }
}