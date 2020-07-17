import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Models/product.dart';
import 'package:flutter/material.dart';
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

  TextEditingController _controller = TextEditingController();
  String inputString = "";
  addProduct(Product product) {
    setState(() {
      products.add(product);
      print(product.name);
    });
  }

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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Agregar Productos"),
                content: TextFormField(
                  controller: _controller,
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Agregar"),
                    onPressed: () {
                      // Navigator.push(
                      //     context, MaterialPageRoute(builder: (context) {}));
                      // Navigator.pop(context, _controller.text);
                    },
                  )
                ],
              );
            },
          ).then((val) {
            Product a = new Product(
              name: val,
              cantity: 3,
              iActive: "Ingrediente activo",
              securityInterval: "25 dias",
            );
            addProduct(a);
            inputString = val;
          });
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
