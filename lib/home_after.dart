import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'main.dart';

class FinalHome extends StatefulWidget {
  static const routeName = '/finalHomeScreen';
  @override
  FinalHomeState createState() => new FinalHomeState();
}

class FinalHomeState extends State<FinalHome> {
  // TODO: Add a variable for Category (104)
  double _sliderValue = 0.0;
  bool good = false;
  bool bad = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
        InkWell(
          child: Container(
            child: Row( children: [
              IconButton(

                icon: Icon(
                  Icons.alarm,
                ),
              ),
            ],),),
          onTap: () =>  Navigator.of(context).pop()            ,
        ),

      ),
      body: Center(child: Column(
        children:[
          Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child:Column(

              crossAxisAlignment:CrossAxisAlignment.center,
              // mainAxisAlignment:MainAxisAlignment.start,

              children:[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),

                  child:
                  Column(

                    children:[
                      Text('축하합니다.'),
                      Text('최종보고서를 확인하세요'),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 55),

                  child:

                  Row( children:[
                    FlatButton( child: const Text('확인'),   textColor: Colors.white,
                      color: Colors.black, onPressed: null, ),
                    SizedBox(width: 10),
                    FlatButton( child: const Text('계속하기'),textColor: Colors.white,
                      color: Colors.black,  onPressed: null, ),
                  ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 75),

            child:
            Column(
              crossAxisAlignment:CrossAxisAlignment.center,

              children:[
                Text('재구매를 원하십니까?'),
                SizedBox(height: 30),
                Row( children:[
                  Column( children:[  InkWell(child : Image.asset('product1.JPG', width: 110, height: 130) ,
                      onTap: (){   {
                        Navigator.of(context)
                            .push( //MaterialPageRoute(builder: (context) =>DetailPage()),);
                            MaterialPageRoute<void>(

                              //builder: (BuildContext context) {
                              builder: (BuildContext context) => MyWebPage1(),

                            )
                        );
                      }} ),
                    Text("위드워터 밸런스"),],),
                  SizedBox(width: 10),
                  Column( children:[ InkWell(child : Image.asset('product2.jpg', width: 110, height: 130) ,
                      onTap: (){     Navigator.of(context)
                          .push( //MaterialPageRoute(builder: (context) =>DetailPage()),);
                          MaterialPageRoute<void>(

                            //builder: (BuildContext context) {
                            builder: (BuildContext context) => MyWebPage2(),

                          )
                      );
                      } ),
                    Text("위드워터 인텐시브"),],),
                ],),],
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
          initialUrl: 'https://handongsam.com/product/wi1e',
          javascriptMode: JavascriptMode.unrestricted,
        )
    );
  }
}