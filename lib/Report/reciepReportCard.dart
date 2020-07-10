import 'package:LikeApp/Models/product.dart';
import 'package:flutter/material.dart';

class ReciepReportCard extends StatefulWidget {
  final Product data;
  ReciepReportCard(this.data);

  @override
  _ReciepReportCardState createState() => _ReciepReportCardState(data);
}

class _ReciepReportCardState extends State<ReciepReportCard> {
  Product data;

  _ReciepReportCardState(this.data);

  Widget get reciepCard {
    return new Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
        leading: const Icon(Icons.archive),
        title: Text('The ${data.name} is having:'),
        subtitle: Text('${data.phone} Votes.'),
      ),
      new ButtonTheme.bar(
          // make buttons use the appropriate styles for cards
          child: new ButtonBar(children: <Widget>[
        new FlatButton(
          child: const Text('Editar'),
          onPressed: () {/* ... */},
        ),
        new FlatButton(
          child: const Text('Eliminar'),
          onPressed: () {/* ... */},
        )
      ]))
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ReciepReportCard(data),
    );
  }
}
