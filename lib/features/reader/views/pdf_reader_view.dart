import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfReaderView extends StatelessWidget {
  final String filePath;
  final VoidCallback onToggleControls;

  const PdfReaderView({
    super.key,
    required this.filePath,
    required this.onToggleControls,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(filePath);
    if (!file.existsSync()) {
      return Center(
        child: Text('PDF file not found: $filePath'),
      );
    }

    return GestureDetector(
      onTap: onToggleControls,
      child: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: true,
        backgroundColor: Colors.black,
        onError: (error) {
          debugPrint('PDF error: $error');
        },
      ),
    );
  }
}
