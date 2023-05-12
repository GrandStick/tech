import 'package:flutter/material.dart';
import '../models/technique.dart';
import '../services/fetch_techniques.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:tech/views/home_page.dart';
import 'package:tech/views/techniques_list.dart';
import 'package:tech/views/account_page.dart';


int _currentIndex = 1;


//PARTIE DETAIL DE LA TECHNIQUE 
class TechniqueDetail extends StatefulWidget {
  final Technique technique;

  const TechniqueDetail({Key? key, required this.technique}) : super(key: key);

  @override
  _TechniqueDetailState createState() => _TechniqueDetailState();
}

class _TechniqueDetailState extends State<TechniqueDetail> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    print('Initializing video player...');
    _controller = VideoPlayerController.network(
      'https://self-defense.app/videos/mp4/${widget.technique.gif}.mp4',
    )
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      })
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _togglePlayback() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _setPlaybackSpeed(double speed) {
    _controller.setPlaybackSpeed(speed);
    setState(() {
      _playbackSpeed = speed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final videoAspectRatio = _controller.value.aspectRatio;
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la technique'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                '${widget.technique.grade} ${widget.technique.ref.substring(3)} - ${widget.technique.nom}',
                style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    )
                  ),
              SizedBox(height: 20),
              Wrap(
                spacing: 4.0, // Espacement entre les boutons
                runSpacing: 4.0, // Espacement entre les lignes de boutons
                children: [
                  if (widget.technique.kw1 != null)
                    OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                      ),
                      child: Text('${widget.technique.kw1}'),
                    ),
                  if (widget.technique.kw2 != null)
                    OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                      ),
                      child: Text('${widget.technique.kw2}'),
                    ),
                  if (widget.technique.kw3 != null)
                    OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                      ),
                      child: Text('${widget.technique.kw3}'),
                    ),
                  if (widget.technique.kw4 != null)
                    OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                      ),
                      child: Text('${widget.technique.kw4}'),
                    ),
                  if (widget.technique.kw5 != null)
                    OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                      ),
                      child: Text('${widget.technique.kw5}'),
                    ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                constraints: BoxConstraints(
                  maxHeight: screenHeight * 0.6,
                  maxWidth: double.infinity,
                ),
                
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: VideoPlayer(_controller)),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.replay,
                              ),
                              onPressed: () {
                                setState(() {
                                  _controller.seekTo(Duration.zero);
                                  _controller.play();
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.play();
                                  }
                                });
                              },
                            ),
                            TextButton(
                              child: Text(
                                _controller.value.playbackSpeed == 1.0 ? "1x" : "${_controller.value.playbackSpeed}x",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _controller.setPlaybackSpeed(_controller.value.playbackSpeed == 1.0 ? 0.5 : 1.0);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Points clés :',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (widget.technique.kp1 != null)
                    ListTile(
                      leading: Icon(Icons.check),
                      title: Text('${widget.technique.kp1}.'),
                    ),
                  if (widget.technique.kp2 != null)
                    ListTile(
                      leading: Icon(Icons.check),
                      title: Text('${widget.technique.kp2}.'),
                    ),
                  if (widget.technique.kp3 != null)
                    ListTile(
                      leading: Icon(Icons.check),
                      title: Text('${widget.technique.kp3}.'),
                    ),
                  if (widget.technique.kp4 != null)
                    ListTile(
                      leading: Icon(Icons.check),
                      title: Text('${widget.technique.kp4}.'),
                    ),
                  if (widget.technique.kp5 != null)
                    ListTile(
                      leading: Icon(Icons.check),
                      title: Text('${widget.technique.kp5}.'),
                    ),
                  if (widget.technique.kp6 != null)
                    ListTile(
                      leading: Icon(Icons.check),
                      title: Text('${widget.technique.kp6}.'),
                    ),
                  if (widget.technique.kp7 != null)
                    ListTile(
                      leading: Icon(Icons.check),
                      title: Text('${widget.technique.kp7}.'),
                    ),
                  if (widget.technique.kp8 != null)
                    ListTile(
                      leading: Icon(Icons.check),
                      title: Text('${widget.technique.kp8}.'),
                    ),
                  if (widget.technique.kp9 != null)
                    ListTile(
                      leading: Icon(Icons.check),
                      title: Text('${widget.technique.kp9}.'),
                    ),
                  if (widget.technique.kp10 != null)
                    ListTile(
                      leading: Icon(Icons.check),
                      title: Text('${widget.technique.kp10}.'),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Maitrise :',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        width: 180, // Largeur souhaitée pour votre cellule
                        child: RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            // TODO: Add your code for updating the rating here
                          },
                        itemSize: 30.0, // Définir la taille des étoiles à 20 pixels
                          ),
                        ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Notes personnelles :',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      maxLines: 5, // Permet à l'utilisateur de saisir plusieurs lignes
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      //controller: _notesController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 245, 245, 245),
                        hintText: 'Entrez vos notes personnelles ici',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    // Créer un bouton de sauvegarde
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          //_saveNotes(_notesController.text);
                        },
                        child: Text('Sauvegarder'),
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






