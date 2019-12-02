import 'package:flutter/material.dart';
import 'alarm_inform.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String uid = "";
String product = "";
String name = "";
String phoneNumber = "";
int bodyFatPercentage = 0;
final _nameController = TextEditingController();
final _phoneNumberController = TextEditingController();
final _bodyFatPercentageController = TextEditingController();

class CreateAccount extends StatefulWidget{
  static const routeName = '/createAccountScreen';
  @override
  CreateAccountState createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccount> {
  // TODO: Add a variable for Category (104)
  int maxId = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon : Icon(Icons.arrow_back_ios, color: Colors.black54, size: 18.0,),

          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Center(
          child:const Text(
            '개인정보 입력', style:TextStyle(fontSize: 17.0),
          ),
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon : Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 18.0,),
                onPressed: () async{
                  _setValue();
                  await _makeUserInform(context);

                  for(var i=0; i<14; i++){
                    String documentName = DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days:i))).toString();
                    _makeSurveyDocument(context, documentName);
                  }
                  Navigator.of(context).push( MaterialPageRoute(builder: (context) =>ChooseProduct()));
                },
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: MakeTextFieldList(),
      ),
    );
  }

  void _makeSurveyDocument(BuildContext context, String documentName) async{
    Firestore.instance.collection("User").document(await _makeUserID(context)).collection('survey').document(documentName).setData({
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
      'memo' : ' ',
      'complete' : false,
    },);
  }

  Future<void> _makeUserInform(BuildContext context) async{
    await Firestore.instance.collection('User').document(await _makeUserID(context)).setData(
        {
          'fat' : bodyFatPercentage,
          'name' : name,
          'phone' : phoneNumber,
          'startTime' : DateTime.now(),
          'endTime' : DateTime.now().add(Duration(days:14)),
        });
    Navigator.of(context).pop();
  }

  Future<String> _makeUserID(BuildContext context) async{
    FirebaseUser userId = await FirebaseAuth.instance.currentUser();
    uid = userId.uid;
    return uid;
  }

  _setValue(){
    name = _nameController.text.toString();
    phoneNumber = _phoneNumberController.text.toString();
    bodyFatPercentage = int.parse(_bodyFatPercentageController.text.toString());
  }
}

class MakeTextFieldList extends StatefulWidget{
  @override
  MakeTextFieldListState createState(){
    return MakeTextFieldListState();
  }
}

class MakeTextFieldListState extends State<MakeTextFieldList>{
  Widget build(BuildContext context){
    return ListView(
      children: <Widget>[
        _makeText(context,'이름','Name', false, _nameController,TextInputType.text, name),
        SizedBox(height: 3),
        _makeText(context,'휴대폰번호 뒷자리','Phoen Number', false, _phoneNumberController,TextInputType.text, phoneNumber),
        SizedBox(height: 3),

        _makeText(context,'체지방률(%)','Fat(%)', false, _bodyFatPercentageController,TextInputType.number, bodyFatPercentage),
      ],
    );
  }

  Row _makeText(BuildContext context, String subject, String label, bool flag, TextEditingController controllers, keyboardTypeThis, globalValue){
    return Row(
      children: <Widget>[
        Container(
          width : MediaQuery.of(context).size.height/5,
          margin: const EdgeInsets.only(left:20.0),
          child:Text(subject),
        ),
        Expanded(
          child:_makeTextField(context,label,false ,controllers, TextInputType.text, globalValue),
        ),
      ],
    );
  }

  TextFormField _makeTextField(BuildContext context, String label, bool flag, TextEditingController controllers, keyboardTypeThis, globalValue) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter ' + label;
        }else{
          return null;
        }
      },
      keyboardType: keyboardTypeThis,
      controller: controllers,
      obscureText: flag,
      decoration: InputDecoration(
        filled: false,
        labelText: label,
      ),
    );
  }
}

class ChooseProduct extends StatefulWidget{
  static const routeName = '/chooseProduct';
  @override
  ChooseProductState createState() => ChooseProductState();
}

class ChooseProductState extends State<ChooseProduct> {
  // TODO: Add a variable for Category (104)
  int maxId = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon : Icon(Icons.arrow_back_ios, color: Colors.black54, size: 18.0,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Center(
          child:const Text('제품 선택',style:TextStyle(fontSize: 17.0)),
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon : Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 18.0,),
                onPressed: () {
                  _updateProduct(context, product);
                  Navigator.pushNamed(context, AlarmInform.routeName);
                },
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: MakeImageButton(),
      ),
    );
  }

  Future<void> _updateProduct(BuildContext context, String productName) async{
    await Firestore.instance.collection('User').document(uid).updateData(
        {
          'product' : product,
        });
  }

}

class MakeImageButton extends StatefulWidget{
  static const routeName = '/makeImageButton';
  @override
  MakeImageButtonState createState() => MakeImageButtonState();
}

class MakeImageButtonState extends State<MakeImageButton> {
  // TODO: Add a variable for Category (104)
  int choose = -1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        product=="balance"? MakeProductButton(context,'sbalance.png', 'balance') : MakeProductButton(context,'balance.jpg', 'balance'),
        Divider(),
        product=="intensive"? MakeProductButton(context,'sintensive.png', 'intensive') : MakeProductButton(context,'intensive.jpg', 'intensive'),
      ],
    );
  }

  Widget MakeProductButton(BuildContext context, String imagePath, String productName){
    return Container(
      margin : EdgeInsets.all(10.0),
      height:MediaQuery.of(context).size.height/2.8,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: FlatButton(
        onPressed: () {
          setState(() {
            product = productName;
          });
          //image change
          //Navigator.pushNamed(context, AlarmInform.routeName);
        },
        padding: EdgeInsets.all(0.0),
        child: Image.asset(imagePath),
      ),
    );
  }
}