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
int completePercentage =0;

String uerUid = " ";
String alarmHour = " ";
String alarmMinute = " ";
String alarmTime = " ";

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
      uerUid = user.uid;
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
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('User').document(uerUid).snapshots(),
        builder: (context, snapshot){
          if (!snapshot.hasData) return LinearProgressIndicator();
          else{
            final userRecord = UserRecord.fromSnapshot(snapshot.data);
            continueDay = DateTime.now().difference(userRecord.startTime.toDate()).inDays;
            alarmHour = (userRecord.alarmStamp.toDate().hour+9).toString();
            alarmMinute = userRecord.alarmStamp.toDate().minute.toString();
            if (int.parse(alarmHour)>=24)
              alarmHour = (int.parse(alarmHour)-24).toString();
            alarmTime = "$alarmHour:$alarmMinute";
          }
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.alarm),
                onPressed: () {
                  Navigator.pushNamed(context, Alarm.routeName, arguments: AlarmArguments("home"));
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
          stream: Firestore.instance.collection('User').document(uerUid).collection('survey').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            else {
              int countSurvey = 0;
              final list = snapshot.data.documents;
              for (var document in list) {
                final record = SurveyRecord.fromSnapshot(document);
                if (record.complete == true) {
                  countSurvey = countSurvey + 1;
                }
              }
              final percentage = (countSurvey / 14 * 100).toInt();
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
            }
          },
        ),
      ],
    );
  }

  Widget _buildBottles(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('User').document(uerUid).collection('survey').snapshots(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) return LinearProgressIndicator();
        else{
          int countSurvey = 0;
          final documentList =  snapshot.data.documents;
          for(var document in documentList){
            final record = SurveyRecord.fromSnapshot(document);
            if(record.complete==true){
              countSurvey = countSurvey+1;
            }
          }
          return continueDay < 7? _buildList(context, documentList.sublist(0,7)) :_buildList(context, documentList.sublist(7,14)) ;//code change.. after making all document
        }
      },
    );
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
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0.0),
      child:Container(
          child: SizedBox(
            width: MediaQuery.of(context).size.width/8,
            height: MediaQuery.of(context).size.width/7,
            child: data.documentID == DateFormat("yyyy-MM-dd").format(DateTime.now()).toString()?
            FlatButton(
                child : Container(
                  width: 100,
                  height: 100,
                  child : Stack(
                    children: <Widget>[
                      Center(
                        child:record.complete == true? Image.asset("water2.png") : Image.asset("water1.png") ,
                      ),
                      Center(
                        child:Icon(Icons.add, size:30.0, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Surveypage.routeName);
                }
            )
                :FlatButton(
              child : Container(
                width: 100,
                height: 100,
                child : record.complete == true? Image.asset("water2.png") : Image.asset("water1.png"),
              ),
              onPressed: null,
            ),
          )
      ),
    );
  }


  Widget LowerScreen() {
    DateTime oneDaysAgo = DateTime.now().subtract(new Duration(days: 1));
    String oneDaysAgoDate = DateFormat("yyyy-MM-dd").format(oneDaysAgo).toString();
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('User').document(uerUid).collection('survey').document(oneDaysAgoDate).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Text("Fighting");
          }
          else{
            SurveyRecordSub surveyRecordSub = SurveyRecordSub.fromMap(snapshot.data.data);
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
                          surveyRecordSub.question6 < 6 ?
                          Row(children: [
                            Text("${6 - surveyRecordSub.question6} 시간 ",
                                style: TextStyle(fontSize: 20.0,
                                    color: Colors.pink,
                                    fontWeight: FontWeight.bold)),
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
                              surveyRecordSub.question3_1 == 0 ?
                              Row(
                                children: [
                                  Text("오늘 ", style: TextStyle(fontSize: 20.0)),
                                  Text("아침", style: TextStyle(fontSize: 20.0,
                                      color: Colors.indigo[500],
                                      fontWeight: FontWeight.bold)),
                                  Text("을 드시는 건 어떠신가요?",
                                      style: TextStyle(fontSize: 20.0))
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
        }
    );
  }
}
