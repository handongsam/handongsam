import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'login.dart';
import 'survey.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                  Navigator.of(context).push( MaterialPageRoute(builder: (context) =>Surveypage()));
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
            size:50.0,
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
                    style: TextStyle(color: Colors.indigo[700], fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("는 하루 동안의 배변과", style: TextStyle(fontSize: 16),),
                ],
              ),
              Text("식단을 기록합니다.", style: TextStyle(fontSize: 16),),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child : Column(
            children: <Widget>[
              Text("습관이 형성되는", style: TextStyle(fontSize: 16),),
              Text("14일동안 매일 진행되며", style: TextStyle(fontSize: 16),),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child : Column(
            children: <Widget>[
              Text("14일 이후 결과 보고서를 통해", style: TextStyle(fontSize: 16),),
              Text("장의 변화를 확인하실 수 있습니다.", style: TextStyle(fontSize: 16),),
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.description,
              size:50.0,
            ),
            SizedBox(height:20.0),
            Text("7일째" ,style:TextStyle(fontSize: 17.0)),
            SizedBox(height:40),
            RaisedButton(
              onPressed: () async{
                Navigator.pushNamed(context, Surveypage.routeName);
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.indigo,
                  ),
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                    '오늘의 장일기 시작',
                    style: TextStyle(fontSize: 16.0)
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

}