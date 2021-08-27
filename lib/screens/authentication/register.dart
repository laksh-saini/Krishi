import 'package:ai_app/screens/authentication/verify.dart';
import 'package:ai_app/screens/home/home.dart';
import 'package:ai_app/services/auth.dart';
import 'package:ai_app/services/get_translated.dart';
import 'package:ai_app/services/loading.dart';

import 'package:flutter/material.dart';

// import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String name = "";
  String error = "";
  bool selectedList = false;
  bool customerlist = false;
  bool loading = false;

  // Future<bool> saveBooleanVariableInStorage(String key, bool value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // var result = await prefs.setBool('isFarmer', true);

  //   // if (result) {
  //   //   print("saved");
  //   // } else {
  //   //   print("not saved");
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    final ColorMain = Color(0xFF4B53F2);
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              title: Text(
                getTranslated(context, 'reg'),
                style: Theme.of(context).textTheme.headline6,
              ),
              elevation: 0.0,
              centerTitle: true,
              actions: [],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            validator: (val) => val.isEmpty
                                ? getTranslated(context, 'valn')
                                : null,
                            obscureText: false,
                            onChanged: (val) {
                              setState(() => name = val);
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                prefixIcon:
                                    Icon(Icons.person, color: ColorMain),
                                hintText: getTranslated(context, 'name'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0))),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          TextFormField(
                            validator: (val) => val.isEmpty
                                ? getTranslated(context, 'vals')
                                : null,
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
                            height: 25,
                          ),
                          TextFormField(
                            validator: (val) => val.length < 6
                                ? getTranslated(context, 'val6')
                                : null,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: ColorMain,
                                ),
                                hintText: getTranslated(context, "pass"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0))),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     InkWell(
                          //       onTap: () async {
                          //         setState(() {
                          //           selectedList = !selectedList;
                          //           customerlist = false;

                          //           saveBooleanVariableInStorage('isFarmer', true);
                          //         });
                          //       },
                          //       child: Container(
                          //         width: 150,
                          //         child: Card(
                          //           color: selectedList == true
                          //               ? Colors.white
                          //               : Colors.grey[50],
                          //           shape: selectedList
                          //               ? RoundedRectangleBorder(
                          //                   side: BorderSide(
                          //                       color: Colors.green, width: 4))
                          //               : null,
                          //           elevation: 10,
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(12.0),
                          //             child: Column(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.spaceAround,
                          //               children: <Widget>[
                          //                 Image.asset(
                          //                   'assets/jj.png',
                          //                   scale: 5.7,
                          //                 ),
                          //                 SizedBox(
                          //                   height: 10,
                          //                 ),
                          //                 Text(
                          //                   'Farmer',
                          //                   style: TextStyle(
                          //                       color: Colors.black, fontSize: 15),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       width: 40,
                          //     ),
                          //     InkWell(
                          //       onTap: () {
                          //         setState(() {
                          //           selectedList = false;
                          //           customerlist = !customerlist;

                          //           saveBooleanVariableInStorage('isFarmer', false);
                          //         });
                          //       },
                          //       child: Container(
                          //         width: 150,
                          //         child: Card(
                          //           color: customerlist == true
                          //               ? Colors.white
                          //               : Colors.grey[50],
                          //           shape: customerlist
                          //               ? RoundedRectangleBorder(
                          //                   side: BorderSide(
                          //                       color: Colors.green, width: 4))
                          //               : null,
                          //           elevation: 10,
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(12.0),
                          //             child: Column(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.spaceAround,
                          //               children: <Widget>[
                          //                 Image.asset(
                          //                   'assets/iop.png',
                          //                 ),
                          //                 SizedBox(
                          //                   height: 10,
                          //                 ),
                          //                 Text(
                          //                   'Customer',
                          //                   style: TextStyle(
                          //                       color: Colors.black, fontSize: 15),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: 10,
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
                                      loading = true;
                                    });
                                    dynamic result = await _auth
                                        .registerWithEmailAndPassword(
                                            email, password, name);
                                    if (result == null) {
                                      setState(() {
                                        error = getTranslated(context, 'vals');
                                        loading = false;
                                      });
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VerifyScreen()),
                                      );
                                    }
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Text(
                                      getTranslated(context, 'reg'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 12,
                          ),
                          Text(error,
                              style: TextStyle(color: Colors.red, fontSize: 14))
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
