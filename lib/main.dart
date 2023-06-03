import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/snackbar_manager.dart';
import 'views/parameters_page.dart';

void main() {
  Locale initialLocale = Locale('en'); // Langue par défaut
  runApp(MyApp(initialLocale: initialLocale));
}

class MyApp extends StatefulWidget {
  final Locale initialLocale;

  const MyApp({Key? key, required this.initialLocale}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String> _languageFuture;

  @override
  void initState() {
    super.initState();
    _languageFuture = Future.value(widget.initialLocale.languageCode);
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
        Locale('en', ''), // Anglais
        Locale('fr', ''), // Français
      ],
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.grey[800],
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white,
        ),
      ),
      home: ScaffoldMessenger(
        key: SnackbarManager.scaffoldMessengerKey,
        child: LoginPage(language: widget.initialLocale.languageCode),
      ),
    );
  }
}