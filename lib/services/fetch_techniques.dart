import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/technique.dart';

Future<List<Technique>> fetchTechniques() async {
  final response = await http.get(Uri.parse('https://self-defense.app/techniques_list'));

  if (response.statusCode == 200) {
    final List<dynamic> techniquesJson = jsonDecode(response.body);
    return techniquesJson.map((json) => Technique.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch techniques');
  }
}