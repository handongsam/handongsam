import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'survey.dart';
import 'login.dart';
import 'alarm.dart';
import 'final_report.dart';
import 'home_after.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'survey_record.dart';
import 'user_inform.dart';

DocumentSnapshot documentSnapshot;
List<bool> complete;
int continueDay = 0;

class HomePage extends StatefulWidget{
  static const routeName = '/homeScreen';
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  FirebaseUser user;
  String error;

  void setUser(FirebaseUser user) {
    setState(() {
      this.user = user;
      this.error = null;
    });
  }

  void setError(e) {
    setState(() {
      this.user = null;
      this.error = e.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then(setUser).catchError(setError);
  }

  @override
  Widget build(BuildContext context) {
    print(user.uid);
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
  FirebaseUser user;
  String error;

  void setUser(FirebaseUser user) {
    setState(() {
      this.user = user;
      this.error = null;
    });
  }

  void setError(e) {
    setState(() {
      this.user = null;
      this.error = e.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then(setUser).catchError(setError);
  }

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
    return  StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('User').document(user.uid).snapshots(),
      builder: (context, snapshot) {
        documentSnapshot = snapshot.data;
        final userRecord = UserRecord.fromSnapshot(snapshot.data);
        continueDay = DateTime.now().difference(userRecord.startTime.toDate()).inDays;
        final alarmHour = userRecord.alarmStamp.toDate().hour+9;
        final alarmMinute = userRecord.alarmStamp.toDate().minute;
        final alarmTime = "$alarmHour:$alarmMinute";
        if (!snapshot.hasData) return LinearProgressIndicator();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("제품 첫 복용 후", style : TextStyle(fontSize: 20.0),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(continueDay.toString(), style : TextStyle(fontSize: 20.0),),
                Text("일 경과하셨습니다.", style : TextStyle(fontSize: 20.0),),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("맛 알람 "),
                Text(alarmTime),
              ],
            ),
            SizedBox(height: 10.0),
            _buildBottles(context),
            SizedBox(height: 10.0),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('User').document(user.uid).collection('survey').snapshots(),
              builder: (context, snapshot) {
                int countSurvey = 0;
                final list =  snapshot.data.documents;
                for(var document in list){
                  final record = SurveyRecord.fromSnapshot(document);
                  if(record.complete==true){
                    countSurvey = countSurvey+1;
                  }
                }
                final percentage = (countSurvey/14*100).toInt();
                if (!snapshot.hasData) return LinearProgressIndicator();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("장일기 "),
                    Text(percentage.toString()),
                    Container(
                      child: Text("% 달성        "),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottles(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('User').document(user.uid).collection('survey').snapshots(),
      builder: (context, snapshot) {
        int countSurvey = 0;

        final list =  snapshot.data.documents;
        for(var document in list){
          final record = SurveyRecord.fromSnapshot(document);
          if(record.complete==true){
            countSurvey = countSurvey+1;
          }
        }
        if (!snapshot.hasData) return LinearProgressIndicator();
        return continueDay>=7? _buildList(context, list.sublist(0,7)) :_buildList(context, list.sublist(7,14)) ;//code change.. after making all document
      },
    );
//    return StreamBuilder<QuerySnapshot>(
//      stream: Firestore.instance.collection('User').document(user.uid).collection('survey').snapshots(),
//      builder: (context, snapshot) {
//        if (!snapshot.hasData) return LinearProgressIndicator();
//        return _buildList(context, snapshot.data.documents);
//      },
//    );
  }
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = SurveyRecord.fromSnapshot(data);
    return Padding(
      //key: ValueKey(record.reference),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: record.complete == true?
          SizedBox(
              width: MediaQuery.of(context).size.width/9.5,
              height: MediaQuery.of(context).size.width/8,
              child:FlatButton(
                child : Image.asset("water2.png"),
                onPressed: () {
                  _makeSurveyDocument(context);
                  Navigator.pushNamed(context, Question1.routeName);
                },
              )
          ) :
          SizedBox(
              width: MediaQuery.of(context).size.width/9.5,
              height: MediaQuery.of(context).size.width/8,
              child:FlatButton(
                child : Image.asset("water1.png"),
                onPressed: () {
                  _makeSurveyDocument(context);
                  Navigator.pushNamed(context, Question1.routeName);
                },
              )
          )
      ),
    );
  }


  void _makeSurveyDocument(BuildContext context){
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
      'complete' : false,
    },);
  }

  Widget LowerScreen() {
    DateTime oneDaysAgo = DateTime.now().subtract(new Duration(days: 1));
    String oneDaysAgoDate = DateFormat("yyyy-MM-dd").format(oneDaysAgo).toString();
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('User').document(user.uid)
            .collection('survey').document(oneDaysAgoDate)
            .snapshots(),
        builder: (context, snapshot) {
          final surveyRecord = SurveyRecord.fromMap(snapshot.data.data);
          if (!snapshot.hasData) return LinearProgressIndicator();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: Icon(Icons.brightness_2, size: 50.0),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Text("수면시간이 ", style: TextStyle(fontSize: 20.0)),
                        surveyRecord.question6 < 6 ?
                        Row(children:[
                          Text("${6-surveyRecord.question6} 시간 ", style: TextStyle(fontSize: 20.0, color: Colors.pink, fontWeight: FontWeight.bold)),
                          Text("부족합니다", style: TextStyle(fontSize: 20.0)),
                        ],
                        ) : Text("어제의 설문지가 존재하지 않습니다."),
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
                    child: Icon(Icons.fastfood, size: 50.0),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        // Text("오늘 아침은", style: TextStyle(fontSize: 20.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            surveyRecord.question3_1 == 0 ?
                            Row(
                              children:[
                                Text("오늘 ", style: TextStyle(fontSize: 20.0)),
                                Text("아침", style: TextStyle(fontSize: 20.0, color: Colors.indigo[500], fontWeight: FontWeight.bold)),
                                Text("을 드시는 건 어떠신가요?", style: TextStyle(fontSize: 20.0))
                              ],)
                                : Text("어제의 설문지가 존재하지 않습니다."),
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
    );
  }

}
