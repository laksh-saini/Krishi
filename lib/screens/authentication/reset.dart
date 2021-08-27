import 'package:ai_app/screens/authentication/splash.dart';
import 'package:ai_app/services/auth.dart';
import 'package:ai_app/services/get_translated.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String error = "";
  @override
  Widget build(BuildContext context) {
    final ColorMain = Color(0xFF4B53F2);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(getTranslated(context, 'r'),
            style: Theme.of(context).textTheme.headline6),
      ),
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    obscureText: false,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: Icon(Icons.email, color: ColorMain),
                        hintText: getTranslated(context, 'email'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(error,
                      style: TextStyle(color: Colors.red, fontSize: 14)),
                  SizedBox(
                    height: 20,
                  ),
                  Material(
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: ColorMain,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email);
                            } catch (err) {
                              setState(() {
                                error = getTranslated(context, 'vals');
                              });
                            }
                          }
                          _showChoiceDialog(context);
                        },
                        child: Text(
                          getTranslated(context, 'r'),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 0,
                  ),

                  SizedBox(
                    width: 10,
                  ),
                  // RaisedButton.icon(
                  //     color: Colors.white,
                  //     onPressed: () async {
                  //       dynamic result = await _auth.signInAnon();
                  //       if (result == null) {
                  //         print('error signing in');
                  //       } else {
                  //         print('signed in');
                  //         print(result.uid);
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(builder: (context) => Home()),
                  //         );
                  //       }
                  //     },
                  //     icon: Icon(Icons.person_add_alt_1_outlined),
                  //     label: Text(
                  //       "Sign in as a guest",
                  //       style: TextStyle(fontSize: 10),
                  //     ))
                ]),
              ))),
    );
  }
}

Future _showChoiceDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(new Radius.circular(9.0)),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(getTranslated(context, 'ok')),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Splash()),
                      );
                    },
                    child: Text(getTranslated(context, 'done')))
                // Divider(
                //   height: 1,
                //   color: Color(0xFF4B53F2),
                // ),
              ],
            ),
          ),
        );
      });
}
