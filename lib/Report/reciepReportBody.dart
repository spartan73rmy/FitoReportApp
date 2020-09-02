import 'package:LikeApp/Report/reciepReportCard.dart';
import 'package:LikeApp/Models/producto.dart';
import 'package:flutter/material.dart';

class ReciepReportBody extends StatefulWidget {
  final List<Producto> allProducts;

  ReciepReportBody(this.allProducts, {Key key}) : super(key: key);

  @override
  _ReciepReportBodyState createState() => _ReciepReportBodyState();
}

class _ReciepReportBodyState extends State<ReciepReportBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ListView.builder(
              itemCount: widget.allProducts.length,
              padding: const EdgeInsets.only(top: 10.0),
              itemBuilder: (context, index) {
                return ReciepReportCard(widget.allProducts[index]);
              })),
    );
  }
}
