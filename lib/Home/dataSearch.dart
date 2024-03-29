import '../Models/dataSearch.dart';
import '../Pdf/pdfPrinter.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate<String> {
  Search(this.busqueda);
  final List<DataSearch> busqueda;

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
    return PDFPrinterShare();
  }

  Widget show(BuildContext context, DataSearch item) {
    return Card(
        color: Colors.white,
        child: Center(
          child: Text(item.productor),
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggetionsList = query.isEmpty
        ? new List<DataSearch>()
        : busqueda
            .where((p) =>
                p.productor.toLowerCase().contains(query.toLowerCase()) ||
                p.lugar.toLowerCase().contains(query.toLowerCase()) ||
                p.predio.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PDFPrinterShare(idReport: suggetionsList[index].idReport)),
          );
        },
        leading: Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
            text: suggetionsList[index].productor,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: "\nPredio: ${suggetionsList[index].predio}",
                  style: TextStyle(color: Colors.grey)),
              TextSpan(
                  text: "\nLugar: ${suggetionsList[index].lugar}",
                  style: TextStyle(color: Colors.grey)),
              TextSpan(
                  text: "\nUbicacion: ${suggetionsList[index].ubicacion}",
                  style: TextStyle(color: Colors.grey)),
              TextSpan(
                  text:
                      "\n${suggetionsList[index].fecha.day}/${suggetionsList[index].fecha.month}/${suggetionsList[index].fecha.year}",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      itemCount: suggetionsList.length,
    );
  }
}
