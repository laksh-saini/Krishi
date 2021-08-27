import 'dart:ui';

import 'package:ai_app/main.dart';
import 'package:ai_app/screens/Products/languages.dart';
import 'package:ai_app/services/get_translated.dart';
import 'package:ai_app/services/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_drawer.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  CollectionReference ref = FirebaseFirestore.instance.collection('grains');
  void _changeLanguage(Language language) async {
    Locale _temp = await setLocale(language.languageCode);

    MyApp.setLocale(context, _temp);
  }

  var newvalue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: Text(
            getTranslated(context, 'settings'),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
          child: ListView(children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(
                  Icons.admin_panel_settings_outlined,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  getTranslated(context, 'Appearence'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => SwitchListTile(
                title: Text(getTranslated(context, 'dark')),
                onChanged: (value) {
                  notifier.toggleTheme();
                },
                value: notifier.darkTheme,
              ),
            ),
            SizedBox(
              width: 18,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 10, top: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: DropdownButton(
                      onChanged: (Language language) {
                        _changeLanguage(language);
                      },
                      underline: SizedBox(),
                      hint: Text(getTranslated(context, "change")),
                      items: Language.languageList()
                          .map<DropdownMenuItem<Language>>(
                              (lang) => DropdownMenuItem(
                                  value: lang,
                                  child: Row(
                                    children: [Text(lang.name)],
                                  )))
                          .toList()),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  getTranslated(context, 'account'),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 1,
            ),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                showAlertDialogSignOut(context);
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    getTranslated(context, 'logout'),
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  )
                ],
              ),
            )
          ]),
        ));
  }
}
