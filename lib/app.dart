
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
          Question1.routeName : (context)=>Question1(),
          ReportScreen.routeName : (context)=>ReportScreen(),
          FinalHome.routeName : (context) => FinalHome(),
        },

        title: 'HandongSam',
        //home: HomePage(),
        home: LoginPage(),
        //initialRoute: '/login',
        onGenerateRoute: _getRoute,
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.blueAccent,

          // Define the default font family.
          fontFamily: 'Montserrat',
          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        )
      // TODO: Add a theme (103)
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
