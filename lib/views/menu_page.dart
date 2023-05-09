import 'package:flutter/material.dart';
import 'package:tech/views/home_page.dart';
import 'package:tech/views/techniques_list.dart';
import 'package:tech/views/account_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Accueil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            title: const Text('Liste des techniques'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TechniquesList()),
              );
            },
          ),
          ListTile(
            title: const Text('Mon compte'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}