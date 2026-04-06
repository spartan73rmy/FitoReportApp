import 'package:flutter/material.dart';

class PdfPreview extends StatelessWidget {
  final String path;

  const PdfPreview({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.picture_as_pdf, size: 64),
            const SizedBox(height: 16),
            Text('PDF: $path'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Abrir'),
            ),
          ],
        ),
      ),
    );
  }
}
