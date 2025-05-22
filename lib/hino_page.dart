import 'package:flutter/material.dart';
import 'package:flutter_application_sqlite/src/hino.dart';

class HinoPage extends StatefulWidget {
  final String? args;
  const HinoPage({Key? key, this.args}) : super(key: key);

  @override
  State<HinoPage> createState() => _HinoPageState();
}

class _HinoPageState extends State<HinoPage> {
  final dbHelper = DatabaseHelper.instance;
  String _appBarTitle = 'Título Inicial';
  List<Map<String, dynamic>> _versos = [];

  @override
  void initState() {
    super.initState();
    carregarHino(widget.args ?? '0');
  }

  void carregarHino(String id) async {
    final List<Map<String, dynamic>> versos = await dbHelper.getVersos(id);

    if (versos.isNotEmpty) {
      setState(() {
        _appBarTitle =
            versos[0]['IdHino'] + ' ' + versos[0]['Titulo'] ?? 'Carregando...';
        _versos = versos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_appBarTitle),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              _versos.isEmpty
                  ? Text('')
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _versos.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Text(_versos[index]['Texto']),
                          );
                        },
                      ),
                    ),
            ])));
  }
}
