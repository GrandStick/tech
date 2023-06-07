import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/technique.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';


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

  try {
    final response = await http.get(
      Uri.parse('https://self-defense.app/techniques_list_app?lang=$language'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final String version = response.headers['etag'] ?? '';
      if (cachedVersion != null && version == cachedVersion) {
        // Les techniques sont à jour, renvoyons-les depuis le cache
        final List<dynamic> cachedTechniquesJson = jsonDecode(cachedTechniques!);
        return cachedTechniquesJson.map((json) => Technique.fromJson(json)).toList();
      } else {
        // Les techniques ne sont pas à jour, téléchargeons la nouvelle version
        final List<dynamic> techniquesJson = jsonDecode(response.body);
        final List<Technique> techniques = techniquesJson.map((json) => Technique.fromJson(json)).toList();

        prefs.setString('cachedTechniques', response.body);
        prefs.setString('cachedVersion', version);

        return techniques;
      }
    } else if (cachedTechniques != null && cachedVersion != null) {
      // Échec de téléchargement, renvoyons les techniques en cache
      final List<dynamic> cachedTechniquesJson = jsonDecode(cachedTechniques);
      return cachedTechniquesJson.map((json) => Technique.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch techniques');
    }
  } catch (e) {
    if (cachedTechniques != null && cachedVersion != null) {
      // Échec de la connexion, renvoyons les techniques en cache
      final List<dynamic> cachedTechniquesJson = jsonDecode(cachedTechniques);
      return cachedTechniquesJson.map((json) => Technique.fromJson(json)).toList();
    } else {
      throw Exception('Internet connection required');
    }
  }
}

/*
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
*/
Future<List<Keywords>> fetchKeywords(String language) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? cachedKeywords = prefs.getString('cachedKeywords');
  final String cachedLanguage = prefs.getString('cachedLanguage') ?? '';

  try {
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

      prefs.setString('cachedKeywords', response.body);
      prefs.setString('cachedLanguage', language);

      return keywordsList;
    } else if (cachedKeywords != null && cachedLanguage == language) {
      final List<dynamic> cachedKeywordsJson = jsonDecode(cachedKeywords);
      List<Keywords> keywordsList = [];
      for (var keywordJson in cachedKeywordsJson) {
        if (keywordJson['kw'] != null) {
          Keywords keyword = Keywords.fromJson(keywordJson);
          keywordsList.add(keyword);
        }
      }
      return keywordsList;
    } else {
      throw Exception('Failed to fetch keywords');
    }
  } catch (e) {
    if (cachedKeywords != null && cachedLanguage == language) {
      final List<dynamic> cachedKeywordsJson = jsonDecode(cachedKeywords);
      List<Keywords> keywordsList = [];
      for (var keywordJson in cachedKeywordsJson) {
        if (keywordJson['kw'] != null) {
          Keywords keyword = Keywords.fromJson(keywordJson);
          keywordsList.add(keyword);
        }
      }
      return keywordsList;
    } else {
      throw Exception('Internet connection required');
    }
  }
}

// RECUPERER LA LISTE DES GRADES
/*
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
*/
Future<List<Grade>> fetchGrade(String language) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? cachedGrades = prefs.getString('cachedGrades');
  final String cachedLanguage = prefs.getString('cachedLanguage') ?? '';

  try {
    final response = await http.get(Uri.parse('https://self-defense.app/techniques_grade?lang=$language'));

    if (response.statusCode == 200) {
      final List<dynamic> gradesJson = jsonDecode(response.body);
      List<Grade> gradeList = [];
      for (var gradeJson in gradesJson) {
        if (gradeJson['grade'] != null) {
          Grade grade = Grade.fromJson(gradeJson);
          gradeList.add(grade);
        }
      }

      prefs.setString('cachedGrades', response.body);
      prefs.setString('cachedLanguage', language);

      return gradeList;
    } else if (cachedGrades != null && cachedLanguage == language) {
      final List<dynamic> cachedGradesJson = jsonDecode(cachedGrades);
      List<Grade> gradeList = [];
      for (var gradeJson in cachedGradesJson) {
        if (gradeJson['grade'] != null) {
          Grade grade = Grade.fromJson(gradeJson);
          gradeList.add(grade);
        }
      }
      return gradeList;
    } else {
      throw Exception('Failed to fetch grades');
    }
  } catch (e) {
    if (cachedGrades != null && cachedLanguage == language) {
      final List<dynamic> cachedGradesJson = jsonDecode(cachedGrades);
      List<Grade> gradeList = [];
      for (var gradeJson in cachedGradesJson) {
        if (gradeJson['grade'] != null) {
          Grade grade = Grade.fromJson(gradeJson);
          gradeList.add(grade);
        }
      }
      return gradeList;
    } else {
      throw Exception('Internet connection required');
    }
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

//DOWNLOAD ALL VIDEOS


void fetchAndDownloadTechniques() async {
  try {
    // Récupérer la liste des techniques en utilisant la fonction fetchTechniques
    List<Technique> techniques = await fetchTechniques('fr'); // Remplacez 'fr' par la langue souhaitée

    // Appeler la fonction downloadAllVideos avec la liste des techniques
    downloadAllVideos(techniques);
  } catch (e) {
    print('Erreur lors de la récupération des techniques : $e');
  }
}
/*
void downloadAllVideos(List<Technique> techniques) async {
  for (var technique in techniques) {
    await downloadVideo(technique.id, technique.gif);
  }
}
*/
void downloadAllVideos(List<Technique> techniques) async {
  for (var technique in techniques) {
    if (technique.id == 1 || technique.id == 2) {
      await downloadVideo(technique.id, technique.gif);
    }
  }
}


Future<bool> downloadVideo(int id, String gif) async {
  final String videoUrl = 'https://self-defense.app/videos/mp4/$gif.mp4';
  final String videoFileName = '$gif.mp4';
  String videoPath = '';

  // Récupération du chemin du cache depuis les SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? cachedPath = prefs.getString('cachePath');
  print(cachedPath);
  if (cachedPath != null) {
    videoPath = cachedPath;
  } else {
    videoPath = '${(await getApplicationDocumentsDirectory()).path}/$videoFileName';
  }
  videoPath = '${(await getApplicationDocumentsDirectory()).path}/$videoFileName';
  try {
    final HttpClient httpClient = HttpClient();
    final HttpClientRequest request = await httpClient.getUrl(Uri.parse(videoUrl));
    final HttpClientResponse response = await request.close();
    final File file = File(videoPath);
    final IOSink sink = file.openWrite();

    await response.pipe(sink);
    await sink.close();
    httpClient.close();
    print('Vidéo téléchargée : $gif ai répertoire $videoPath');
    return true; // Téléchargement réussi
  } catch (e) {
    print('Erreur lors du téléchargement de la vidéo : $gif');
    return false; // Erreur de téléchargement
  }
}



/*

Future<void> downloadVideo(int id, String gif) async {
  // Logique de téléchargement de la vidéo
 print('Téléchargement de la vidéo : $gif');
}

// Définir la classe Technique ici (avec les propriétés nécessaires)
class Technique_gif {
  final int id;
  final String gif;

  Technique_gif({required this.id, required this.gif});

  // Méthode factory pour la conversion à partir du JSON
  factory Technique_gif.fromJson(Map<String, dynamic> json) {
    return Technique_gif(
      id: json['id'],
      gif: json['gif'],
    );
  }
}
*/