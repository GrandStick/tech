import 'package:flutter/material.dart';
//import 'views/techniques_list.dart';
import 'views/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/snackbar_manager.dart';
import 'views/parameters_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _currentLocale = Locale('fr'); // Default locale

  void _changeLanguage(Locale locale) {
    setState(() {
      _currentLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krav Maga Techniques',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('fr', ''), // French
      ],
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.grey[800],
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white,
        ),
      ),
      home: ScaffoldMessenger(
        key: SnackbarManager.scaffoldMessengerKey,
        child: LoginPage(),
      ),
    );
  }
}