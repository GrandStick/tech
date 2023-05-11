import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/technique.dart';

//RECUPERER LA LISTE DES TECHNIQUES
Future<List<Technique>> fetchTechniques() async {
  final response = await http.get(Uri.parse('https://self-defense.app/techniques_list'));

  if (response.statusCode == 200) {
    final List<dynamic> techniquesJson = jsonDecode(response.body);
    return techniquesJson.map((json) => Technique.fromJson(json)).toList();
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
    print(gradeList);
    return gradeList;
  } else {
    throw Exception('Failed to fetch grades');
  }
}
