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

  Future<Product> createDialog(BuildContext context) {
    List<TextEditingController> _controller = [
      new TextEditingController(),
      new TextEditingController(),
      new TextEditingController(),
      new TextEditingController(),
      new TextEditingController(),
    ];

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(left: 25, right: 25),
          title: Center(child: Text("Agregar Producto")),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Container(
            height: 200,
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _controller[0],
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'Cantidad',
                        hintText: 'Cantidad',
                        icon: const Icon(Icons.ac_unit),
                        labelStyle: TextStyle(
                            decorationStyle: TextDecorationStyle.solid)),
                  ),
                  TextField(
                    controller: _controller[1],
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'Producto',
                        hintText: 'Producto',
                        //filled: true,
                        icon: const Icon(Icons.ac_unit),
                        labelStyle: TextStyle(
                            decorationStyle: TextDecorationStyle.solid)),
                  ),
                  TextField(
                    controller: _controller[2],
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'Ingrediente Activo',
                        hintText: 'Ingrediente Activo',
                        //filled: true,
                        icon: const Icon(Icons.ac_unit),
                        labelStyle: TextStyle(
                            decorationStyle: TextDecorationStyle.solid)),
                  ),
                  TextField(
                    controller: _controller[3],
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'Concentracion (%)',
                        hintText: 'Concentracion',
                        //filled: true,
                        icon: const Icon(Icons.ac_unit),
                        labelStyle: TextStyle(
                            decorationStyle: TextDecorationStyle.solid)),
                  ),
                  TextField(
                    controller: _controller[4],
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: 'Intervalo (Dias)',
                        hintText: 'Intervalo de seguridad',
                        //filled: true,
                        icon: const Icon(Icons.ac_unit),
                        labelStyle: TextStyle(
                            decorationStyle: TextDecorationStyle.solid)),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Agregar"),
              onPressed: () {
                Product newProduct = new Product(
                    cantity: int.parse(_controller[0].text.toString()),
                    name: _controller[1].text.toString(),
                    iActive: _controller[2].text.toString(),
                    concentration: _controller[3].text.toString(),
                    securityInterval: _controller[4].text.toString());
                Navigator.pop(context, newProduct);
              },
            )
          ],
        );
      },
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
