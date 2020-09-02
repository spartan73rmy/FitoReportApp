import 'package:LikeApp/Report/reciepReportCard.dart';
import 'package:LikeApp/Models/product.dart';
import 'package:flutter/material.dart';

class ListTempReportBody extends StatefulWidget {
  final List<Producto> allProducts;

  ListTempReportBody(this.allProducts, {Key key}) : super(key: key);

  @override
  _ListTempReportBodyState createState() => _ListTempReportBodyState();
}

class _ListTempReportBodyState extends State<ListTempReportBody> {
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
