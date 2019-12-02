
import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'create_account.dart';
import 'alarm_inform.dart';
import 'alarm.dart';
import 'survey_inform.dart';
import 'survey.dart';
import 'final_report.dart';
import 'home_after.dart';
import 'calender.dart';

// TODO: Convert ShrineApp to stateful widget (104)
class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          LoginPage.routeName : (context) => LoginPage(),
          HomePage.routeName : (context) => HomePage(),
          CreateAccount.routeName : (context)=> CreateAccount(),
          AlarmInform.routeName : (context) => AlarmInform(),
          Alarm.routeName : (context) =>Alarm(),
          SurveyInform.routeName : (context) =>SurveyInform(),
          Surveypage.routeName : (context)=>Surveypage(),
          ReportScreen.routeName : (context)=>ReportScreen(),
          FinalHome.routeName : (context) => FinalHome(),
          CalenderScreen.routeName :(context) =>CalenderScreen(),
        },

        title: 'HandongSam',
        home: LoginPage(),
        onGenerateRoute: _getRoute,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.blueAccent,
          fontFamily: 'Montserrat',
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        )
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}
