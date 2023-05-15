import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/technique.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

Future<List<Technique>>  fetchTechniques() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  
  final response = await http.get(
    Uri.parse('https://self-defense.app/techniques_list_app'),
    headers: <String, String>{
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> techniquesJson = jsonDecode(response.body);
    return techniquesJson.map((json) => Technique.fromJson(json)).toList();
    print(response.body); // Affiche le corps de la réponse dans la console
  } else {
    throw Exception('Failed to fetch techniques');
  }
}

//RECUPERER LA LISTE DES MOTS CLES
Future<List<Keywords>> fetchKeywords() async {
  final response = await http.get(Uri.parse('https://self-defense.app/techniques_kw?lang=fr'));

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
Future<List<Grade>> fetchGrade() async {
  final response = await http.get(Uri.parse('https://self-defense.app/techniques_grade'));

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