import 'dart:io';

import 'package:LikeApp/CommonWidgets/pdfPreview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';

class PDFPrinterShare extends StatelessWidget {
  Future savePdf() async {
    String generatedPdfFilePath;

    Future<void> generateExampleDocument() async {
      var htmlContent = """
      <!DOCTYPE html>
      <html>
        <head>
          <style>
          table, th, td {
            border: 1px solid black;
            border-collapse: collapse;
          }
          th, td, p {
            padding: 5px;
            text-align: left;
          }
          </style>
        </head>
        <body>
          <h2>PDF Generated with flutter_html_to_pdf plugin</h2>

          <table style="width:100%">
            <caption>Sample HTML Table</caption>
            <tr>
              <th>Month</th>
              <th>Savings</th>
            </tr>
            <tr>
              <td>January</td>
              <td>100</td>
            </tr>
            <tr>
              <td>February</td>
              <td>50</td>
            </tr>
          </table>

          <p>Image loaded from web</p>
          <img src="https://i.imgur.com/wxaJsXF.png" alt="web-img">
        </body>
      </html>
      """;

      Directory appDocDir = await getApplicationDocumentsDirectory();
      var targetPath = appDocDir.path;
      var targetFileName = "example-pdf";

      var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
          htmlContent, targetPath, targetFileName);
      generatedPdfFilePath = generatedPdfFile.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF"),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "PDF",
              style: TextStyle(fontSize: 34),
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await savePdf();

          Directory documentDirectory =
              await getApplicationDocumentsDirectory();

          String documentPath = documentDirectory.path;

          String fullPath = "$documentPath/report.pdf";

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfPreview(
                        path: fullPath,
                      )));
        },
        child: Icon(Icons.save),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
