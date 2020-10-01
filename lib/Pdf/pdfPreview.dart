import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class PdfPreview extends StatelessWidget {
  final String path;

  PdfPreview({this.path});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        title: Text("Reporte PDF"),
      ),
      // primary: false,
      path: path,
    );
  }
}
