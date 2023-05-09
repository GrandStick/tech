import 'package:flutter/material.dart';
import '../models/technique.dart';
import '../services/fetch_techniques.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

int _currentIndex = 0;

class TechniquesList extends StatefulWidget {
  const TechniquesList({Key? key}) : super(key: key);

  @override
  _TechniquesListState createState() => _TechniquesListState();
}

class TechniqueDetail extends StatelessWidget {
  final Technique technique;

  const TechniqueDetail({Key? key, required this.technique}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la technique'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nom de la technique : ${technique.nom}'),
            Text('Référence : ${technique.ref}'),
            // Ajoutez d'autres détails de la technique ici
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