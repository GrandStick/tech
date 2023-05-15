import 'package:flutter/material.dart';
import 'package:tech/views/account_page.dart';
import 'package:tech/views/techniques_list.dart';

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
        title: const Text('Acceuil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Bienvenue sur l\'application Self-defense . app.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Cette application a été développée afin d\'offrir aux instructeurs de la fédération SMART Krav Maga une base de données de techniques.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'La base de données est faite selon le canvas SMART Krav Maga et comprend pour chaque technique :',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('- une vidéo'),
                  Text('- les mots-clés'),
                  Text('- les points clés'),
                  Text('- la possibilité d\'encoder votre niveau de maîtrise'),
                  Text('- la possibilité d\'encoder vos notes personnelles'),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Un système de mots-clés, de tri et de recherche vous permet de classer les techniques.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Créez un compte pour accéder à la liste des techniques.',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
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
                  return TechniquesList();
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
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_kabaddi),
          label: 'techniques',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.perm_identity),
          label: 'Compte',
        ),
      ],
    ),
    );
  }
}