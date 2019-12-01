import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'package:intl/intl.dart';

String TodayDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).toString();


class Surveypage  extends StatelessWidget {
  static const routeName = '/Surveypage';

  @override
  final controller = PageController(
    initialPage: 0,
  );

  Widget build(BuildContext context) {
    print(CurrentUid);
    print(TodayDate);
    return new PageView(
        controller: controller,
        children:[
          Question1(),
          Question2(),
          Question3(),
          Question4(),
          Question5(),
          Question6(),
          Question7(),
        ]
    );
  }
}

//복용여부 , 스트레스 지수
class Question1 extends StatefulWidget {
  static const routeName = '/question1Screen';
  Question1({Key key}) : super(key: key);
  @override
  Question1State createState() => new Question1State();
}

class Question1State extends State<Question1> {
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
          child: Container( child: Row( children: [
            IconButton(

              icon: Icon(
                Icons.arrow_back_ios,
              ),
            ),
            Text("뒤로"),

          ],),),
          onTap: () =>  Navigator.of(context).pop()            ,
        ),

        actions: <Widget>[
          InkWell(
            child: Container( child: Row( children: [
              Text("다음"),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            ],),),
            onTap: () {         Navigator.of(context)
                .push( //MaterialPageRoute(builder: (context) =>DetailPage()),);
                MaterialPageRoute<void>(

                  //builder: (BuildContext context) {
                  builder: (BuildContext context) => Question2(),

                )
            );}     ,
          ),

        ],
      ),
      body:
      Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),

        child:
        Column(
          children:[
            Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              //height: 220,
              child:Column(

                crossAxisAlignment:CrossAxisAlignment.center,
                // mainAxisAlignment:MainAxisAlignment.start,


                children:[
                  Text('유산균을 복용하셨습니까?'),
                  SizedBox(height: 12),
                  Center(
                    child:

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        InkWell(
                            child :good == false ? Image.asset('happiness1.png', width: 110, height: 110) : Image.asset('shappiness.png', width: 110, height: 110), onTap: (){   setState(() {
                          if(good == false){
                            good= true;
                          }
                          else{
                            good=false;
                          }
                        });


                        Firestore.instance.collection("User")
                            .document(CurrentUid).collection('survey').document(TodayDate)
                            .updateData({
                          'question1' : true,
                        },);
                        } ),

                        InkWell(
                            child :bad == false ? Image.asset('frown-face1.png', width: 110, height: 110) : Image.asset('sfrown-face.png', width: 110, height: 110),
                            onTap: (){   setState(() {
                              if(bad == false){
                                bad= true;
                              }
                              else{
                                bad=false;
                              }
                            });
                            Firestore.instance.collection("User")
                                .document(CurrentUid).collection('survey').document(TodayDate)
                                .updateData({
                              'question1' : false,
                            },);
                            } ),


                      ],),),
                ],),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),

              // height: 220,
              child: Center(

                child:
                Column(
                  crossAxisAlignment:CrossAxisAlignment.center,

                  children:[
                    Text('스트레스 지수가 어떠신가요?'),
                    SizedBox(height: 30),
                    Slider(
                      value:_sliderValue,
                      inactiveColor:Colors.grey[200],
                      activeColor: Colors.indigo[900],

                      min: 0.0,
                      max: 5.0,

                      onChanged: (newRating) {
                        setState(() {
                          _sliderValue = newRating;
                        }
                        );
                        Firestore.instance.collection("User")
                            .document(CurrentUid).collection('survey').document(TodayDate)
                            .updateData({
                          'question2' : _sliderValue.toInt(),
                        },);
                      },
                      divisions: 5,
                      label: "$_sliderValue",
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text('적음'),
                          SizedBox(width: 180),
                          Text('많음'),
                        ],
                      ),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//아침식사
class Question2 extends StatefulWidget {
  Question2({Key key}) : super(key: key);
  @override
  Question2State createState() => new Question2State();
}

class Question2State extends State<Question2> {
  // TODO: Add a variable for Category (104)
  bool _value0 = false;
  bool _value1 = false;
  bool _value2 = false;
  bool _value3 = false;
  bool _value4 = false;
  bool _value5 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
        InkWell(
          child: Container( child: Row( children: [
            IconButton(

              icon: Icon(
                Icons.arrow_back_ios,
              ),
            ),
            Text("뒤로"),

          ],),),
          onTap: () =>  Navigator.of(context).pop()            ,
        ),

        actions: <Widget>[
          InkWell(
              child: Container( child: Row( children: [
                Text("다음"),
                IconButton(

                  icon: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],),),
              onTap: () {         Navigator.of(context)
                  .push( //MaterialPageRoute(builder: (context) =>DetailPage()),);
                  MaterialPageRoute<void>(

                    //builder: (BuildContext context) {
                    builder: (BuildContext context) => Question3(),

                  )
              );}
          ),

        ],
      ),
      body:
      Container(
        padding: EdgeInsets.symmetric(vertical: 35, horizontal: 60),

        child: Center(
          child:
          Column( children:[
            Flexible( flex:1,
              child:
              Text('아침식사는 무엇을 드셨습니까?'),),
            SizedBox(height: 15),
            Column(
              children: [
                Container(child:
                Row(
                    children:[
                      InkWell(child : _value5 == false? Image.asset('food1.png', width: 130, height: 130): Image.asset('select-food1.png', width: 130, height: 130), onTap: (){
                        setState(() {
                          if(_value5 == false){
                            _value5= true;
                          }
                          else{
                            _value5=false;
                          }
                        }
                        );
                        Firestore.instance.collection("User")
                            .document(CurrentUid).collection('survey').document(TodayDate)
                            .updateData({
                          'question3-2' : 1,
                        },);
                      } ),
                      InkWell(child :_value0 == false ? Image.asset('food2.png', width: 130, height: 130) : Image.asset('select-food2.png', width: 130, height: 130), onTap: (){   setState(() {
                        if(_value0 == false){
                          _value0= true;
                        }
                        else{
                          _value0=false;
                        }
                      }
                      );
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question3-1' : 2,
                      },);
                      }
                      ),
                    ]
                ),
                ),
                Container(child:
                Row(
                    children:[
                      InkWell(child :_value1 == false ? Image.asset('food3.png', width: 130, height: 130) : Image.asset('select-food3.png', width: 130, height: 130), onTap: (){   setState(() {
                        if(_value1 == false){
                          _value1= true;
                        }
                        else{
                          _value1=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question3-1' : 3,
                      },);

                      } ),
                      InkWell(child :_value2 == false ? Image.asset('food4.png', width: 130, height: 130) : Image.asset('select-food4.png', width: 130, height: 130), onTap: (){   setState(() {
                        if(_value2 == false){
                          _value2= true;
                        }
                        else{
                          _value2=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question3-1' : 4,
                      },);

                      } ),         ]),),
                Container(child:
                Row(
                    children:[
                      InkWell(child :_value3 == false ? Image.asset('food5.png', width: 130, height: 130) : Image.asset('select-food5.png', width: 130, height: 130), onTap: (){   setState(() {
                        if(_value3 == false){
                          _value3= true;
                        }
                        else{
                          _value3=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question3-1' : 5,
                      },);

                      } ),
                      InkWell(child :_value4 == false ? Image.asset('food6.png', width: 130, height: 130) : Image.asset('select_food6.png', width: 130, height: 130), onTap: (){   setState(() {
                        if(_value4 == false){
                          _value4= true;
                        }
                        else{
                          _value4=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question3-1' : 6,
                      },);

                      } ),
                    ]),),


              ],),
          ],),),),);
  }}

//점심식사
class Question3 extends StatefulWidget {
  Question3({Key key}) : super(key: key);
  @override
  Question3State createState() => new Question3State();
}

class Question3State extends State<Question3> {
  // TODO: Add a variable for Category (104)
  bool _value0 = false;
  bool _value1 = false;
  bool _value2 = false;
  bool _value3 = false;
  bool _value4 = false;
  bool _value5 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
        InkWell(
          child: Container( child: Row( children: [
            IconButton(

              icon: Icon(
                Icons.arrow_back_ios,
              ),
            ),
            Text("뒤로"),

          ],),),
          onTap: () =>  Navigator.of(context).pop()            ,
        ),

        actions: <Widget>[
          InkWell(
              child: Container( child: Row( children: [
                Text("다음"),
                IconButton(

                  icon: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],),),
              onTap: () {         Navigator.of(context)
                  .push( //MaterialPageRoute(builder: (context) =>DetailPage()),);
                  MaterialPageRoute<void>(

                    //builder: (BuildContext context) {
                    builder: (BuildContext context) => Question4(),

                  )
              );}
          ),

        ],
      ),
      body:
      Container(
        padding: EdgeInsets.symmetric(vertical: 35, horizontal: 60),

        child: Center(
          child:
          Column( children:[
            Flexible( flex:1,
              child:
              Text('점심식사는 무엇을 드셨습니까?'),),
            SizedBox(height: 15),
            Column(
              children: [
                Container(child:
                Row(
                    children:[
                      InkWell(child : _value5 == false? Image.asset('food1.png', width: 130, height: 130): Image.asset('select-food1.png', width: 130, height: 130), onTap: (){
                        setState(() {
                          if(_value5 == false){
                            _value5= true;
                          }
                          else{
                            _value5=false;
                          }
                        }
                        );
                        Firestore.instance.collection("User")
                            .document(CurrentUid).collection('survey').document(TodayDate)
                            .updateData({
                          'question3-2' : 1,
                        },);
                      } ),
                      InkWell(child :_value0 == false ? Image.asset('food2.png', width: 130, height: 130) : Image.asset('select-food2.png', width: 130, height: 130), onTap: (){   setState(() {
                        if(_value0 == false){
                          _value0= true;
                        }
                        else{
                          _value0=false;
                        }
                      }
                      );
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question3-2' : 2,
                      },);
                      }
                      ),
                    ]
                ),
                ),
                Container(child:
                Row(
                    children:[
                      InkWell(child :_value1 == false ? Image.asset('food3.png', width: 130, height: 130) : Image.asset('select-food3.png', width: 130, height: 130), onTap: (){   setState(() {
                        if(_value1 == false){
                          _value1= true;
                        }
                        else{
                          _value1=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question3-2' : 3,
                      },);

                      } ),
                      InkWell(child :_value2 == false ? Image.asset('food4.png', width: 130, height: 130) : Image.asset('select-food4.png', width: 130, height: 130), onTap: (){   setState(() {
                        if(_value2 == false){
                          _value2= true;
                        }
                        else{
                          _value2=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question3-2' : 4,
                      },);

                      } ),         ]),),
                Container(child:
                Row(
                    children:[
                      InkWell(child :_value3 == false ? Image.asset('food5.png', width: 130, height: 130) : Image.asset('select-food5.png', width: 130, height: 130), onTap: (){   setState(() {
                        if(_value3 == false){
                          _value3= true;
                        }
                        else{
                          _value3=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question3-2' : 5,
                      },);

                      } ),
                      InkWell(child :_value4 == false ? Image.asset('food6.png', width: 130, height: 130) : Image.asset('select_food6.png', width: 130, height: 130), onTap: (){   setState(() {
                        if(_value4 == false){
                          _value4= true;
                        }
                        else{
                          _value4=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question3-2' : 6,
                      },);

                      } ),
                    ]),),


              ],),
          ],),),),);
  }}

//저녁식사
class Question4 extends StatefulWidget {
  Question4({Key key}) : super(key: key);
  @override
  Question4State createState() => new Question4State();
}

class Question4State extends State<Question4> {
  // TODO: Add a variable for Category (104)
  bool _value0 = false;
  bool _value1 = false;
  bool _value2 = false;
  bool _value3 = false;
  bool _value4 = false;
  bool _value5 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
        InkWell(
          child: Container( child: Row( children: [
            IconButton(

              icon: Icon(
                Icons.arrow_back_ios,
              ),
            ),
            Text("뒤로"),

          ],),),
          onTap: () =>  Navigator.of(context).pop()            ,
        ),

        actions: <Widget>[
          InkWell(
              child: Container( child: Row( children: [
                Text("다음"),
                IconButton(

                  icon: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],),),
              onTap: () {         Navigator.of(context)
                  .push( //MaterialPageRoute(builder: (context) =>DetailPage()),);
                  MaterialPageRoute<void>(

                    //builder: (BuildContext context) {
                    builder: (BuildContext context) => Question5(),

                  )
              );}
          ),

        ],
      ),
      body:
      Container(
        padding: EdgeInsets.symmetric(vertical: 35, horizontal: 60),

        child: Center(
          child:
          Column( children:[
            Flexible( flex:1,
              child:
              Text('저녁식사는 무엇을 드셨습니까?'),),
            SizedBox(height: 15),
            Column(
              children: [
                Container(child:
                Row(
                    children:[
                      InkWell(child : _value5 == false? Image.asset('food1.png', width: 130, height: 130): Image.asset('select-food1.png', width: 130, height: 130), onTap: (){
                        setState(() {
                          if(_value5 == false){
                            _value5= true;
                          }
                          else{
                            _value5=false;
                          }
                        }
                        );
                        Firestore.instance.collection("User")
                            .document(CurrentUid).collection('survey').document(TodayDate)
                            .updateData({
                          'question3-3' : 1,
                        },);
                      } ),
                      InkWell(child :_value0 == false ? Image.asset('food2.png', width: 130, height: 130) : Image.asset('select-food2.png', width: 130, height: 130), onTap: (){   setState(() {
                        if(_value0 == false){
                          _value0= true;
                        }
                        else{
                          _value0=false;
                        }
                      }
                      );
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question3-3' : 2,
                      },);
                      }
                      ),
                    ]
                ),
                ),
                Container(child:
                Row(
                    children:[
                      InkWell(child :_value1 == false ? Image.asset('food3.png', width: 130, height: 130) : Image.asset('select-food3.png', width: 130, height: 130), onTap: (){   setState(() {
                        if(_value1 == false){
                          _value1= true;
                        }
                        else{
                          _value1=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question3-3' : 3,
                      },);

                      } ),
                      InkWell(child :_value2 == false ? Image.asset('food4.png', width: 130, height: 130) : Image.asset('select-food4.png', width: 130, height: 130), onTap: (){   setState(() {
                        if(_value2 == false){
                          _value2= true;
                        }
                        else{
                          _value2=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question3-3' : 4,
                      },);

                      } ),         ]),),
                Container(child:
                Row(
                    children:[
                      InkWell(child :_value3 == false ? Image.asset('food5.png', width: 130, height: 130) : Image.asset('select-food5.png', width: 130, height: 130), onTap: (){   setState(() {
                        if(_value3 == false){
                          _value3= true;
                        }
                        else{
                          _value3=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question3-3' : 5,
                      },);

                      } ),
                      InkWell(child :_value4 == false ? Image.asset('food6.png', width: 130, height: 130) : Image.asset('select_food6.png', width: 130, height: 130), onTap: (){   setState(() {
                        if(_value4 == false){
                          _value4= true;
                        }
                        else{
                          _value4=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question3-3' : 6,
                      },);

                      } ),
                    ]),),


              ],),
          ],),),),);
  }}

class Question5 extends StatefulWidget {
  Question5({Key key}) : super(key: key);
  @override
  Question5State createState() => new Question5State();
}

class Question5State extends State<Question5> {
  // TODO: Add a variable for Category (104)
  bool _value0 = false;
  bool _value1 = false;
  bool _value2 = false;
  bool _value3 = false;
  bool _value4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
        InkWell(
          child: Container( child: Row( children: [
            IconButton(

              icon: Icon(
                Icons.arrow_back_ios,
              ),
            ),
            Text("뒤로"),

          ],),),
          onTap: () =>  Navigator.of(context).pop()            ,
        ),

        actions: <Widget>[
          InkWell(
              child: Container( child: Row( children: [
                Text("다음"),
                IconButton(

                  icon: Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ],),),
              onTap: () {         Navigator.of(context)
                  .push( //MaterialPageRoute(builder: (context) =>DetailPage()),);
                  MaterialPageRoute<void>(

                    //builder: (BuildContext context) {
                    builder: (BuildContext context) => Question6(),

                  )
              );}
          ),

        ],
      ),
      body:
      Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 50),

        child:
        Center(
          child:
          Column(
            crossAxisAlignment:CrossAxisAlignment.center,

            children:[
              Flexible( flex:1,
                child:
                Text('오늘 배변상태는 어떠신가요?'),),
              SizedBox(height: 20),

              Column(
                children: [
                  Center( child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children:[
                      InkWell(child :_value0 == false ? Image.asset('poop1.png',  width: 140, height: 130) :Image.asset('poop1.png',  width: 140, height: 130) , onTap: (){   setState(() {
                        if(_value0 == false){
                          _value0= true;
                        }
                        else{
                          _value0=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question4-1' : 1,
                      },);
                      } ),
                      InkWell(child :_value0 == false ? Image.asset('poop2.jpg',  width: 140, height: 130) :Image.asset('poop2.jpg',  width: 140, height: 130) , onTap: (){   setState(() {
                        if(_value0 == false){
                          _value0= true;
                        }
                        else{
                          _value0=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question4-1' : 2,
                      },);
                      } ),],),),
                  Center( child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children:[
                      InkWell(child :_value0 == false ? Image.asset('poop3.jpg',  width: 140, height: 130) :Image.asset('poop3.jpg',  width: 140, height: 130) , onTap: (){   setState(() {
                        if(_value0 == false){
                          _value0= true;
                        }
                        else{
                          _value0=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question4-1' : 3,
                      },);
                      } ),
                      InkWell(child :_value0 == false ? Image.asset('poop4.jpg',  width: 140, height: 130) :Image.asset('poop4.jpg',  width: 140, height: 130) , onTap: (){   setState(() {
                        if(_value0 == false){
                          _value0= true;
                        }
                        else{
                          _value0=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question4-1' : 4,
                      },);
                      } ),],),),
                  Center(child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children:[
                      InkWell(child :_value0 == false ? Image.asset('poop5.jpg',  width: 140, height: 130) :Image.asset('poop5.jpg',  width: 140, height: 130) , onTap: (){   setState(() {
                        if(_value0 == false){
                          _value0= true;
                        }
                        else{
                          _value0=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question4-1' : 5,
                      },);
                      } ),
                      InkWell(child :_value0 == false ? Image.asset('poop6.jpg',  width: 140, height: 130) :Image.asset('poop6.jpg',  width: 140, height: 130) , onTap: (){   setState(() {
                        if(_value0 == false){
                          _value0= true;
                        }
                        else{
                          _value0=false;
                        }
                      });
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question4-1' : 6,
                      },);
                      } ),],),),

                ],),
            ],),),),);
  }}



