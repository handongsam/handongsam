import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'survey.dart';
import 'login.dart';
import 'alarm.dart';
import 'final_report.dart';
import 'home_after.dart';
import 'survey_inform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomePage extends StatefulWidget{
  static const routeName = '/homeScreen';
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // TODO: Add a variable for Category (104)
  int maxId = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.alarm),
          onPressed: () {
            Navigator.pushNamed(context, Alarm.routeName);
          },
        ),
        title: Center(
          child: const Text('한동샘'),
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.description),
                onPressed: () {
                  Navigator.pushNamed(context, ReportScreen.routeName);
                },
              ),
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async{
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, LoginPage.routeName);
                },
              ),
              IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: () {
                  Navigator.pushNamed(context, FinalHome.routeName);
                },
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: MakeBody(),
      ),
    );
  }
}

class MakeBody extends StatefulWidget{
  @override
  MakeBodyState createState() => MakeBodyState();
}

class MakeBodyState extends State<MakeBody>{
  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height/3,
          child : UpperScreen(),
        ),
        Divider(color: Colors.grey),
        Expanded(
          //height: MediaQuery.of(context).size.height/3,
          child : LowerScreen(),
        ),
      ],
    );
  }

  Widget UpperScreen(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("제품 첫 복용 후", style : TextStyle(fontSize: 20.0),),
        Text("7일 경과하셨습니다.", style : TextStyle(fontSize: 20.0),),
        SizedBox(height: 10.0),
        Text("맛 알람 8:00"),
        SizedBox(height: 10.0),
        Bottles(),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text("이번주 장알기 42%달성     "),
          ],
        ),
      ],
    );
  }
  Widget Bottles(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.battery_full, size:50.0),
        Icon(Icons.battery_full,size:50.0),
        Icon(Icons.battery_full,size:50.0),
        Icon(Icons.battery_full,size:50.0),
        Icon(Icons.battery_full,size:50.0),
        Icon(Icons.battery_full,size:50.0),
        FlatButton(
          child :Icon(Icons.battery_unknown,size:50.0),
          onPressed: () {
            TodayDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();
            Firestore.instance.collection("User").document(CurrentUid).collection('survey').document(TodayDate).setData({
              'question1': true,
              'question2': 0,
              'question3-1': 0,
              'question3-2':0,
              'question3-3' : 0,
              'question4-1': 0,
              'question4-2': 0,
              'question4-3': 0,
              'question5': true,
              'question6': 0,
              'memo' : 'hi',
            },);
            Navigator.pushNamed(context, Question1.routeName);
          },
        ),
      ],
    );
  }

  Widget LowerScreen(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15.0),
              child:Icon(Icons.brightness_2,size:50.0),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("수면시간이 ",  style : TextStyle(fontSize: 20.0)),
                  Text("2시간 부족",style: TextStyle(fontSize: 20.0, color:Colors.pink,fontWeight:FontWeight.bold)),
                  Text("합니다.",style: TextStyle(fontSize: 20.0) )
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15.0),
              child:Icon(Icons.fastfood,size:50.0),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text("오늘 아침은 든든한",style : TextStyle(fontSize: 20.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("한식",style : TextStyle(fontSize: 20.0, color:Colors.blueAccent,fontWeight:FontWeight.bold)),
                      Text("을 드시는 건 어떠신가요?",style : TextStyle(fontSize: 20.0)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