//PARTIE LISTE DE TECHNIQUES

class TechniquesList extends StatefulWidget {
  const TechniquesList({Key? key}) : super(key: key);

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
    });
  }

  void _toggleKWList() {
    setState(() {
      _showKWList = !_showKWList;
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _toggleGradesList,
                child: Text('Grades'),
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: ElevatedButton(
                onPressed: _toggleKWList,
                child: Text('Mots-Clés'),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        // Nouveau champ de recherche
        TextField(
          controller: _searchTextController,
          decoration: InputDecoration(
            hintText: 'Rechercher une technique',
          ),
          onChanged: widget.onSearchTextChanged,
        ),
        SizedBox(height: 8.0),
        if (_showGradesList || _showKWList)
          Column(
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
                        child: Text('Tous'),
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
                        child: Text('Tous'),
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
      ],
    );
  }
}

//LISTE DES GRADES
/*
class GradeListButton extends StatefulWidget {
  final List<Grade> grades;
  final Function(String?) onGradeSelected;

  GradeListButton({required this.grades, required this.onGradeSelected});

  @override
  _GradeListButtonState createState() => _GradeListButtonState();
}

class _GradeListButtonState extends State<GradeListButton> {
  bool _showGradesList = false;

  void _toggleGradesList() {
    setState(() {
      _showGradesList = !_showGradesList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0),
        Row(
          children: [
            ElevatedButton(
              onPressed: _toggleGradesList,
              child: Text('Grades'),
            ),
            Icon(
              _showGradesList ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ],
        ),
        SizedBox(height: 8.0),
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
                  child: Text('Tous'),
                ),
                ...widget.grades
                    .map((grade) {
                      return ElevatedButton(
                        onPressed: () {
                          widget.onGradeSelected(grade.grade);
                          _toggleGradesList();
                        },
                        child: Text(grade.grade),
                      );
                    })
                    .toList(),
              ],
            ),
          ),
      ],
    );
  }
}
*/
//LISTE DES MOTS CLES
/*
class KWListButton extends StatefulWidget {
  final List<Keywords> keywords;
  final Function(String?) onKeywordSelected;

  KWListButton({required this.keywords, required this.onKeywordSelected});

  @override
  _KWListButtonState createState() => _KWListButtonState();
}

class _KWListButtonState extends State<KWListButton> {
  bool _showKWList = false;

  void _toggleKWList() {
    setState(() {
      _showKWList = !_showKWList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0),
        Row(
          children: [
            ElevatedButton(
              onPressed: _toggleKWList,
              child: Text('Mots-Clés'),
            ),
            Icon(
              _showKWList ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ],
        ),
        SizedBox(height: 8.0),
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
                  child: Text('tous'),
                ),
                ...widget.keywords.map((kw) {
                    return ElevatedButton(
                      onPressed: () { 
                        widget.onKeywordSelected(kw.kw);
                        _toggleKWList(); },
                      child: Text(kw.kw),
                    );
                  }).toList(),
              ],
            ),
          ),
      ],
    );
  }
}
*/
//LISTE DES MOTS CLES BU

/*
class KeywordList extends StatefulWidget {
  final List<Keywords> keywords;
  final Function(String?) onKeywordSelected;

  KeywordList({required this.keywords, required this.onKeywordSelected});

  @override
  _KeywordListState createState() => _KeywordListState();
}

class _KeywordListState extends State<KeywordList> {
  bool _showKeywords = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0),
        Wrap(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showKeywords = !_showKeywords;
                });
              },
              child: Text('Mots-clés'),
            ), 
            Icon(
              _showKeywords ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
            SizedBox(width: 8.0),
            _showKeywords ? Center(
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () { widget.onKeywordSelected(null); },
                      child: Text('Tous'),
                    ),
                  ),
                  ...widget.keywords.map((kw) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: () { widget.onKeywordSelected(kw.kw); },
                        child: Text(kw.kw),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ) : SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
*/




class _TechniquesListState extends State<TechniquesList> {
  // La liste complète de toutes les techniques
  late Future<List<Technique>> _futureTechniques;
  // La liste de techniques affichées en fonction du filtre
  List<Technique> _filteredTechniques = [];

  // Le mot-clé actuellement sélectionné pour le filtre
  String? selectedKeyword;
  String? selectedGrade;

  bool get _isFiltering => selectedKeyword != null;

  List<Keywords> _keywords = [];
  List<Grade> _grades = [];

  
  

  @override
  void initState() {
    super.initState();
    _futureTechniques = fetchTechniques();
    fetchKeywords().then((keywords) {
      setState(() {
        _keywords = keywords;
      });
    });
    fetchGrade().then((grades) {
      setState(() {
        _grades = grades;
      });
    });
  }
  
  void filterTechniques(String? keyword) {
    print('Filtering techniques with keyword: $keyword');
    _futureTechniques.then((techniques) {
      setState(() {
        if (keyword == null) {
          // Si aucun mot clé n'est sélectionné, afficher toutes les techniques
          _filteredTechniques = techniques;
        } else {
          // Sinon, filtrer les techniques qui contiennent le mot clé
          _filteredTechniques = techniques.where((technique) {
            // Vérifier si le mot clé correspond à un grade ou à un mot-clé de la technique
            if (technique.grade == keyword || technique.kw1 == keyword || technique.kw2 == keyword || technique.kw3 == keyword || technique.kw4 == keyword || technique.kw5 == keyword) {
              return true;
            }

            // Vérifier si le mot clé est contenu dans le nom de la technique
            final String techniqueNameWithoutAccents = removeDiacritics(technique.nom.toLowerCase());
            final String keywordWithoutAccents = removeDiacritics(keyword.toLowerCase());
            //print(techniqueNameWithoutAccents);
            //print(keywordWithoutAccents);
            return techniqueNameWithoutAccents.contains(keywordWithoutAccents);
            }).toList();
        }

        // Enregistrer le mot clé sélectionné
        selectedKeyword = keyword;
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
        title: Text('Liste des techniques'),
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
                      onSearchTextChanged: filterTechniques,
                    )
                  : CircularProgressIndicator(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DataTable(
                      horizontalMargin: 24,
                      columnSpacing: 10,
                      dataRowHeight: 80.0,
                      columns: <DataColumn>[
                        DataColumn(label: Text('Grade')),
                        DataColumn(label: Text('Réf')),
                        DataColumn(label: Text('Nom')),
                        if (showKeywordsColumn)
                          DataColumn(label: Text('Mots-clés')),
                        DataColumn(label: Text('Maitrise')),
                      ],
                      rows: (_isFiltering ? _filteredTechniques : techniques)
                          .map((technique) => DataRow(cells: [
                                DataCell(Text('${technique.grade}')),
                                DataCell(Text(technique.ref.substring(3))),
                                DataCell(InkWell(
                                   onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        transitionDuration: Duration(milliseconds: 200),
                                        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                                          return TechniqueDetail(technique: technique);
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
                                  child: Text(technique.nom))),
                                if (showKeywordsColumn)
                                  DataCell(Wrap(
                                    spacing: 4.0, // Espacement entre les boutons
                                    runSpacing: 4.0, // Espacement entre les lignes de boutons
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
                                      width: 120, // Largeur souhaitée pour votre cellule
                                      child: RatingBar.builder(
                                        initialRating: 0,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: false,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          // TODO: Add your code for updating the rating here
                                        },
                                        itemSize: 20.0, // Définir la taille des étoiles à 20 pixels
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
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              // Ne faites rien, l'utilisateur est déjà sur la page 'Techniques'
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_kabaddi),
            label: 'techniques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity ),
            label: 'Compte',
            
          ),
        ],
      ),
    );
  }
}