class Question6 extends StatefulWidget {
  Question6({Key key}) : super(key: key);
  @override
  Question6State createState() => new Question6State();
}

class Question6State extends State<Question6> {
  // TODO: Add a variable for Category (104)
  double _sliderValue1 = 0.0;
  double _sliderValue2 = 0.0;

  bool good = false;
  bool bad = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
        InkWell(
          child: Container( child: Row( children: [
            IconButton(

              icon: Icon(
                Icons.arrow_back_ios,
              ),
            ),
            Text("뒤로"),

          ],),),
          onTap: () =>  Navigator.of(context).pop()            ,
        ),

        actions: <Widget>[
          InkWell(
            child: Container( child: Row( children: [
              Text("다음"),
              IconButton(

                icon: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            ],),),
            onTap: () {

              Navigator.of(context)
                  .push( //MaterialPageRoute(builder: (context) =>DetailPage()),);
                  MaterialPageRoute<void>(

                    //builder: (BuildContext context) {
                    builder: (BuildContext context) => Question7(),

                  )
              );}     ,
          ),

        ],
      ),
      body:

      Container(
        padding: EdgeInsets.symmetric(vertical: 35, horizontal: 60),

        child:
        Column(
          children:[
            Container(
              padding: EdgeInsets.symmetric(vertical: 40),

              child: Center(
                child:
                Column(
                  crossAxisAlignment:CrossAxisAlignment.center,

                  children:[
                    Text('배변감은 어떠신가요?'),
                    SizedBox(height: 30),
                    Slider(
                      value:_sliderValue1,
                      inactiveColor:Colors.grey[200],
                      activeColor: Colors.indigo[900],

                      min: 0.0,
                      max: 5.0,

                      onChanged: (newRating) {
                        setState(() {
                          _sliderValue1 = newRating;
                        }
                        );
                        Firestore.instance.collection("User")
                            .document(CurrentUid).collection('survey').document(TodayDate)
                            .updateData({
                          'question4-2' : _sliderValue1.toInt(),
                        },);
                      },
                      divisions: 5,
                      label: "$_sliderValue1",
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text('불편함'),
                          SizedBox(width: 180),
                          Text('편함'),
                        ],
                      ),),
                  ],
                ),


              ),),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 40),

