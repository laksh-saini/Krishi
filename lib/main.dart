import 'package:ai_app/localization.dart/demo_localiztion.dart';
import 'package:ai_app/models/user.dart';
import 'package:ai_app/screens/authentication/wrapper.dart';
import 'package:ai_app/services/get_translated.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ai_app/services/auth.dart';
import 'package:ai_app/services/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      this._locale = locale;
    });
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
          return StreamProvider<IDUser>.value(
            value: AuthService().user,
            child: _locale == null
                ? CircularProgressIndicator()
                : MaterialApp(
                    theme: notifier.darkTheme ? dark : light,
                    debugShowCheckedModeBanner: false,
                    locale: _locale,
                    supportedLocales: [
                      Locale('en', 'US'),
                      Locale('hi', 'IN'),
                    ],
                    localizationsDelegates: [
                      DemoLocalization.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    localeResolutionCallback: (deviceLocale, supportedLocales) {
                      for (var locale in supportedLocales) {
                        if (locale.languageCode == deviceLocale.languageCode &&
                            locale.countryCode == deviceLocale.countryCode) {
                          return deviceLocale;
                        }
                      }
                    },
                    home: Wrapper(),
                  ),
          );
        }));
  }
}
