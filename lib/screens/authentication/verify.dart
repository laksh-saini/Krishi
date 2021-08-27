import 'dart:async';

import 'package:ai_app/screens/home/home.dart';
import 'package:ai_app/services/get_translated.dart';
import 'package:ai_app/services/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _auth = FirebaseAuth.instance;
  User user;
  Timer timer;
  @override
  void initState() {
    user = _auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslated(context, 'home_page'),
          style: Theme.of(context).textTheme.headline6,
        ),
        leading: Container(),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 250,
            ),
            SpinKitRipple(
              color: Colors.blueAccent,
              size: 50.0,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              getTranslated(context, "do"),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = _auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    }
  }
}
