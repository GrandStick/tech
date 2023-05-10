import 'package:flutter/material.dart';
import '../models/technique.dart';
import '../services/fetch_techniques.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:video_player/video_player.dart';

int _currentIndex = 0;

class TechniquesList extends StatefulWidget {
  const TechniquesList({Key? key}) : super(key: key);

  @override
  _TechniquesListState createState() => _TechniquesListState();
}

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la technique'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('${widget.technique.grade} ${widget.technique.ref.substring(3)} - ${widget.technique.nom}'),
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
                maxHeight: 400,
                maxWidth: double.infinity,
              ),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.setPlaybackSpeed(_controller.value.playbackSpeed == 1.0 ? 0.5 : 1.0);
                          });
                        },
                      ),
                    ],
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

class _TechniquesListState extends State<TechniquesList> {
  late Future<List<Technique>> _futureTechniques;

  @override
  void initState() {
    super.initState();
    _futureTechniques = fetchTechniques();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des techniques'),
      ),
      body: FutureBuilder<List<Technique>>(
        future: _futureTechniques,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Technique> techniques = snapshot.data!;
            bool showKeywordsColumn = MediaQuery.of(context).size.width >= 800;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
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
                  rows: techniques
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
                                    onPressed: () {}, 
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                    ),
                                    child: Text('${technique.kw1}'),
                                  ),
                                  if (technique.kw2 != null) OutlinedButton(
                                    onPressed: () {}, 
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                    ),
                                    child: Text('${technique.kw2}'),
                                  ),
                                  if (technique.kw3 != null) OutlinedButton(
                                    onPressed: () {}, 
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                    ),
                                    child: Text('${technique.kw3}'),
                                  ),
                                  if (technique.kw4 != null) OutlinedButton(
                                    onPressed: () {}, 
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                    ),
                                    child: Text('${technique.kw4}'),
                                  ),
                                  if (technique.kw5 != null) OutlinedButton(
                                    onPressed: () {}, 
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
              Navigator.of(context).pushNamed('/home');
              break;
            case 1:
              // Ne faites rien, l'utilisateur est déjà sur la page 'Techniques'
              break;
            case 2:
              Navigator.of(context).pushNamed('/compte');
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