import 'package:flutter/material.dart';
import 'package:tech/views/home_page.dart';
import 'package:tech/views/techniques_list.dart';
import 'package:tech/views/parameters_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _currentIndex = 2;

  final _codeController = TextEditingController();
  final _emailController = TextEditingController();
  final _emailVerController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordVerController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _clubController = TextEditingController();
  final _gradeController = TextEditingController();
  final _statutController = TextEditingController();


  void _Addsomething() {
    // Ajoutez votre logique de déconnexion ici
    // Par exemple, effacer la session utilisateur ou le jeton d'authentification
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
            title: Text(AppLocalizations.of(context).email),
            subtitle: TextFormField(
              controller: _emailController,
            ),
          ),
          
          ListTile(
            title: Text(AppLocalizations.of(context).password),
            subtitle: TextFormField(
              controller: _passwordController,
            ),
          ),
          
          ListTile(
            title: Text(AppLocalizations.of(context).surname),
            subtitle: TextFormField(
              controller: _nomController,
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).name),
            subtitle: TextFormField(
              controller: _prenomController,
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).club),
            subtitle: TextFormField(
              controller: _clubController,
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).password_change),
            // Code pour le premier ListTile
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).my_subscription),
            // Code pour le deuxième ListTile
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
              // Ne rien faire, l'utilisateur se trouve déjà sur la page 'Account'
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