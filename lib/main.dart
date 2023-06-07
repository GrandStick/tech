import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/snackbar_manager.dart';
import 'views/parameters_page.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiOverlayStyle;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Retrieve the device's locale
  Locale initialLocale = WidgetsBinding.instance!.window.locale;

  // Set the default language
  Locale systemLocale = initialLocale;
  if (systemLocale == null) {
    systemLocale = Locale('en');
  }

  runApp(MyApp(initialLocale: systemLocale));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;

  const MyApp({Key? key, required this.initialLocale}) : super(key: key);

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
      locale: initialLocale, // Utilisez la langue initiale ici
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.grey[800],
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white,
        ),
      ),
      home: ScaffoldMessenger(
        key: SnackbarManager.scaffoldMessengerKey,
        child: LoginPage(language: initialLocale.languageCode),
      ),
    );
  }
}