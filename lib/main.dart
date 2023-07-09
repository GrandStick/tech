import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/snackbar_manager.dart';
//import 'views/parameters_page.dart';
//import 'package:flutter/services.dart' show SystemChrome, SystemUiOverlayStyle;
import 'package:google_fonts/google_fonts.dart';


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
        textTheme: GoogleFonts.patrickHandScTextTheme(
          //OverlockSC, ecode sans sc, anton, bebasneue, !staatliches, roboto, !patrick hand,  !Architectsdaugther
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Colors.white,
          fontSizeFactor: 1.3 // Définir la couleur du texte normal ici
        ),
                  /*
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontFamily: 'Depot'),
            displayMedium: TextStyle(fontFamily: 'Depot'),
            displaySmall: TextStyle(fontFamily: 'Depot'),
            headlineLarge: TextStyle(fontFamily: 'Depot'),
            headlineMedium: TextStyle(fontFamily: 'Depot'),
            headlineSmall: TextStyle(fontFamily: 'Depot'),
            titleLarge: TextStyle( fontFamily: 'Depot' ),
            titleMedium: TextStyle( fontFamily: 'Depot' ),
            titleSmall: TextStyle( fontFamily: 'Depot' ),
            bodyLarge: TextStyle( fontFamily: 'Depot'),
            bodyMedium: TextStyle(fontFamily: 'Depot'),
            labelLarge: TextStyle(fontFamily: 'Depot'),
            labelMedium: TextStyle(fontFamily: 'Depot'),
            labelSmall: TextStyle(fontFamily: 'Depot'),

          ).apply(fontSizeFactor: 1.0),
          */
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