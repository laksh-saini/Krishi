import 'package:ai_app/models/grains.dart';
import 'package:ai_app/screens/Products/list_viewIndi.dart';
import 'package:ai_app/screens/authentication/wrapper.dart';
import 'package:ai_app/screens/home/settings.dart';
import 'package:ai_app/services/get_translated.dart';

import 'package:flutter/material.dart';
import 'package:ai_app/services/auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Main_Drawer extends StatefulWidget {
  final Grains grain;
  final bool obtained;

  Main_Drawer({this.grain, this.obtained});
  @override
  _Main_DrawerState createState() => _Main_DrawerState();
}

class _Main_DrawerState extends State<Main_Drawer> {
  bool settings;
  bool loading = false;

  // @override
  // Future<void> initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     getBoolValue();
  //   });
  // }

  Future<void> getBoolValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool('isFarmer');

    settings = boolValue;
    setState(() {
      settings = boolValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: _auth.getName(),
    //     builder: (context, snapshot) {
    //       if (snapshot.data != null) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          children: [
            // ListTile(
            //   leading: Icon(
            //     Icons.shopping_cart,
            //     color: Colors.black,
            //   ),
            //   title: Text('Products'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => TestOnly()),
            //     );
            //   },
            // ),
            ListTile(
              leading: Icon(
                Icons.shopping_cart,
              ),
              title: Text(getTranslated(context, "products")),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListScreenIndi()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
              ),
              title: Text(getTranslated(context, "settings")),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text(getTranslated(context, "logout")),
              onTap: () {
                showAlertDialogSignOut(context);
              },
            ),
            // Consumer<ThemeNotifier>(
            //   builder: (context, notifier, child) => SwitchListTile(
            //     title: Text("Dark Mode"),
            //     secondary: const Icon(Icons.brightness_1),
            //     onChanged: (value) {
            //       notifier.toggleTheme();
            //     },
            //     value: notifier.darkTheme,
            //   ),
            // ),
          ],
        ),
      ),
    );
    //   } else {
    //     return Center(child: CircularProgressIndicator());
    //   }
    // });
  }
}

showAlertDialogSignOut(BuildContext context) {
  final AuthService _auth = AuthService();
  final googleSignin = GoogleSignIn();

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text(getTranslated(context, "cancel"),
        style: TextStyle(color: Colors.redAccent)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text(getTranslated(context, "continue"),
        style: TextStyle(color: Colors.redAccent)),
    onPressed: () async {
      Navigator.of(context).pop();
      await _auth.signOut();
      await googleSignin.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Wrapper()),
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(getTranslated(context, "logout")),
    content: Text(getTranslated(context, 'sure')),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
