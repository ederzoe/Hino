import 'package:flutter/material.dart';
import 'package:hinos/src/hino.dart';

class VersoModel extends Object {
  String? idHino;
  String? texto;
  int? estrofe;
  int? ordem;
  int? coro;

  VersoModel({this.idHino, this.texto, this.estrofe, this.ordem, this.coro});
}

class HinoPage extends StatefulWidget {
  final String? args;
  const HinoPage({Key? key, this.args}) : super(key: key);

  @override
  State<HinoPage> createState() => _HinoPageState();
}

class _HinoPageState extends State<HinoPage> {
  final dbHelper = DatabaseHelper.instance;
  double fonteTamanho = 24.0;
  String _appBarTitle = 'Título Inicial';
  String idHinoHinoAtual = '';
  bool ehUltimoHino = false;
  bool _isWidgetVisible = true;
  Map<int, List<Map<String, dynamic>>> agrupado = {};

  @override
  void initState() {
    super.initState();
    carregarHino(widget.args ?? '0');
  }

  void avancarHino() {
    String prefixoHino = idHinoHinoAtual.substring(0, 1);
    String numeroHino = idHinoHinoAtual.substring(1);
    if (prefixoHino.isNotEmpty && numeroHino.isNotEmpty) {
      if (!ehUltimoHino) {
        idHinoHinoAtual = prefixoHino + (int.parse(numeroHino) + 1).toString();
        carregarHino(idHinoHinoAtual);
      }
    }
  }

  void retrocederHino() {
    String prefixoHino = idHinoHinoAtual.substring(0, 1);
    String numeroHino = idHinoHinoAtual.substring(1);
    if (prefixoHino.isNotEmpty && numeroHino.isNotEmpty) {
      if (int.parse(numeroHino) > 1) {
        idHinoHinoAtual = prefixoHino + (int.parse(numeroHino) - 1).toString();
        carregarHino(idHinoHinoAtual);
      }
    }
  }

  void mudarTamanhoFonte(bool aumentar) {
    if (aumentar) {
      fonteTamanho++;
    } else {
      fonteTamanho--;
    }

    setState(() {});
  }

  void carregarHino(String id) async {
    final List<Map<String, dynamic>> versos = await dbHelper.getVersos(id);
    agrupado = {};
    if (versos.isNotEmpty) {
      setState(() {
        _appBarTitle =
            versos[0]['IdHino'] + ' ' + versos[0]['Titulo'] ?? 'Carregando...';

        for (var item in versos) {
          final estrofe = item['Estrofe'] as int;
          agrupado.putIfAbsent(estrofe, () => []).add(item);
        }

        idHinoHinoAtual = id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 13, 45, 77),
        foregroundColor: Colors.white,
        title: Text(_appBarTitle),
      ),
      backgroundColor: Color.fromARGB(255, 13, 45, 77),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          agrupado.isEmpty
              ? Text('')
              : Expanded(
                  child: GestureDetector(
                  onTap: () {
                    _isWidgetVisible = !_isWidgetVisible;
                    setState(() {});
                  },
                  child: ListView.builder(
                      itemCount: agrupado.length,
                      itemBuilder: (context, index) {
                        final values = agrupado.values.elementAt(index);
                        final coro = values.first['Coro'] == 1;
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(""),
                              for (var item in values)
                                Text(
                                  "${item['Texto']}",
                                  style: TextStyle(
                                      fontWeight: coro
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: fonteTamanho),
                                  textAlign: TextAlign.left,
                                ),
                            ]);
                      }),
                )),
          Visibility(
              visible: _isWidgetVisible,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: FloatingActionButton(
                              heroTag: null,
                              onPressed: () {
                                mudarTamanhoFonte(false);
                              },
                              backgroundColor: Colors.white,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'A',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '-',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ))),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              mudarTamanhoFonte(true);
                            },
                            backgroundColor: Colors.white,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'A',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '+',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ))),
          Visibility(
              visible: _isWidgetVisible,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              retrocederHino();
                            },
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.navigate_before),
                          )),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              setState(() {
                                // todo
                              });
                            },
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.settings),
                          )),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              avancarHino();
                            },
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.navigate_next),
                          )),
                    ],
                  )))
        ]),
      ),
    );
  }
}
