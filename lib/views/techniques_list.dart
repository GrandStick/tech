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
                    child: VideoPlayer(_controller),
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
          ],
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

class KeywordList extends StatelessWidget {
  final List<Keywords> keywords;

  KeywordList({required this.keywords});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0),
        Text(
          'Mots-clés :',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
        SizedBox(height: 8.0),
        Center(
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: keywords.map((kw) {
              return ElevatedButton(
                onPressed: () {},
                child: Text(kw.kw),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}



class _TechniquesListState extends State<TechniquesList> {
  // La liste complète de toutes les techniques
  late Future<List<Technique>> _futureTechniques;
  // La liste de techniques affichées en fonction du filtre
  List<Technique> _filteredTechniques = [];

  // Le mot-clé actuellement sélectionné pour le filtre
  String? selectedKeyword;

  bool get _isFiltering => selectedKeyword != null;

  List<Keywords> _keywords = [];

  
  

  @override
  void initState() {
    super.initState();
    _futureTechniques = fetchTechniques();
    fetchKeywords().then((keywords) {
      setState(() {
        _keywords = keywords;
      });
    });
    
  }
  
  void _filterTechniques(String keyword) {
      print('Filtering techniques with keyword: $keyword');
      _futureTechniques.then((techniques) {
        setState(() {
          _filteredTechniques = techniques
              .where((technique) =>
                  technique.kw1 == keyword ||
                  technique.kw2 == keyword ||
                  technique.kw3 == keyword ||
                  technique.kw4 == keyword ||
                  technique.kw5 == keyword)
              .toList();
              selectedKeyword = keyword;
        });
      });
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
                  KeywordList(keywords: _keywords), // Ajouter cette ligne pour afficher les mots-clés
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
                                        onPressed: () { _filterTechniques('${technique.kw1}'); }, 
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                        ),
                                        child: Text('${technique.kw1}'),
                                      ),
                                      if (technique.kw2 != null) OutlinedButton(
                                        onPressed: () { _filterTechniques('${technique.kw2}'); }, 
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                        ),
                                        child: Text('${technique.kw2}'),
                                      ),
                                      if (technique.kw3 != null) OutlinedButton(
                                        onPressed: () { _filterTechniques('${technique.kw3}'); }, 
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                        ),
                                        child: Text('${technique.kw3}'),
                                      ),
                                      if (technique.kw4 != null) OutlinedButton(
                                        onPressed: () { _filterTechniques('${technique.kw4}'); }, 
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                        ),
                                        child: Text('${technique.kw4}'),
                                      ),
                                      if (technique.kw5 != null) OutlinedButton(
                                        onPressed: () { _filterTechniques('${technique.kw5}'); }, 
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
            icon: Icon(Icons.shield),
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