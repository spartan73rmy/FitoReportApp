import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Models/product.dart';
import 'package:flutter/material.dart';
import 'createDialog.dart';
import 'reciepReportBody.dart';

class ReciepReport extends StatefulWidget {
  static ReportData data;
  ReciepReport(ReportData data, {Key key}) : super(key: key);

  @override
  _ReciepReportState createState() => _ReciepReportState();
}

class _ReciepReportState extends State<ReciepReport> {
  List<Product> products = <Product>[
    new Product(
        name: "Cal",
        cantity: 100,
        iActive: "Calcio",
        concentration: "50",
        securityInterval: "10"),
    new Product(
        name: "Cal",
        cantity: 10,
        iActive: "Calcio",
        concentration: "10",
        securityInterval: "10"),
    new Product(
        name: "Cal",
        cantity: 20,
        iActive: "Calcio",
        concentration: "80",
        securityInterval: "10"),
    new Product(
        name: "Cal",
        cantity: 10000,
        iActive: "Calcio",
        concentration: "10",
        securityInterval: "10"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: ReciepReportBody(products),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: () {
          createDialog(context).then((value) {
            addProduct(value);
          });
        },
      ),
    );
  }

  addProduct(Product product) {
    setState(() {
      products.add(product);
      print(product.cantity);
    });
  }
}

// @override
//   Widget build(BuildContext ctxt) {
//     return StreamBuilder(
//       stream: Firestore.instance.collection('baby').snapshots(),
//       builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
//         var documents = snapshot.data?.documents ?? [];
//         var baby =
//             documents.map((snapshot) => BabyData.from(snapshot)).toList();
//         return BabyPage(baby);
//       },
//     );
//   }
