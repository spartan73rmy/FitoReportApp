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
          icon: const Icon(Icons.clear),
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
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return PDFPrinterShare(idReport: 0);
  }

  Widget show(BuildContext context, DataSearch item) {
    return Card(
        color: Colors.white,
        child: Center(
          child: Text(item.productor ?? ''),
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggetionsList = query.isEmpty
        ? <DataSearch>[]
        : busqueda
            .where((p) =>
                (p.productor?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
                (p.lugar?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
                (p.predio?.toLowerCase().contains(query.toLowerCase()) ?? false))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PDFPrinterShare(idReport: suggetionsList[index].idReport ?? 0)),
          );
        },
        leading: const Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
            text: suggetionsList[index].productor ?? '',
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: "\nPredio: ${suggetionsList[index].predio ?? ''}",
                  style: const TextStyle(color: Colors.grey)),
              TextSpan(
                  text: "\nLugar: ${suggetionsList[index].lugar ?? ''}",
                  style: const TextStyle(color: Colors.grey)),
              TextSpan(
                  text: "\nUbicacion: ${suggetionsList[index].ubicacion ?? ''}",
                  style: const TextStyle(color: Colors.grey)),
              TextSpan(
                  text:
                      "\n${suggetionsList[index].fecha.day}/${suggetionsList[index].fecha.month}/${suggetionsList[index].fecha.year}",
                  style: const TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      itemCount: suggetionsList.length,
    );
  }
}
