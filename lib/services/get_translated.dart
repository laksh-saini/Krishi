import 'package:flutter/material.dart';
import 'package:ai_app/localization.dart/demo_localiztion.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getTranslated(BuildContext context, String key) {
  return DemoLocalization.of(context).getTranslatedValue(key);
}

const String LANGUAGE_CODE = 'langaugeCode';
Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();

  _prefs.setString(LANGUAGE_CODE, languageCode);

  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  Locale _temp;
  switch (languageCode) {
    case "en":
      _temp = Locale(languageCode, "US");
      break;
    case "hi":
      _temp = Locale(languageCode, "IN");
      break;
    default:
      _temp = Locale('hi', 'IN');
  }
  return _temp;
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LANGUAGE_CODE) ?? "en";
  return _locale(languageCode);
}
