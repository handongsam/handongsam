import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'survey.dart';

String TodayDate;

class SurveyInform extends StatefulWidget{
  static const routeName = '/sruveyInformScreen';
  @override
  SurveyInformState createState() => SurveyInformState();
}

class SurveyInformState extends State<SurveyInform> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon : Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon : Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.of(context).push( MaterialPageRoute(builder: (context) =>BeforeStartSurvey()));
                },
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: MakeDescription(),
      ),
    );
  }

  Widget MakeDescription(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom:30.0),
          child: Icon(
            Icons.description,
            size:70.0,
          ),
        ),

        Container(
          margin: const EdgeInsets.only(bottom:10.0),
          child : Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "장일기",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("는 하루 동안의 배변과", style: TextStyle(fontSize: 18),),
                ],
              ),
              Text("식단을 기록합니다.", style: TextStyle(fontSize: 18),),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child : Column(
            children: <Widget>[
              Text("습관이 형성되는", style: TextStyle(fontSize: 18),),
              Text("14일동안 매일 진행되며", style: TextStyle(fontSize: 18),),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child : Column(
            children: <Widget>[
              Text("14일 이후 결과 보고서를 통해", style: TextStyle(fontSize: 18),),
              Text("장의 변화를 확인하실 수 있습니다.", style: TextStyle(fontSize: 18),),
            ],
          ),
        ),
      ],
    );
  }
}

class BeforeStartSurvey extends StatefulWidget{
  @override
  BeforeStartSurveyState createState() => BeforeStartSurveyState();
}

class BeforeStartSurveyState extends State<BeforeStartSurvey> {
  // TODO: Add a variable for Category (104)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon : Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
//        actions: <Widget>[
//          Row(
//            children: <Widget>[
//              IconButton(
//                icon : Icon(Icons.arrow_forward_ios),
//                onPressed: (){
//                  //Navigator.pop(context);
//                },
//              ),
//            ],
//          ),
//        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.description,
              size:70.0,
            ),
            SizedBox(height:20.0),
            Text("7일째" ,style:TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
            SizedBox(height:40),
            RaisedButton(
              onPressed: () {
                TodayDate = DateTime.now().toString();
                Firestore.instance.collection("User")
                    .document(CurrentUid).collection('survey').document(TodayDate)
                    .setData({
                  'question1': true,
                  'question2': 0,
                  'question3-1': 0,
                  'question3-2':0,
                  'question3-3' : 0,
                  'question4-1': 0,
                  'question4-2': 0,
                  'question4-3': 0,
                  'question5': 0,
                  'question6': 0,
                  'memo' : 'hi',
                },);

                Navigator.pushNamed(context, Question1.routeName);

              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                    '오늘의 장일기 시작',
                    style: TextStyle(fontSize: 17.0)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}