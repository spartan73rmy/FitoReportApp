import 'package:LikeApp/Report/reciepReportCard.dart';
import 'package:LikeApp/Models/product.dart';
import 'package:flutter/material.dart';

class ReciepReportBody extends StatefulWidget {
  final List<Product> allProducts;

  ReciepReportBody(this.allProducts);

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
