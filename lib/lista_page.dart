import 'package:flutter/material.dart';
import 'package:hinos/src/hino.dart';
import 'package:hinos/hino_page.dart';

class ListaPage extends StatefulWidget {
  final String? args;
  const ListaPage({Key? key, this.args}) : super(key: key);

  @override
  State<ListaPage> createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  final dbHelper = DatabaseHelper.instance;
  String appBarTitle = 'Lista';
  bool isWidgetVisible = true;
  bool ehUltimoHino = false;
  String idHinoHinoAtual = '';

  double fonteTamanho = 24.0;
  Color fonteCor = Colors.black;
  Color fundoCor = Colors.white;
  List<Map<String, dynamic>> _hinos = [];

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    carregarLista('H');
  }

  Future<void> carregarLista(String categoria) async {
    final List<Map<String, dynamic>> items =
        await dbHelper.searchByCategoria(categoria);

    setState(() {
      _hinos = items;
    });
  }

  void exibir(String id) {
    carregarHino(id);
  }

  void carregarHino(String id) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HinoPage(args: id),
      ),
    );
  }

  void _selecionarLetra(String valor) {
    carregarLista(valor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      backgroundColor: fundoCor,
      body: Align(
          alignment: FractionalOffset.bottomCenter,
          child: Column(
            children: [
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        _selecionarLetra('H');
                        scrollController.jumpTo(0.0);
                      },
                      child: const Text('H'),
                    ),
                    TextButton(
                      onPressed: () {
                        _selecionarLetra('C');
                        scrollController.jumpTo(0.0);
                      },
                      child: const Text('C'),
                    ),
                    TextButton(
                      onPressed: () {
                        _selecionarLetra('S');
                        scrollController.jumpTo(0.0);
                      },
                      child: const Text('S'),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     _selecionarLetra('N');
                    //     scrollController.jumpTo(0.0);
                    //   },
                    //   child: const Text('Novos'),
                    // ),
                  ],
                ),
              ),
              _hinos.isEmpty
                  ? Expanded(child: Text(""))
                  : Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: _hinos.length,
                        padding: EdgeInsets.all(4),
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () => exibir(_hinos[index]['Id']),
                              title: Text(
                                  _hinos[index]['Id'] +
                                      ' ' +
                                      _hinos[index]['Titulo'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                              subtitle: Text(
                                _hinos[index]['Texto'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 12),
                              ),
                              trailing: Icon(Icons.arrow_forward, size: 32),
                            ),
                          );
                        },
                      ),
                    )
            ],
          )),
    );
  }
}
