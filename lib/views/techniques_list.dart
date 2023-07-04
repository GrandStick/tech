import 'package:flutter/material.dart';
import '../models/technique.dart';
import '../services/fetch_techniques.dart';
import 'package:better_player/better_player.dart';
import 'package:tech/views/home_page.dart';
import 'package:tech/views/account_page.dart';
import 'package:tech/views/parameters_page.dart'; 
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; 
import '../models/rating_bar.dart';






//PARTIE LISTE DE TECHNIQUES

class TechniquesList extends StatefulWidget {
 final String language;
  const TechniquesList({Key? key, required this.language}) : super(key: key);
  

  @override
  _TechniquesListState createState() => _TechniquesListState();
}


//PARTIE FILTRE GRADES ET MOTS CLES


class FilterButtons extends StatefulWidget {
  final List<Grade> grades;
  final List<Keywords> keywords;
  final Function(String?) onGradeSelected;
  final Function(String?) onKeywordSelected;
  final Function(String?) onSearchTextChanged; // Nouvelle fonction callback


  FilterButtons({
    required this.grades,
    required this.keywords,
    required this.onGradeSelected,
    required this.onKeywordSelected,
    required this.onSearchTextChanged, // Nouvel argument

  });

  @override
  _FilterButtonsState createState() => _FilterButtonsState();
}

