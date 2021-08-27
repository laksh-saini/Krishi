import 'package:ai_app/models/user.dart';
import 'package:ai_app/screens/authentication/authenticate.dart';
import 'package:ai_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<IDUser>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
    //return home or authenticate
  }
}
