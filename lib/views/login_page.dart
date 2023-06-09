import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech/views/techniques_list.dart';
import '../services/fetch_techniques.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; 
import 'registration_page.dart'; 

class LoginPage extends StatefulWidget {
  final String language;
  LoginPage({required this.language});
  @override
  _LoginPageState createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    //SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      // Un token est enregistré, naviguer vers la page suivante
      //fetchTechniques();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TechniquesList(language: widget.language)),
      );
    }
  }
   // Method to navigate to the registration page
  void navigateToRegistrationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationForm(language: widget.language)), // Create an instance of the registration page class
    );
  }

  Future<void> login(String username, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final http.Response response = await http.post(
        Uri.parse('https://self-defense.app/loginapp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String token = data['token'];
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Naviguer vers une nouvelle page après la connexion réussie
        //fetchTechniques();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TechniquesList(language: widget.language)),
        );
      } else {
        throw Exception(AppLocalizations.of(context).error_login);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).error),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:  Text(AppLocalizations.of(context).close)
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    login(username, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context).login),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration:  InputDecoration(labelText: AppLocalizations.of(context).email),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context).email_hint;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context).password),
                obscureText: true,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context).password_hint;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(AppLocalizations.of(context).login),
              ),
              const SizedBox(height: 24),
              Text(AppLocalizations.of(context).no_account),
              TextButton(
                onPressed: navigateToRegistrationPage,
                child: Text(AppLocalizations.of(context).register), // Customize the button label as needed
              ),
            ],
          ),
        ),
      ),
    );
  }
}