class _FilterButtonsState extends State<FilterButtons> {
  bool _showGradesList = false;
  bool _showKWList = false;
  late TextEditingController _searchTextController; // Nouveau champ de texte



  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }


  void _toggleGradesList() {
    setState(() {
      _showGradesList = !_showGradesList;
      _showKWList = false; //  pour fermer la liste des grades
    });
  }

  void _toggleKWList() {
    setState(() {
      _showKWList = !_showKWList;
      _showGradesList = false; //  pour fermer la liste des grades

    });
  }

  void _filterTechniques() {
    widget.onSearchTextChanged(_searchTextController.text.trim()); // appeler la fonction de rappel avec le texte filtré
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0),
        // Nouveau champ de recherche
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchTextController,
            onChanged: widget.onSearchTextChanged,
            style: TextStyle(
              color: Colors.black,
              backgroundColor: Colors.white,
              fontSize: 16.0,
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).tech_search,
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _toggleGradesList,
                  child: Text(AppLocalizations.of(context).grade),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: _toggleKWList,
                  child: Text(AppLocalizations.of(context).keywords),
                ),
              ),
            ],
          ),
        ),
        
        

        SizedBox(height: 8.0),
        if (_showGradesList || _showKWList)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (_showGradesList)
                  Center(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            widget.onGradeSelected(null);
                            _toggleGradesList();
                          },
                          child: Text(AppLocalizations.of(context).all),
                        ),
                        ...widget.grades
                            .map(
                              (grade) => ElevatedButton(
                                onPressed: () {
                                  widget.onGradeSelected(grade.grade);
                                  _toggleGradesList();
                                },
                                child: Text(grade.grade),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                if (_showKWList)
                  Center(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            widget.onKeywordSelected(null);
                            _toggleKWList();
                          },
                          child: Text(AppLocalizations.of(context).all),
                        ),
                        ...widget.keywords
                            .map(
                              (kw) => ElevatedButton(
                                onPressed: () {
                                  widget.onKeywordSelected(kw.kw);
                                  _toggleKWList();
                                },
                                child: Text(kw.kw),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}


class _TechniquesListState extends State<TechniquesList> {

  int _currentIndex = 1;
  
  // La liste complète de toutes les techniques
  late Future<List<Technique>> _futureTechniques;
  // La liste de techniques affichées en fonction du filtre
  List<Technique> filteredTechniques = [];

  // Le mot-clé actuellement sélectionné pour le filtre
  String? selectedKeyword;
  String? selectedGrade;
  String title = 'Techniques';

  bool get _isFiltering => selectedKeyword != null;

  bool _sortRefAsc = true;
  bool _sortNameAsc = true;
  bool _sortMasteryAsc = true;
    bool _sortKeywordsAsc = true;
  bool _sortAsc = true;
  int _sortColumnIndex=0;

   

  List<Keywords> _keywords = [];
  List<Grade> _grades = [];
  List<Technique> techniques = []; // Declare an empty list initially
  late KeywordIndex keywordIndex; // Déclarer l'instance de KeywordIndex
  
  
  
  

@override
  void initState() {
    super.initState();
    _futureTechniques = fetchTechniques(widget.language);

    _futureTechniques.then((fetchedTechniques) {
      setState(() {
        techniques = fetchedTechniques;
      });

      keywordIndex = KeywordIndex();
      keywordIndex.buildIndex(fetchedTechniques);
    });

    _futureTechniques.then((_) {
      fetchKeywords(widget.language).then((keywords) {
        setState(() {
          _keywords = keywords;
        });
      });
      fetchGrade(widget.language).then((grades) {
        setState(() {
          _grades = grades;
        });
      });
    });

    filterTechniques('P1');
  }

   // Méthode pour mettre à jour la liste filteredTechniques
  void updateFilteredTechniques(Technique updatedTechnique) {
  setState(() {
    int index = filteredTechniques.indexWhere((technique) => technique.id == updatedTechnique.id);
    if (index != -1) {
      filteredTechniques[index] = updatedTechnique;
      // Mettre à jour les ratings dans filteredTechniques avec la dernière valeur
      filteredTechniques[index].maitrise = updatedTechnique.maitrise;
    }
  });
}

void filterTechniques(String? keyword) {
  print('Filtering techniques with keyword: $keyword');

  _futureTechniques.then((techniques) {
    setState(() {
      if (keyword == null || keyword.isEmpty) {
        // Si aucun mot-clé n'est saisi, afficher toutes les techniques
        filteredTechniques = techniques;
      } else {
        final keywordWithoutAccents = removeDiacritics(keyword.toLowerCase());

        // Rechercher les techniques correspondant au mot-clé depuis l'index
        final techniquesForKeyword = keywordIndex.getTechniquesForKeyword(keywordWithoutAccents);

        if (techniquesForKeyword != null) {
          // Si des techniques sont trouvées, les utiliser comme résultat filtré
          filteredTechniques = techniquesForKeyword;
        } else {
          // Si aucune technique n'est trouvée, effectuer une recherche "en direct"
          filteredTechniques = techniques.where((technique) =>
              technique.nameWithoutAccents.contains(keywordWithoutAccents)).toList();
        }
      }

      // Enregistrer le mot-clé sélectionné
      selectedKeyword = keyword;
      //Changer le titre pour inclure le mot clé
            
      if (selectedKeyword == null) {
        title = AppLocalizations.of(context).tech_all;
      } else {
        title = 'Techniques - $selectedKeyword';
      }
      

    });
  });
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ParametersPage()),
              );
            },
          ),
        ],
      ),
      body: 
      FutureBuilder<List<Technique>>(
        future: _futureTechniques,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Technique> techniques = snapshot.data!;
            bool showKeywordsColumn = MediaQuery.of(context).size.width >= 800;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  _grades != null
                  ? FilterButtons (
                      keywords: _keywords,
                      grades: _grades,
                      onGradeSelected: filterTechniques,
                      onKeywordSelected: filterTechniques,
                      onSearchTextChanged: (String? keyword) => EasyDebounce.debounce(
                        'my-debouncer',
                        Duration(milliseconds: 400),
                        () => filterTechniques(keyword),
                      ),

                    )
                  : CircularProgressIndicator(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DataTable(
                      horizontalMargin: 10,
                      columnSpacing: 5,
                      //dataRowMinHeight: 50.0,
                      //dataRowMaxHeight: 100.0,
                      dataRowHeight: 85.0,
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAsc,                    
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(AppLocalizations.of(context).ref),
                          onSort: (int columnIndex, sortAscending) {
                            setState(() {
                              print('sort_ref');
                              if (columnIndex == _sortColumnIndex) {
                                _sortAsc = _sortRefAsc = sortAscending;
                              } else {
                                _sortColumnIndex = columnIndex;
                                _sortAsc = _sortRefAsc;
                              }
                              filteredTechniques.sort((a, b) {
                                final int gradeA = a.grade_n != null ? int.tryParse(a.grade_n) ?? 0 : 0;
                                final int gradeB = b.grade_n != null ? int.tryParse(b.grade_n) ?? 0 : 0;

                                if (gradeA != gradeB) {
                                  return gradeA.compareTo(gradeB);
                                } else {
                                  return a.ref.compareTo(b.ref);
                                }
                              });

                              if (!_sortAsc) {
                                filteredTechniques = filteredTechniques.reversed.toList();
                              }
                            });
                          },
                        ),
                        DataColumn(
                          label: Text(AppLocalizations.of(context).name),
                          onSort: (columnIndex, sortAscending) {
                            setState(() {
                              print('sort_nom');
                              if (columnIndex == _sortColumnIndex) {
                                _sortAsc = _sortNameAsc = sortAscending;
                              } else {
                                _sortColumnIndex = columnIndex;
                                _sortAsc = _sortNameAsc;
                              }
                              //techniques.sort((a, b) => a.nom.compareTo(b.nom));
                              filteredTechniques.sort((a, b) => a.nom.compareTo(b.nom));
                              if (!_sortAsc) {
                                //techniques = techniques.reversed.toList();
                                filteredTechniques = filteredTechniques.reversed.toList();
                              }
                            });
                          },
                        ),
                        if (showKeywordsColumn)
                          DataColumn(
                            label: Text(AppLocalizations.of(context).keywords),
                            onSort: (columnIndex, sortAscending) {
                              setState(() {
                                print('sort_colomn');
                                if (columnIndex == _sortColumnIndex) {
                                  _sortAsc = _sortKeywordsAsc = sortAscending;
                                } else {
                                  _sortColumnIndex = columnIndex;
                                  _sortAsc = _sortKeywordsAsc;
                                }
                                //techniques.sort((a, b) => (a.kw1 ?? '').compareTo(b.kw1 ?? ''));
                                filteredTechniques.sort((a, b) => (a.kw1 ?? '').compareTo(b.kw1 ?? ''));
                                if (!_sortAsc) {
                                  //techniques = techniques.reversed.toList();
                                  filteredTechniques = filteredTechniques.reversed.toList();
                                }
                              });
                            },
                          ),
                        DataColumn(
                          label: Text(AppLocalizations.of(context).mastery),
                          onSort: (int columnIndex, sortAscending) {
                            setState(() {
                              print('sort_mastery');
                              if (columnIndex == _sortColumnIndex) {
                                _sortAsc = _sortMasteryAsc = sortAscending;
                              } else {
                                _sortColumnIndex = columnIndex;
                                _sortAsc = _sortMasteryAsc;
                              }
                              //techniques.sort((a, b) => (a.maitrise ?? 0.0).compareTo(b.maitrise ?? 0.0));
                              filteredTechniques.sort((a, b) => (a.maitrise ?? 0.0).compareTo(b.maitrise ?? 0.0));
                              if (!_sortAsc) {
                                //techniques = techniques.reversed.toList();
                                filteredTechniques = filteredTechniques.reversed.toList();
                              }
                            });
                          },
                        ),
                      ],
                      rows: (filteredTechniques)
                          .map<DataRow>((technique) => DataRow(cells: [
                                DataCell(OutlinedButton(
                                style:  ButtonStyle(
                                  side: MaterialStateProperty.all(BorderSide(color: Colors.transparent)), // Définir la couleur du contour sur transparent
                                  padding: MaterialStateProperty.all(EdgeInsets.zero), // Supprimer le padding par défaut
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration: Duration(milliseconds: 300),
                                      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                                        return TechniqueDetail(
                                          technique: technique,
                                          filterTechniques: filterTechniques, // Passer la fonction filterTechniques ici pour permettre la mise ç jour de filteredtechnique lors d'une update dans détail
                                          updateFilteredTechniques: updateFilteredTechniques ,//mettre à jour la liste filteredtechniques si modification


                                        );
                                      },
                                      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(1.0, 0.0),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                  child: Align(
                                    alignment: Alignment.centerLeft, // Aligner le texte à gauche
                                    child: Text('${technique.grade} - ${technique.ref.substring(3)}')))),
                                DataCell(OutlinedButton(
                                  style:  ButtonStyle(
                                    side: MaterialStateProperty.all(BorderSide(color: Colors.transparent)), // Définir la couleur du contour sur transparent
                                    padding: MaterialStateProperty.all(EdgeInsets.zero), // Supprimer le padding par défaut
                                  ),
                                   onPressed: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        transitionDuration: Duration(milliseconds: 300),
                                        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                                          return TechniqueDetail(
                                            technique: technique,
                                            filterTechniques: filterTechniques, // Passer la fonction filterTechniques ici
                                            updateFilteredTechniques: updateFilteredTechniques ,


                                          );
                                        },
                                        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(1.0, 0.0),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 0),
                                    child: Align(
                                      alignment: Alignment.centerLeft, // Aligner le texte à gauche
                                      child: Text(technique.nom,
                                        style: TextStyle(
                                          fontSize:16 ,
                                          ),
                                        ),
                                    ),
                                  )
                                )
                              ),
                                if (showKeywordsColumn)
                                  DataCell(Wrap(
                                    spacing: 4.0, // Espacement entre les boutons
                                    runSpacing: -8.0, // Espacement entre les lignes de boutons
                                    children: [
                                      if (technique.kw1 != null) OutlinedButton(
                                        onPressed: () { filterTechniques('${technique.kw1}'); }, 
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                        ),
                                        child: Text('${technique.kw1}'),
                                      ),
                                      if (technique.kw2 != null) OutlinedButton(
                                        onPressed: () { filterTechniques('${technique.kw2}'); }, 
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                        ),
                                        child: Text('${technique.kw2}'),
                                      ),
                                      if (technique.kw3 != null) OutlinedButton(
                                        onPressed: () { filterTechniques('${technique.kw3}'); }, 
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                        ),
                                        child: Text('${technique.kw3}'),
                                      ),
                                      if (technique.kw4 != null) OutlinedButton(
                                        onPressed: () { filterTechniques('${technique.kw4}'); }, 
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                        ),
                                        child: Text('${technique.kw4}'),
                                      ),
                                      if (technique.kw5 != null) OutlinedButton(
                                        onPressed: () { filterTechniques('${technique.kw5}'); }, 
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                        ),
                                        child: Text('${technique.kw5}'),
                                      ),
                                    ],
                                  )),
                                  DataCell(
                                    SizedBox(
                                      width: 60, // Largeur souhaitée pour votre cellule
                                      child: 
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: CustomRatingBar(
                                          initialRating: technique.maitrise ?? 0.0,
                                          barWidth: 8,  
                                          barHeight: 7,  
                                          onRatingUpdate: (rating) async {
                                            setState(() {
                                              technique.maitrise = rating;
                                            });
                                      
                                            // Récupération du token depuis les préférences partagées
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            final String? token = prefs.getString('token');
                                      
                                            if (token != null) {
                                              // Envoie de la requête POST au serveur Node.js
                                              Uri url = Uri.parse('https://self-defense.app/save_maitrise');
                                              final response = await http.post(
                                                url,
                                                headers: {
                                                  'Authorization': 'Bearer $token',
                                                },
                                                body: {
                                                  'technique_ref': technique.ref,
                                                  'maitrise': rating.toString(),
                                                },
                                              );
                                      
                                              if (response.statusCode == 200) {
                                                // Le serveur a répondu avec succès
                                                print('Changement de rating enregistré avec succès');
                                                
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Center(child: Text(AppLocalizations.of(context).success_rating, style: TextStyle(color: Colors.white))),
                                                    backgroundColor: Colors.green,
                                                    duration: Duration(seconds: 2),
                                                  ),
                                                );
                                              } else {
                                                // Une erreur s'est produite lors de la requête
                                                print('Erreur lors de l\'enregistrement du changement de rating');
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Center(child: Text(AppLocalizations.of(context).error_save, style: TextStyle(color: Colors.white))),
                                                    backgroundColor: Colors.red,
                                                    duration: Duration(seconds: 2),
                                                  ),
                                                );
                                                  
                                              }
                                            } else {
                                              // Le token n'est pas disponible dans les préférences partagées
                                              print('Token introuvable dans les préférences partagées');
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                              ]))
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return HomePage();
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
          case 1:
            // Ne faites rien, l'utilisateur est déjà sur la page 'Techniques'
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
          label: AppLocalizations.of(context).home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_kabaddi),
          label: AppLocalizations.of(context).techniques,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: AppLocalizations.of(context).account,
        ),
      ],
    ),
    );
  }
}








