import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  final List<String> cities = ["Hola","SomeMore", "Periban", "Los reyes"];

  final List<String> recentCities = ["Hola", "Periban", "Los reyes"];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Card(color:Colors.white,child:Center(child: Text("$query"),));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggetionsList = query.isEmpty
        ? recentCities
        : cities.where((p) => p.contains(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: (){
          showResults(context);
        },
        leading: Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
            text: suggetionsList[index].substring(0, query.length),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: suggetionsList[index].substring(query.length),
                  style: TextStyle(color: Colors.grey))
            ],
          ),
        ),
      ),
      itemCount: suggetionsList.length,
    );

  }
}
