
import 'package:flutter/material.dart';
import 'create_account.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginPage extends StatefulWidget {
  static const routeName = '/loginScreen';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: new EdgeInsets.symmetric(vertical: 160.0),
        child :
        SafeArea(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 80.0),
                    Column(
                      children: <Widget>[
                        //Image.asset('assets/diamond.png'),
                        SizedBox(height: 16.0),
                        Text('HandongSam'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child : Container(
                  padding: EdgeInsets.all(30.0),
                  child: MakeTextFieldList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MakeTextFieldList extends StatefulWidget{

  @override
  MakeTextFieldListState createState(){
    return MakeTextFieldListState();
  }
}

class MakeTextFieldListState extends State<MakeTextFieldList>{
  String id = "";
  String pw = "";
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  Widget build(BuildContext context){
    return ListView(
      children: <Widget>[
        _makeText(context, 'ID',false ,_idController, TextInputType.text, id),
        _makeText(context,'Password', false, _passwordController,TextInputType.number, pw),
        Row(
          children: <Widget>[
            SizedBox(width: MediaQuery.of(context).size.width/2.7),
            FlatButton(
              child: Text('SiGN IN'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 20.0),
            FlatButton(
              child: Text('SiGN UP', style:TextStyle(color:Colors.blueAccent)),
              onPressed: () {
                Navigator.pushNamed(context, CreateAccount.routeName);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _makeText(BuildContext context, String label, bool flag, TextEditingController controllers, keyboardTypeThis, globalValue){
    return Row(
      children: <Widget>[
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
        }
        return null;
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