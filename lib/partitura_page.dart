import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class PartituraWidget extends StatelessWidget {
  final String args;

  const PartituraWidget({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partitura'),
      ),
      body: PdfViewer.asset('assets/partituras/$args.pdf'),
    );
  }
}
