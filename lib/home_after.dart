import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'final_report.dart';
import 'login.dart';
import 'alarm.dart';
import 'calender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FinalHome extends StatefulWidget {
  static const routeName = '/finalHomeScreen';
  @override
  FinalHomeState createState() => new FinalHomeState();
}

class FinalHomeState extends State<FinalHome> {

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width/2.2;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.alarm),
          onPressed: () {
            Navigator.pushNamed(context, Alarm.routeName, arguments: AlarmArguments("home"));
          },
        ),
        title: Center(
          child: const Text('한동샘',style : TextStyle(fontSize: 18.0),),
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon:Icon(Icons.calendar_today),
                onPressed: () {
                  Navigator.pushNamed(context, CalenderScreen.routeName);
                },
              ),
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async{
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, LoginPage.routeName);
                },
              ),
            ],
          ),
        ],
      ),
      body: SafeArea( child: Column( children:[
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child:Column(
            crossAxisAlignment:CrossAxisAlignment.center,
            children:[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  children:[
                    Text('축하합니다.', style:TextStyle(fontSize: 17.0)),
                    Text('최종보고서를 확인하세요',  style:TextStyle(fontSize: 17.0), ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 55),
                child: FlatButton(
                  child: const Text('확인'),
                  textColor: Colors.white,
                  color: Colors.black,
                  onPressed: ()=> Navigator.pushNamed(context, ReportScreen.routeName),
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Container(
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.center,
            children:[
              Container(
                padding : EdgeInsets.symmetric(vertical: 16),
                child:Text('재구매를 원하십니까?',style:TextStyle(fontSize: 17.0)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Column(
                    children:[
                      InkWell(
                          child : Image.asset('balance.jpg', height: size, width:size,),
                          onTap: () =>Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) => MyWebPage1()))
                      ),
                      Text("위드워터 밸런스",style:TextStyle(fontSize: 17.0)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    children:[
                      InkWell(
                          child : Image.asset('intensive.jpg', height: size, width:size),
                          onTap: ()=>Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) => MyWebPage2()))
                      ),
                      Text("위드워터 인텐시브",style:TextStyle(fontSize: 17.0)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      ),
      ),
    );
  }
}

class MyWebPage1 extends StatefulWidget {
  @override
  MyWebPage1State createState() => MyWebPage1State();
}

class MyWebPage1State extends State<MyWebPage1> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Handong Sam"),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              semanticLabel: 'Webpage',
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body : WebView(
          initialUrl: 'https://handongsam.com/product/wb1e',
          javascriptMode: JavascriptMode.unrestricted,
        )
    );
  }
}


class MyWebPage2 extends StatefulWidget {

  @override
  MyWebPage2State createState() => MyWebPage2State();
}

class MyWebPage2State extends State<MyWebPage2> {
  @override
  Widget build(BuildContext context){
    return Scaffold(

        appBar: new AppBar(
          title: new Text("Handong Sam",style : TextStyle(fontSize: 18.0),),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,color: Colors.black54, size: 18.0,
              semanticLabel: 'Webpage',
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body : WebView(
          initialUrl: 'https://handongsam.com/product/wi1e',
          javascriptMode: JavascriptMode.unrestricted,
        )
    );
  }
}