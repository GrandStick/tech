class Technique {
  final int id;
  final String nom;
  final String ref;
  final String gif;
  final String? grade;
  final String? kw1;
  final String? kw2;
  final String? kw3;
  final String? kw4;
  final String? kw5;
  double? maitrise;
  final String? kp1;
  final String? kp2;
  final String? kp3;
  final String? kp4;
  final String? kp5;
  final String? kp6;
  final String? kp7;
  final String? kp8;
  final String? kp9;
  final String? kp10;
  String? notes;
  final List<String> keywords;
  //final String nameWithoutAccents;
  


  Technique({
    required this.id,
    required this.nom,
    required this.ref,
    required this.gif,
    required this.grade,
    required this.kw1,
    required this.kw2,
    required this.kw3,
    required this.kw4,
    required this.kw5,
    required this.maitrise,
    required this.kp1,
    required this.kp2,
    required this.kp3,
    required this.kp4,
    required this.kp5,
    required this.kp6,
    required this.kp7,
    required this.kp8,
    required this.kp9,
    required this.kp10,
    required this.notes,
    required this.keywords,
   // required this.nameWithoutAccents,
  });

    String get nameWithoutAccents => removeDiacritics(nom.toLowerCase());

  bool matchesKeyword(String keyword) {
    final keywordWithoutAccents = removeDiacritics(keyword.toLowerCase());
    return nameWithoutAccents.contains(keywordWithoutAccents);
  }



  factory Technique.fromJson(Map<String, dynamic> json) {
    return Technique(
      id: json['id'],
      nom: json['nom'],
      ref: json['ref'],
      gif: json['gif'],
      grade: json['grade'],
      kw1: json['kw1'],
      kw2: json['kw2'],
      kw3: json['kw3'],
      kw4: json['kw4'],
      kw5: json['kw5'],
      maitrise: json['maitrise'] != null ? double.parse(json['maitrise']) : null,
      kp1: json['kp1'],
      kp2: json['kp2'],
      kp3: json['kp3'],
      kp4: json['kp4'],
      kp5: json['kp5'],
      kp6: json['kp6'],
      kp7: json['kp7'],
      kp8: json['kp8'],
      kp9: json['kp9'],
      kp10: json['kp10'],
      notes: json['notes'],
      keywords: [
      json['kw1'],
      json['kw2'],
      json['kw3'],
      json['kw4'],
      json['kw5'],
      json['grade'],
      // Add more keywords if necessary
    ].where((kw) => kw != null).toList().cast<String>(),
      //nameWithoutAccents: json['nameWithoutAccents'],
      
    );
  }
}

//index des techniques et mots clés poura optimiser la recherche
class KeywordIndex {
  Map<String, List<Technique>> index = {};

  void buildIndex(List<Technique> techniques) {
  for (var technique in techniques) {
    addTechniqueToIndex(technique);
    addKeywordsFromTechniqueName(technique);
  }
}

void addKeywordsFromTechniqueName(Technique technique) {
  final words = technique.nom.split(' '); // Divisez le nom de la technique en mots

  for (var word in words) {
    final keywordWithoutAccents = removeDiacritics(word.toLowerCase());

    if (index.containsKey(keywordWithoutAccents)) {
      index[keywordWithoutAccents]!.add(technique);
    } else {
      index[keywordWithoutAccents] = [technique];
    }
  }
}

  void addTechniqueToIndex(Technique technique) {
    for (var keyword in technique.keywords) {
      final keywordWithoutAccents = removeDiacritics(keyword.toLowerCase());
      if (index.containsKey(keywordWithoutAccents)) {
        index[keywordWithoutAccents]!.add(technique);
      } else {
        index[keywordWithoutAccents] = [technique];
      }
      print('add to indexindex[keywordWithoutAccents]');
    print(index[keywordWithoutAccents]);
    }
  }

  List<Technique>? getTechniquesForKeyword(String keyword) {
    final keywordWithoutAccents = removeDiacritics(keyword.toLowerCase());
    print('keywordWithoutAccents');
    print(keywordWithoutAccents);
    
      print('index[keywordWithoutAccents]');
      print(index[keywordWithoutAccents]);
    return index[keywordWithoutAccents];
  }
}

//RENDRE INSENSIBLE AUX ACCENTS
String removeDiacritics(String str) {
  final Map<String, String> charMap = {
    'À': 'A',
    'Á': 'A',
    'Â': 'A',
    'Ã': 'A',
    'Ä': 'A',
    'Å': 'A',
    'à': 'a',
    'á': 'a',
    'â': 'a',
    'ã': 'a',
    'ä': 'a',
    'å': 'a',
    'È': 'E',
    'É': 'E',
    'Ê': 'E',
    'Ë': 'E',
    'è': 'e',
    'é': 'e',
    'ê': 'e',
    'ë': 'e',
    // Add all the accented characters you want to take into account
  };

  return str.replaceAllMapped(
      RegExp('[${charMap.keys.join()}]'),
      (Match m) => charMap[m.group(0)]!,
  );
}

List<Technique> filterTechniquesByKeywords(List<Technique> techniques, List<String> keywords) {
  return techniques.where((technique) => 
    keywords.any((keyword) => 
      technique.kw1?.toLowerCase().contains(keyword.toLowerCase()) == true ||
      technique.kw2?.toLowerCase().contains(keyword.toLowerCase()) == true ||
      technique.kw3?.toLowerCase().contains(keyword.toLowerCase()) == true ||
      technique.kw4?.toLowerCase().contains(keyword.toLowerCase()) == true ||
      technique.kw5?.toLowerCase().contains(keyword.toLowerCase()) == true
    )
  ).toList();
}

class Keywords {
  final String kw;
 
  Keywords({
    required this.kw,
  });

  factory Keywords.fromJson(Map<String, dynamic> json) {
    return Keywords(
      kw: json['kw'],
    );
  }
}

class Grade {
  final String grade;
  final String grade_n;
 
  Grade({
    required this.grade,
    required this.grade_n,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      grade: json['grade'],
      grade_n: json['grade_n'],
    );
  }
}