//-------------------------------------------------------------------------








//PARTIE DETAIL DE LA TECHNIQUE 
class TechniqueDetail extends StatefulWidget {
  final Technique technique;
  final Function(String?) filterTechniques; // Ajoutez cette propriété
  final Function(Technique) updateFilteredTechniques;

  
  


  TechniqueDetail({
    Key? key,
    required this.technique,
    required this.filterTechniques, 
    required this.updateFilteredTechniques,

  }) : super(key: key);

  @override
  _TechniqueDetailState createState() => _TechniqueDetailState();
}

class _TechniqueDetailState extends State<TechniqueDetail> {
  late BetterPlayerController _betterPlayerController;
  bool _isPlaying = true;
  double _playbackSpeed = 1.0;
  double? selectedRating = 0;
  TextEditingController _notesController = TextEditingController();
  // Déclarer un TextEditingController
  TextEditingController ratingTextController = TextEditingController();
  // Fonction pour obtenir le texte personnalisé en fonction du niveau de maîtrise
    String getMasteryText(double rating) {
      if (rating == 1.0) {
        return AppLocalizations.of(context).mastery_text_1;
      } else if (rating == 2.0) {
        return AppLocalizations.of(context).mastery_text_2;
      } else if (rating == 3.0) {
        return AppLocalizations.of(context).mastery_text_3;
      } else if (rating == 4.0) {
        return AppLocalizations.of(context).mastery_text_4;
      } else if (rating == 5.0) {
        return AppLocalizations.of(context).mastery_text_5;
      } else {
        return AppLocalizations.of(context).mastery_text_null;
      }
    }


