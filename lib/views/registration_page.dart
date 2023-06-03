import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tech/views/login_page.dart';


class RegistrationForm extends StatefulWidget {
  final String language;
  RegistrationForm({required this.language});
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _emailController = TextEditingController();
  final _emailVerController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordVerController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _clubController = TextEditingController();

  String _selectedGrade = '0';
  String _selectedStatut = '';

  @override
  void dispose() {
    _codeController.dispose();
    _emailController.dispose();
    _emailVerController.dispose();
    _passwordController.dispose();
    _passwordVerController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _clubController.dispose();
    super.dispose();
  }

 void _submitForm() {
  if (_formKey.currentState?.validate() ?? false) {
    // Access the form values using the TextEditingController values
    final String code = _codeController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _passwordVerController.text.trim();
    final String firstName = _prenomController.text.trim();
    final String lastName = _nomController.text.trim();
    final String club = _clubController.text.trim();
    final String grade = _selectedGrade;
    final String statut = _selectedStatut;


    // Perform your registration API call here

  
    final String url = 'https://self-defense.app/register_user_app';

    http.post(Uri.parse(url), body: {
      'Code': code,
      'Email': email,
      'Password': password,
      'Password_ver': confirmPassword,
      'Nom': lastName,
      'Prenom': firstName,
      'Club': club,
      'Grade': grade,
      'Statut': statut,
    }).then((response) {
      if (response.statusCode == 200) {
        // Registration successful
        // Handle the response if needed
        print('Registration successful');

         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
           content: Center(child: Text('Inscription réussie', style: TextStyle(color: Colors.white))),
           backgroundColor: Colors.green,
           duration: Duration(seconds: 2),
          ),
        );


        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(language: widget.language)),
          (route) => false,
        );
      } else {
        // Registration failed
        // Handle the error response if needed
        print('Registration failed');
        final errorMessage = json.decode(response.body)['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Center(child: Text(errorMessage, style: TextStyle(color: Colors.white))),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
      }
    }).catchError((error) {
      // Error occurred during registration
      // Handle the error if needed
      print('Error occurred during registration');
      print(error);
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un compte'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Vous devez créer un compte pour accéder au contenu de cette application. Pour vous inscrire vous aurez besoin d\'un code d\'accès qui vous est donné par le gestionnaire de l\'application. Adressez-vous à support@self-defense.app ou à Sébastien pour obtenir un accès.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: 'Code d\'accès*',
                    hintText: 'Code d\'inscription qui vous a été donné pour vous inscrire.',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Veuillez saisir le code d\'accès';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'E-mail*',
                          hintText: 'Votre adresse email',
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Veuillez saisir votre adresse email';
                          }
                          // TODO: Add email validation logic if needed
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _emailVerController,
                        decoration: InputDecoration(
                          labelText: 'Retapez votre adresse email',
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Veuillez retaper votre adresse email';
                          }
                          if (value != _emailController.text) {
                            return 'Les adresses email ne correspondent pas';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe*',
                          hintText: 'Votre mot de passe',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Veuillez saisir votre mot de passe';
                          }
                          // TODO: Add password validation logic if needed
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _passwordVerController,
                        decoration: InputDecoration(
                          labelText: 'Retapez votre mot de passe',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Veuillez retaper votre mot de passe';
                          }
                          if (value != _passwordController.text) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nomController,
                        decoration: InputDecoration(
                          labelText: 'Nom*',
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Veuillez saisir votre nom';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _prenomController,
                        decoration: InputDecoration(
                          labelText: 'Prénom*',
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Veuillez saisir votre prénom';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedGrade,
                        onChanged: (value) {
                          setState(() {
                            _selectedGrade = value!;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: '0',
                            child: Text('Aucun'),
                          ),
                          DropdownMenuItem<String>(
                            value: '1',
                            child: Text('P1'),
                          ),
                          DropdownMenuItem<String>(
                            value: '2',
                            child: Text('P2'),
                          ),
                          DropdownMenuItem<String>(
                            value: '3',
                            child: Text('P3'),
                          ),
                          DropdownMenuItem<String>(
                            value: '4',
                            child: Text('P4'),
                          ),
                          DropdownMenuItem<String>(
                            value: '5',
                            child: Text('P5'),
                          ),
                          DropdownMenuItem<String>(
                            value: '6',
                            child: Text('G1'),
                          ),
                          DropdownMenuItem<String>(
                            value: '7',
                            child: Text('G2'),
                          ),
                          DropdownMenuItem<String>(
                            value: '8',
                            child: Text('G3'),
                          ),
                          DropdownMenuItem<String>(
                            value: '9',
                            child: Text('G4'),
                          ),
                          DropdownMenuItem<String>(
                            value: '10',
                            child: Text('G5'),
                          ),
                          DropdownMenuItem<String>(
                            value: '11',
                            child: Text('E1'),
                          ),
                          DropdownMenuItem<String>(
                            value: '12',
                            child: Text('E2'),
                          ),
                          DropdownMenuItem<String>(
                            value: '13',
                            child: Text('E3'),
                          ),
                          DropdownMenuItem<String>(
                            value: '14',
                            child: Text('E4'),
                          ),
                          DropdownMenuItem<String>(
                            value: '15',
                            child: Text('E5'),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Grade',
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatut,
                        onChanged: (value) {
                          setState(() {
                            _selectedStatut = value!;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: '',
                            child: Text(''),
                          ),
                          DropdownMenuItem<String>(
                            value: 'SDT',
                            child: Text('Self Defense Trainer'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Instructeur',
                            child: Text('Instructeur'),
                          ),
                          // DropdownMenuItem<String>(
                          //   value: 'élève',
                          //   child: Text('Elève'),
                          // ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Statut',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _clubController,
                  decoration: InputDecoration(
                    labelText: 'Club',
                    hintText: 'Votre club principal',
                  ),
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('S\'inscrire'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}