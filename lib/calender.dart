import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, WeekdayFormat;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'survey_record.dart';
import 'login.dart'; //currentUid

List<String> information = List<String>();
var question3 = {1:'먹지않음', 2:'인스턴트 혹은 패스트푸드', 3:'단백질 위주 반찬', 4:'탄수화물 위주 반찬', 5:'지방위주 반찬', 6:'채소위주의 반찬 '};
var question4_1 = {1: "분리된 딱딱한 대변", 2:"덩어리 모양 대변", 3:"금이간 소세지 모양 대변", 4:"소세지 모양의 부드러운 대변", 5:"부드러운 방울 모야 대변", 6: "곤죽같은 대변"};
var question4_2 = {0 : "많이 불편함", 1: "조금 불편함", 2:"아주 조금 불편함", 3:"보통", 4:"조금 편함", 5:"완전 편함"};
var question4_3 = {0 : "0회", 1: "1회", 2:"2번", 3:"3번", 4:"4번", 5:"5번"};

class CalenderScreen extends StatefulWidget{
  static const routeName = '/calenderScreenState';
  @override
  CalenderScreenState createState() => CalenderScreenState();
}

class CalenderScreenState extends State<CalenderScreen> {
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.blueAccent,
    ),
  );

  CalendarCarousel _calendarCarouselNoHeader;

  EventList<Event> _markedDateMap = new EventList<Event>();
  @override
  void initState() {
    getData(context);
    super.initState();
  }

  Future<void> getData(BuildContext context) async{
    Firestore.instance.collection("User").document(CurrentUid).collection('survey').getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        var survey = SurveyRecord.fromSnapshot(f);
        if(survey.complete==true){
          setState(() {
            _markedDateMap.add(
                new DateFormat("yyyy-MM-dd").parse(survey.id),
                new Event(
                  date : DateFormat("yyyy-MM-dd").parse(survey.id),
                  title : survey.id,
                  icon: _eventIcon,
                )
            );
          });
        }
      });
    });
  }

  void changeDate(SurveyRecord surveyRecord){
    information = List<String>();
    question4_1.forEach((k,v){
      if(k==surveyRecord.question4_1){
        information.add("배변상태: ${v}");
      }
    });

    question4_2.forEach((k,v){
      if(k==surveyRecord.question4_2){
        information.add("배변감: ${v}");
      }
    });

    question4_3.forEach((k,v){
      if(k==surveyRecord.question4_3){
        information.add("배변횟수: ${v}");
      }
    });

    question3.forEach((k,v){
      if(k==surveyRecord.question3_1){
        information.add("아침식사 : ${v}");
      }
    });

    question3.forEach((k,v){
      if(k==surveyRecord.question3_2){
        information.add("점심식사 : ${v}");
      }
    });

    question3.forEach((k,v){
      if(k==surveyRecord.question3_3){
        information.add("저녁식사 : ${v}");
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate2 = date);
        events.forEach((event){
          Firestore.instance.collection('User').document(CurrentUid).collection('survey').document(event.title).get().then((DocumentSnapshot ds) async{
            var surveyRecord = SurveyRecord.fromSnapshot(ds);
            setState(() {
              changeDate(surveyRecord);
            });
          });
        });
      },
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      height: 300.0,
      selectedDateTime: _currentDate2,
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.black,
      ),
      todayButtonColor: Colors.transparent,
      selectedDayTextStyle: TextStyle(
        color: Colors.white,
      ),
      selectedDayButtonColor: Colors.blueAccent,

      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),

      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(" "),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: 15.0,
                    bottom: 5.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: new Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(Icons.arrow_back_ios, size:15.0),
                        onPressed: () {
                          setState(() {
                            _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month -1);
                            _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                          });
                        },
                      ),
                      Expanded(
                        child: Center(
                          child:Text(
                            _currentMonth,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ) ,
                        ),
                      ),
                      FlatButton(
                        child: Icon(Icons.arrow_forward_ios, size:15.0),
                        onPressed: () {
                          setState(() {
                            _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month +1);
                            _currentMonth = DateFormat.yMMM().format(_targetDateTime);
                          });
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: _calendarCarouselNoHeader,
                ),
              ],
            ),
          ),
          Expanded(
            child:Card(
              color: Colors.grey[50],
              shape :RoundedRectangleBorder(borderRadius:BorderRadius.circular(0.8),),
              margin: EdgeInsets.all(10.0),
              elevation: 2,
              child:ListView.builder(
                itemCount: information.length,
                itemBuilder: (BuildContext context, int i){
                  return ListTile(
                    leading: Icon(Icons.check),
                    title : Text(information[i]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}