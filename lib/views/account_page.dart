import 'package:flutter/material.dart';
import 'package:tech/views/home_page.dart';
import 'package:tech/views/techniques_list.dart';
import 'package:tech/views/login_page.dart'; // Assuming LoginPage is the name of your login page

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _currentIndex = 2;

  void _logout() {
    // Add your logout logic here
    // For example, clearing user session or token

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Compte'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Code for settings button
            },
          ),
        ],
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
                MaterialPageRoute(builder: (context) => TechniquesList()),
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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_kabaddi),
            label: 'techniques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Club',
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