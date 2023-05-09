import 'package:flutter/material.dart';
import '../models/technique.dart';
import '../services/fetch_techniques.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TechniquesList extends StatefulWidget {
  const TechniquesList({Key? key}) : super(key: key);

  @override
  _TechniquesListState createState() => _TechniquesListState();
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
                            DataCell(Text('${technique.ref.substring(3)}')),
                            DataCell(Text('${technique.nom}')),
                            if (showKeywordsColumn)
                              DataCell(Wrap(
                                spacing: 4.0, // Espacement entre les boutons
                                runSpacing: 4.0, // Espacement entre les lignes de boutons
                                children: [
                                  if (technique.kw1 != null) OutlinedButton(
                                    onPressed: () {}, 
                                    child: Text('${technique.kw1}'),
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                    ),
                                  ),
                                  if (technique.kw2 != null) OutlinedButton(
                                    onPressed: () {}, 
                                    child: Text('${technique.kw2}'),
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                    ),
                                  ),
                                  if (technique.kw3 != null) OutlinedButton(
                                    onPressed: () {}, 
                                    child: Text('${technique.kw3}'),
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                    ),
                                  ),
                                  if (technique.kw4 != null) OutlinedButton(
                                    onPressed: () {}, 
                                    child: Text('${technique.kw4}'),
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                    ),
                                  ),
                                  if (technique.kw5 != null) OutlinedButton(
                                    onPressed: () {}, 
                                    child: Text('${technique.kw5}'),
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4.0)),
                                    ),
                                  ),
                                ],
                              )),
                              DataCell(
                                Container(
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
    );
  }
}