  @override
  void initState() {
    super.initState();
    selectedRating = widget.technique.maitrise?.toDouble() ?? 0.0;
    _notesController.text = widget.technique.notes == null ? "" : widget.technique.notes!;

    final String videoUrl = 'https://self-defense.app/videos/mp4/${widget.technique.gif}.mp4';
    final String videoCacheKey = 'cachedVideo_${widget.technique.gif}.mp4';
    

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoPlay: true, // Activation de l'autoplay
        looping: true, // Activation de l'autoloop
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControlsOnInitialize: false, // Masquer les contrôles à l'ouverture
        ),
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        videoUrl,
        cacheConfiguration: BetterPlayerCacheConfiguration(
          useCache: true,
          key: videoCacheKey,
          preCacheSize: 100 * 1024 * 1024, // Taille du cache en octets (ici 100 Mo)
          maxCacheSize: 500 * 1024 * 1024, // Taille maximale du cache en octets (ici 500 Mo)
        ),
      ),
    );
    _betterPlayerController.setVolume(0); // Désactivation du son (muted)
    _betterPlayerController.play();
  }



  @override
  void dispose() {
    super.dispose();
    _betterPlayerController.dispose();
  }

  void _togglePlayback() {
    if (_isPlaying) {
      _betterPlayerController.pause();
    } else {
      _betterPlayerController.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _setPlaybackSpeed(double speed) {
    _betterPlayerController.setSpeed(speed);
    setState(() {
      _playbackSpeed = speed;
    });
  }


 
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tech_detail),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '${widget.technique.nom}',
                    style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        )
                      ),
                ),
              ),
               SizedBox(height: 0),
               Text(
                '${widget.technique.grade} - ${widget.technique.ref.substring(3)}',
                style: TextStyle(
                      fontSize: 14.0,
                    )
                  ),   
              SizedBox(height: 10),
              Wrap(
                spacing: 4.0, // Espacement entre les boutons
                runSpacing: 4.0, // Espacement entre les lignes de boutons
                children: [
                  if (widget.technique.kw1 != null)
                    OutlinedButton(
                      onPressed: () {
                        widget.filterTechniques(widget.technique.kw1);
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                      ),
                      child: Text('${widget.technique.kw1}'),
                    ),
                  if (widget.technique.kw2 != null)
                    OutlinedButton(
                      onPressed: () {
                        widget.filterTechniques(widget.technique.kw2);
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                      ),
                      child: Text('${widget.technique.kw2}'),
                    ),
                  if (widget.technique.kw3 != null)
                    OutlinedButton(
                      onPressed: () {
                        widget.filterTechniques(widget.technique.kw3);
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                      ),
                      child: Text('${widget.technique.kw3}'),
                    ),
                  if (widget.technique.kw4 != null)
                    OutlinedButton(
                      onPressed: () {
                        widget.filterTechniques(widget.technique.kw4);
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                      ),
                      child: Text('${widget.technique.kw4}'),
                    ),
                  if (widget.technique.kw5 != null)
                    OutlinedButton(
                      onPressed: () {
                        widget.filterTechniques(widget.technique.kw5);
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                      ),
                      child: Text('${widget.technique.kw5}'),
                    ),
                ],
              ),
              const SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: screenHeight * 0.6,
                    maxWidth: double.infinity,
                  ),
                  
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: BetterPlayer(controller: _betterPlayerController),
                        ),
                      ),
                    
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      AppLocalizations.of(context).modus_operandi,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (widget.technique.kp1 != null)
                    ListTile(
                      leading: Text('-'),
                      title: Text('${widget.technique.kp1}.'),
                    ),
                  if (widget.technique.kp2 != null)
                    ListTile(
                      leading: Text('-'),
                      title: Text('${widget.technique.kp2}.'),
                    ),
                  if (widget.technique.kp3 != null)
                    ListTile(
                      leading: Text('-'),
                      title: Text('${widget.technique.kp3}.'),
                    ),
                  if (widget.technique.kp4 != null)
                    ListTile(
                      leading: Text('-'),
                      title: Text('${widget.technique.kp4}.'),
                    ),
                  if (widget.technique.kp5 != null)
                    ListTile(
                      leading: Text('-'),
                      title: Text('${widget.technique.kp5}.'),
                    ),
                  if (widget.technique.kp6 != null)
                    ListTile(
                      leading: Text('-'),
                      title: Text('${widget.technique.kp6}.'),
                    ),
                  if (widget.technique.kp7 != null)
                    ListTile(
                      leading: Text('-'),
                      title: Text('${widget.technique.kp7}.'),
                    ),
                  if (widget.technique.kp8 != null)
                    ListTile(
                      leading: Text('-'),
                      title: Text('${widget.technique.kp8}.'),
                    ),
                  if (widget.technique.kp9 != null)
                    ListTile(
                      leading: Text('-'),
                      title: Text('${widget.technique.kp9}.'),
                    ),
                  if (widget.technique.kp10 != null)
                    ListTile(
                      leading: Text('-'),
                      title: Text('${widget.technique.kp10}.'),
                    ),
                    SizedBox(height: 20),
                    //Titre Niveau de maitrise
                    Center(
                      child: Text(
                        AppLocalizations.of(context).mastery,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //Rating bar pour le niveau de maitrise
                    Center(
                      child: SizedBox(
                        width: 150, // Largeur souhaitée pour votre cellule
                        child: 
                        CustomRatingBar(
                          initialRating: selectedRating ?? 0.0,
                          barWidth: 25,  
                          barHeight: 20,                   
                          onRatingUpdate: (rating) async {
                            setState(() {
                              selectedRating = rating;
                              ratingTextController.text = rating.toString(); // Mettre à jour la valeur du texte
                            });

                            // Récupération du token depuis les préférences partagées
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            final String? token = prefs.getString('token');

                            if (token != null) {
                              // Envoie de la requête POST au serveur Node.js
                              Uri url = Uri.parse('https://self-defense.app/save_maitrise');
                              final response = await http.post(
                                url,
                                headers: {
                                  'Authorization': 'Bearer $token',
                                },
                                body: {
                                  'technique_ref': widget.technique.ref,
                                  'maitrise': rating.toString(),
                                },
                              );

                              if (response.statusCode == 200) {
                                // Le serveur a répondu avec succès
                                print('Changement de rating enregistré avec succès');
                                //Envoyer la modification au widget TechniqueList
                                widget.technique.maitrise = rating;
                                // Différer légèrement l'exécution de la mise à jour de la technique filtrée pour performances
                                Future.delayed(Duration(milliseconds: 300)).then((_) {
                                  widget.updateFilteredTechniques(widget.technique);
                                });
                                //Message indicant le succes de la modification de matrise
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(child: Text(AppLocalizations.of(context).success_rating, style: TextStyle(color: Colors.white))),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                // Une erreur s'est produite lors de la requête
                                print('Erreur lors de l\'enregistrement du changement de rating');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                  content: Center(child: Text(AppLocalizations.of(context).error_save, style: TextStyle(color: Colors.white))),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                  ),
                                 );
                                                
                                
                                  
                              }
                            } else {
                              // Le token n'est pas disponible dans les préférences partagées
                              print('Token introuvable dans les préférences partagées');
                            }
                          },
                          ),
                        ),
                    ),
                    SizedBox(height: 10),
                    // Afficher un texte décrivant le niveau de maitrise
                    Center(
                      child: Text(
                        getMasteryText(selectedRating ?? 0),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        AppLocalizations.of(context).personal_notes,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        maxLines: 5, // Permet à l'utilisateur de saisir plusieurs lignes
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: _notesController, // pass the controller to the TextField
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 245, 245, 245),
                          hintText: AppLocalizations.of(context).personal_notes_hint,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    // Créer un bouton de sauvegarde
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            final String? token = prefs.getString('token');
                      
                            if (token != null) {
                              Uri url = Uri.parse('https://self-defense.app/save_notes_techniques');
                              final response = await http.post(
                                url,
                                headers: {
                                  'Authorization': 'Bearer $token',
                                },
                                body: {
                                  'technique_ref': widget.technique.ref,
                                  'notes': _notesController.text,
                                },
                              );
                      
                              if (response.statusCode == 200) {
                                // Le serveur a répondu avec succès
                                print('Notes personnelles enregistrées avec succès');
                                 setState(() {
                                     // Effectuez ici les opérations nécessaires pour mettre à jour la liste de techniques
                                  // Par exemple, vous pouvez mettre à jour les notes de la technique concernée
                                  widget.technique.notes = _notesController.text;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Center(child: Text(AppLocalizations.of(context).sucess_notes, style: TextStyle(color: Colors.white))),
                                      backgroundColor: Colors.green,
                      
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  });
                              } else {
                                // Une erreur s'est produite lors de la requête
                                print('Erreur lors de l\'enregistrement des notes personnelles');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(child: Text(AppLocalizations.of(context).error_save, style: TextStyle(color: Colors.white))),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            } else {
                              // Le token n'est pas disponible dans les préférences partagées
                              print('Token introuvable dans les préférences partagées');
                            }
                          },
                          child: Text(AppLocalizations.of(context).save),
                        ),
                      ),
                    ),
                ],
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}

