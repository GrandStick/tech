import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/technique.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


//RECUPERER LA LISTE DES TECHNIQUES
/*
Future<List<Technique>> fetchTechniques() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  //final response = await http.get(Uri.parse('http://localhost:3000/techniques_list_app'));
  final response = await http.get(
    Uri.parse('http://localhost:3000/techniques_list_app),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> techniquesJson = jsonDecode(response.body);
    return techniquesJson.map((json) => Technique.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch techniques');
  }
}
*/
//recuper la liste des techniques avec mise en cache.
Future<List<Technique>> fetchTechniques(String language) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  final String? cachedTechniques = prefs.getString('cachedTechniques');
  final String? cachedVersion = prefs.getString('cachedVersion');

  if (cachedTechniques != null && cachedVersion != null) {
    // Les techniques sont en cache, vérifions la version
    final response = await http.head(
      Uri.parse('https://self-defense.app/techniques_list_app?lang=$language'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final String version = response.headers['etag'] ?? '';
      if (version == cachedVersion) {
        // Les techniques sont à jour, renvoyons-les depuis le cache
        final List<dynamic> cachedTechniquesJson = jsonDecode(cachedTechniques);
        return cachedTechniquesJson.map((json) => Technique.fromJson(json)).toList();
      } else {
        // Les techniques ne sont pas à jour, téléchargeons la nouvelle version
        return _downloadAndSaveTechniques(response.headers['etag'], token, language);
      }
    } else {
      // Échec de la vérification de la version, renvoyons les techniques en cache
      final List<dynamic> cachedTechniquesJson = jsonDecode(cachedTechniques);
      return cachedTechniquesJson.map((json) => Technique.fromJson(json)).toList();
    }
  } else {
    // Les techniques ne sont pas en cache, téléchargeons la première version
    return _downloadAndSaveTechniques(null, token, language);
  }
}

Future<List<Technique>> _downloadAndSaveTechniques(String? version, String? token, String language) async {
  final response = await http.get(
    Uri.parse('https://self-defense.app/techniques_list_app?lang=$language'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> techniquesJson = jsonDecode(response.body);
    final List<Technique> techniques = techniquesJson.map((json) => Technique.fromJson(json)).toList();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cachedTechniques', response.body);
    prefs.setString('cachedVersion', version ?? '');

    return techniques;
  } else {
    throw Exception('Failed to fetch techniques');
  }
}

//RECUPERER LA LISTE DES MOTS CLES
Future<List<Keywords>> fetchKeywords(String language) async {
  final response = await http.get(Uri.parse('https://self-defense.app/techniques_kw?lang=$language'));

  if (response.statusCode == 200) {
    final List<dynamic> keywordsJson = jsonDecode(response.body);
    List<Keywords> keywordsList = [];
    for (var keywordJson in keywordsJson) {
      if (keywordJson['kw'] != null) {
        Keywords keyword = Keywords.fromJson(keywordJson);
        keywordsList.add(keyword);
      }
    }
    return keywordsList;
  } else {
    throw Exception('Failed to fetch keywords');
  }
}



// RECUPERER LA LISTE DES GRADES
Future<List<Grade>> fetchGrade(String language) async {
  final response = await http.get(Uri.parse('https://self-defense.app/techniques_grade?lang=$language'));

  if (response.statusCode == 200) {
    final List<dynamic> gradeJson = jsonDecode(response.body);
    List<Grade> gradeList = [];
    for (var grade in gradeJson) {
      if (grade['grade'] != null) {
        Grade gradeObj = Grade.fromJson(grade);
        gradeList.add(gradeObj);
      }
    }
    return gradeList;
  } else {
    throw Exception('Failed to fetch grades');
  }
}
/*
//TEST LOGIN
Future<void> testProtectedRoute() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  
  final response = await http.get(
    Uri.parse('https://self-defense.app/protected'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('Protected route accessed successfully!');
    print(response.body); // Affiche le corps de la réponse dans la console
  } else {
    print('Failed to access protected route');
  }
}
*/