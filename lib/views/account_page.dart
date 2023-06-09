import 'package:flutter/material.dart';
import 'package:tech/views/home_page.dart';
import 'package:tech/views/techniques_list.dart';
//import 'package:tech/views/login_page.dart'; 
import 'package:tech/views/parameters_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; 
//import 'package:intl/intl.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _currentIndex = 2;

  void _Addsomething() {
    // Add your logout logic here
    // For example, clearing user session or token

   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).account),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ParametersPage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(AppLocalizations.of(context).password_change),
            // Code for the first ListTile
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).club),
            // Code for the second ListTile
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).my_subscription),
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
              // Do nothing, user is already on the 'Account' page
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