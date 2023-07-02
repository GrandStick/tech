import 'package:flutter/material.dart';
import 'package:tech/views/account_page.dart';
import 'package:tech/views/techniques_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context).home),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/images/smartkm.png',
                  width: 300.0, // Réglez la largeur en fonction de vos besoins
                  height: 200.0, // Réglez la hauteur en fonction de vos besoins
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  AppLocalizations.of(context).home_text1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  AppLocalizations.of(context).home_text2,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  AppLocalizations.of(context).home_text3,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppLocalizations.of(context).home_text4),
                    Text(AppLocalizations.of(context).home_text5),
                    Text(AppLocalizations.of(context).home_text6),
                    Text(AppLocalizations.of(context).home_text7),
                    Text(AppLocalizations.of(context).home_text8),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  AppLocalizations.of(context).home_text9,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  AppLocalizations.of(context).home_text10,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (int index) {
        switch (index) {
          case 0:
            // Ne faites rien, l'utilisateur est déjà sur la page 'Home'
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return TechniquesList(language: AppLocalizations.of(context).lang);
                },
                transitionsBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation, Widget child) {
                  if (index > _currentIndex) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  } else if (index < _currentIndex) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(-1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  } else {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  }
                },
              ),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return AccountPage();
                },
                transitionsBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation, Widget child) {
                  if (index > _currentIndex) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  } else if (index < _currentIndex) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(-1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  } else {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  }
                },
              ),
            );
            break;
        }
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: AppLocalizations.of(context).home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_kabaddi),
          label: AppLocalizations.of(context).techniques,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: AppLocalizations.of(context).account,
        ),
      ],
    ),
    );
  }
}