class Technique {
  final int id;
  final String nom;
  final String ref;
  final String? grade;
  final String? kw1;
  final String? kw2;
  final String? kw3;
  final String? kw4;
  final String? kw5;
  final num? maitrise;


  Technique({
    required this.id,
    required this.nom,
    required this.ref,
    required this.grade,
    required this.kw1,
    required this.kw2,
    required this.kw3,
    required this.kw4,
    required this.kw5,
    required this.maitrise,
  });

  factory Technique.fromJson(Map<String, dynamic> json) {
    return Technique(
      id: json['id'],
      nom: json['nom'],
      ref: json['ref'],
      grade: json['grade'],
      kw1: json['kw1'],
      kw2: json['kw2'],
      kw3: json['kw3'],
      kw4: json['kw4'],
      kw5: json['kw5'],
      maitrise: json['maitrise'],
    );
  }
}