              child:

              Column(
                crossAxisAlignment:CrossAxisAlignment.center,

                children:[
                  Text('배변 횟수는 어떠신가요?'),
                  SizedBox(height: 30),
                  Slider(
                    value:_sliderValue2,
                    inactiveColor:Colors.grey[200],
                    activeColor: Colors.indigo[900],

                    min: 0.0,
                    max: 5.0,

                    onChanged: (newRating) {
                      setState(() {
                        _sliderValue2 = newRating;
                      }
                      );
                      Firestore.instance.collection("User")
                          .document(CurrentUid).collection('survey').document(TodayDate)
                          .updateData({
                        'question4-3' : _sliderValue2.toInt(),
                      },);
                    },
                    divisions: 5,
                    label: "$_sliderValue2",
                  ),
                  Container(
                    //  padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text('0번'),
                        SizedBox(width: 200),
                        Text('5번'),
                      ],
                    ),),
                ],
              ),),],),
      ), );
  }}




//흡연여부 수면시간
class Question7 extends StatefulWidget {
  Question7({Key key}) : super(key: key);
  @override
  Question7State createState() => new Question7State();
}

class Question7State extends State<Question7> {
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
          child: Container( child: Row( children: [
            IconButton(

              icon: Icon(
                Icons.arrow_back_ios,
              ),
            ),
            Text("뒤로"),

          ],),),
          onTap: () =>  Navigator.of(context).pop()            ,
        ),

        actions: <Widget>[
          InkWell(
            child: Container( child: Row( children: [
              Text("다음"),
              IconButton(

                icon: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            ],),),
            onTap: () {
              Firestore.instance.collection("User")
                  .document(CurrentUid).collection('survey').document(TodayDate)
                  .updateData({
                'complete' : true,
              },);
              Navigator.pushNamed(context, HomePage.routeName);
            }     ,
          ),

        ],
      ),
      body:
      Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),

        child:
        Column(
          children:[
            Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              //height: 220,
              child:Column(

                crossAxisAlignment:CrossAxisAlignment.center,
                // mainAxisAlignment:MainAxisAlignment.start,


                children:[
                  Text('음주를 하셨습니까?'),
                  SizedBox(height: 12),
                  Center(
                    child:

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        InkWell(
                            child :good == false ? Image.asset('happiness1.png', width: 110, height: 110) : Image.asset('shappiness.png', width: 110, height: 110), onTap: (){   setState(() {
                          if(good == false){
                            good= true;
                          }
                          else{
                            good=false;
                          }
                        });
                        Firestore.instance.collection("User")
                            .document(CurrentUid).collection('survey').document(TodayDate)
                            .updateData({
                          'question5' : true,
                        },);

                        } ),

                        InkWell(
                            child :bad == false ? Image.asset('frown-face1.png', width: 110, height: 110) : Image.asset('sfrown-face.png', width: 110, height: 110), onTap: (){   setState(() {
                          if(bad == false){
                            bad= true;
                          }
                          else{
                            bad=false;
                          }
                        });
                        Firestore.instance.collection("User")
                            .document(CurrentUid).collection('survey').document(TodayDate)
                            .updateData({
                          'question5' : false,
                        },);
                        } ),


                      ],),),
                ],),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 5),

              // height: 220,
              child: Center(

                child:
                Column(
                  crossAxisAlignment:CrossAxisAlignment.center,

                  children:[
                    Text('수면시간은 어떠신가요?'),
                    SizedBox(height: 30),
                    Slider(
                      value:_sliderValue,
                      inactiveColor:Colors.grey[200],
                      activeColor: Colors.indigo[900],

                      min: 0.0,
                      max: 10.0,

                      onChanged: (newRating) {
                        setState(() {
                          _sliderValue = newRating;
                        }

                        );
                        Firestore.instance.collection("User")
                            .document(CurrentUid).collection('survey').document(TodayDate)
                            .updateData({
                          'question6' : _sliderValue.toInt(),
                        },);
                      },
                      divisions: 10,
                      label: "$_sliderValue",
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text('0시간'),
                          SizedBox(width: 205),
                          Text('10시간'),
                        ],
                      ),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }}