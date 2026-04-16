import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewerWidget extends StatefulWidget {
  final String args;

  PdfViewerWidget({Key? key, required this.args}) : super(key: key);

  @override
  _PdfViewerWidgetState createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  late PDFViewController _pdfController;
  String? filePath;

  @override
  void initState() {
    super.initState();
    _loadFromAssets();
  }

  Future<void> _loadFromAssets() async {
    final data = await rootBundle.load('assets/partituras/${widget.args}.pdf');
    final bytes = data.buffer.asUint8List();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${widget.args}');

    await file.writeAsBytes(bytes, flush: true);

    setState(() {
      filePath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Partitura'),
      ),
      body: filePath == null
          ? Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: filePath,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: true,
              //initialPage: 0,
              onPageChanged: (int? page, int? total) {
                print('Page changed to $page of $total');
              },
              onViewCreated: (PDFViewController pdfController) async {
                _pdfController = pdfController;

                final pages = await pdfController.getPageCount();

                print('Total pages: $pages');
              },
              onError: (error) {
                print(error.toString());
              },
              onPageError: (page, error) {
                print('Page $page has an error ${error.toString()}');
              },
            ),
    );
  }
}
