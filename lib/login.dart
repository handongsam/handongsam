
import 'package:flutter/material.dart';
import 'package:handongsam/home.dart';
import 'create_account.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_inform.dart';
import 'home_after.dart';

String CurrentUid = "";
final FirebaseAuth _auth = FirebaseAuth.instance;

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
        child:
        SafeArea(
          child: Column(
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
              RaisedButton(
                child: Text('GOOGLE Sign In'),
                onPressed: () async{
                  CurrentUid = await _signIn();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly',],
  );

  Future<String> _signIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: gSA.accessToken,
        idToken: gSA.idToken,
      );
      AuthResult authResult = await _auth.signInWithCredential(credential);
      if (authResult.additionalUserInfo.isNewUser) {
        final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
        print("new user :  " + user.uid + user.displayName);

        Navigator.pushNamed(context, CreateAccount.routeName);
        return user.uid;
      }
      else {
        print("befoer use : " + authResult.user.uid);
        Firestore.instance.collection('User').document(authResult.user.uid).get().then((DocumentSnapshot ds) async{
          var userRecord = UserRecord.fromSnapshot(ds);
          DateTime endTime = userRecord.endTime.toDate();
          DateTime nowTime = DateTime.now();
          if(endTime.year == nowTime.year && endTime.month==nowTime.month && endTime.day==nowTime.day){
            Navigator.pushNamed(context, FinalHome.routeName);
          }else{
            Navigator.pushNamed(context, HomePage.routeName);
          }
        });

        return authResult.user.uid;
      }
    } catch (e) {
      print(e);
    }
  }

//
//  Future<String> _makeUserID(BuildContext context) async{
//    FirebaseUser userId = await FirebaseAuth.instance.currentUser();
//    uid = userId.uid;
//    return uid;
//  }

}