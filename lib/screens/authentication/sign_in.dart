import 'package:ai_app/screens/authentication/reset.dart';
import 'package:ai_app/screens/home/home.dart';
import 'package:ai_app/services/auth.dart';
import 'package:ai_app/services/get_translated.dart';
import 'package:ai_app/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class _SignInState extends State<SignIn> {
  bool settings;
  bool isLoading = false;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";
  String name = "";

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  void saveBooleanVariableInStorage(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> getBoolValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool('bool');

    setState(() {
      settings = boolValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorMain = Color(0xFF4B53F2);
    return isLoading == true
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              title: Text(getTranslated(context, 'login'),
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
                          validator: (val) => val.isEmpty
                              ? getTranslated(context, 'vals')
                              : null,
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
                          height: 25,
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (val) => val.isEmpty
                              ? getTranslated(context, 'valr')
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              prefixIcon: Icon(Icons.lock, color: ColorMain),
                              hintText: getTranslated(context, 'pass'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 158.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetScreen()),
                              );
                            },
                            child: Text(
                              getTranslated(context, 'f'),
                              textAlign: TextAlign.left,
                              style: TextStyle(color: ColorMain),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Material(
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: ColorMain,
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 15.0),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password, name);

                                  if (result == null) {
                                    setState(() =>
                                        error = "Invalid email or password.");
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                getTranslated(context, 'login'),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 130,
                              height: 1,
                              color: Colors.grey,
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                getTranslated(context, 'or'),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Container(
                              height: 1,
                              width: 140,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        Text(error,
                            style: TextStyle(color: Colors.red, fontSize: 14)),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GoogleAuthButton(
                                onPressed: () async {
                                  try {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await signInWithGoogle();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()),
                                    );
                                    setState(() {
                                      saveBooleanVariableInStorage(
                                          'isFarmer', true);
                                    });

                                    // await getBoolValue();
                                    // print(settings);
                                  } catch (err) {
                                    print(err);
                                  }
                                },
                                iconSize: 15,
                                elevation: 2.0,
                                borderRadius: 5,
                                textStyle: TextStyle(
                                    color: Colors.black, fontSize: 10),
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
                      ]))),
            ));
  }
}

// _signInWithGoogle() async {
//   final GoogleSignInAccount googleUser = await googleSignIn.signIn();
//   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//   final AuthCredential credential = GoogleAuthProvider.credential(
//       idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

//   final User user = (await firebaseAuth.signInWithCredential(credential)).user;
// }
