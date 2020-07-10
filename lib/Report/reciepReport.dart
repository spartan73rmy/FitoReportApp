import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Models/product.dart';
import 'package:flutter/material.dart';
import 'reciepReportBody.dart';

class ReciepReport extends StatefulWidget {
  static ReportData data;
  ReciepReport(ReportData data);

  @override
  _ReciepReportState createState() => _ReciepReportState();
}

class _ReciepReportState extends State<ReciepReport> {
  List<Product> products = new List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: ReciepReportBody(products),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => {AddReport()}),
          // );
        },
      ),
    );
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
