import 'package:flutter/material.dart';
import 'package:tech/views/home_page.dart';
import 'package:tech/views/club_page.dart';
import 'package:tech/views/techniques_list.dart';
import 'package:tech/views/login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ParametersPage extends StatefulWidget {
  @override
  _ParametersPageState createState() => _ParametersPageState();
}

class _ParametersPageState extends State<ParametersPage> {
  int _currentIndex = 2;
  Locale _currentLocale = Locale('en'); // Locale par défaut

  void _logout() async {
    // Add your logout logic here
    // For example, clearing user session or token

    // Clearing user token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(language: AppLocalizations.of(context).lang)),
      (route) => false,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Mes coordonnées'),
            // Code for the first ListTile
          ),
          ListTile(
            title: const Text('Grade'),
            // Code for the second ListTile
          ),
          ListTile(
            title: const Text('Club'),
            // Code for the third ListTile
          ),
          ListTile(
            title: const Text('Langue'),
            // Code for the third ListTile
          ),
          ListTile(
            title: const Text('Télécharger videos'),
            // Code for the third ListTile
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TechniquesList(language: AppLocalizations.of(context).lang)),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ClubPage()),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _logout,
        child: Icon(Icons.logout),
      ),
    );
  }
}