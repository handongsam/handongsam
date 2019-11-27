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

DateTime alarmTime  = DateTime.now();
int passTime = 1;
double completePercentage = 0;


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
        if (!snapshot.hasData) return LinearProgressIndicator();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("제품 첫 복용 후", style : TextStyle(fontSize: 20.0),),
            Row(
              children: <Widget>[
                Text(userRecord.d, style : TextStyle(fontSize: 20.0),),
                Text("일 경과하셨습니다.", style : TextStyle(fontSize: 20.0),),
              ],
            ),
            SizedBox(height: 10.0),
            Text("맛 알람 8:00"),
            SizedBox(height: 10.0),
            _buildBottles(context),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("이번주 장알기 42%달성     "),
              ],
            ),
          ],
        );;
      },
    );
  }

//  Widget UpperScreen(){
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: <Widget>[
//        Text("제품 첫 복용 후", style : TextStyle(fontSize: 20.0),),
//        Text("7일 경과하셨습니다.", style : TextStyle(fontSize: 20.0),),
//        SizedBox(height: 10.0),
//        Text("맛 알람 8:00"),
//        SizedBox(height: 10.0),
//        _buildBottles(context),
//        SizedBox(height: 10.0),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.end,
//          children: <Widget>[
//            Text("이번주 장알기 42%달성     "),
//          ],
//        ),
//      ],
//    );
//  }

  Widget _buildBottles(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('User').document(user.uid).collection('survey').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Row(
      //padding: const EdgeInsets.only(top: 20.0),
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
              width: MediaQuery.of(context).size.width/9,
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
              width: MediaQuery.of(context).size.width/9,
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