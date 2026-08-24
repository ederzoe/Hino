import 'package:flutter/material.dart';
import 'package:hinos/src/hino.dart';
import 'package:hinos/hino_page.dart';
import 'package:hinos/lista_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _hinos = [];
  final String _letraSelecionada = '';
  String _numeroSelecionado = '';

  Future<void> carregarPesquisa() async {
    final List<Map<String, dynamic>> items =
        await dbHelper.searchById(_numeroSelecionado);
    setState(() {
      _hinos = items;
    });
  }

  void exibir(String id) {
    carregarHino(id);
  }

  Future<void> buscaPorNome(String texto) async {
    if (texto.isNotEmpty && texto.length > 1) {
      final List<Map<String, dynamic>> items3 =
          await dbHelper.searchByText(_usernameController.text);
      setState(() {
        _hinos = items3;
      });
    }
  }

  void carregarHino(String id) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HinoPage(args: id),
      ),
    );
  }

  void carregarLista() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaPage(),
      ),
    );
  }

  void _selecionarNumero(String valor) {
    if (_numeroSelecionado.isEmpty && valor == '0') return;

    if (_numeroSelecionado.length < 3) {
      setState(() {
        _numeroSelecionado += valor;
      });
    }

    carregarPesquisa();
  }

  void _backspace() {
    if (_numeroSelecionado.isNotEmpty) {
      setState(() {
        _numeroSelecionado = _numeroSelecionado.substring(
          0,
          _numeroSelecionado.length - 1,
        );
      });

      carregarPesquisa();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('HINOS'),
      ),
      body: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Column(
          children: [
            _hinos.isEmpty
                ? Expanded(child: Text(""))
                : Expanded(
                    child: ListView.builder(
                      itemCount: _hinos.length,
                      padding: EdgeInsets.all(4),
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            onTap: () => exibir(_hinos[index]['Id']),
                            title: Text(
                                (_hinos[index]['Id'].contains('N')
                                        ? ''
                                        : _hinos[index]['Id']) +
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
                  ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: TextField(
                  controller: _usernameController,
                  onChanged: (text) {
                    buscaPorNome(text);
                  },
                  decoration: InputDecoration(
                      labelText: 'Pesquisa por título ou verso',
                      suffixIcon: _usernameController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _usernameController.clear();
                                setState(() {});
                              },
                              icon: Icon(Icons.cancel, color: Colors.grey))
                          : null),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (!isKeyboard)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(_letraSelecionada,
                              style: Theme.of(context).textTheme.displayMedium),
                          Text(_numeroSelecionado,
                              style: Theme.of(context).textTheme.displayMedium),
                          TextButton(
                            onPressed: () {
                              _backspace();
                            },
                            child: const Icon(Icons.backspace,
                                size: 42, color: Colors.grey),
                          ),
                          SizedBox(width: 40),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.grey,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10), // Padding
                              textStyle: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              carregarLista();
                            },
                            child: const Text(
                              'Exibir todos os hinos',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              _selecionarNumero('1');
                            },
                            child: const Text('1'),
                          ),
                          TextButton(
                            onPressed: () {
                              _selecionarNumero('2');
                            },
                            child: const Text('2'),
                          ),
                          TextButton(
                            onPressed: () {
                              _selecionarNumero('3');
                            },
                            child: const Text('3'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              _selecionarNumero('4');
                            },
                            child: const Text('4'),
                          ),
                          TextButton(
                            onPressed: () {
                              _selecionarNumero('5');
                            },
                            child: const Text('5'),
                          ),
                          TextButton(
                            onPressed: () {
                              _selecionarNumero('6');
                            },
                            child: const Text('6'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              _selecionarNumero('7');
                            },
                            child: const Text('7'),
                          ),
                          TextButton(
                            onPressed: () {
                              _selecionarNumero('8');
                            },
                            child: const Text('8'),
                          ),
                          TextButton(
                            onPressed: () {
                              _selecionarNumero('9');
                            },
                            child: const Text('9'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              _selecionarNumero('0');
                            },
                            child: const Text('0'),
                          ),
                        ],
                      ),
                      Padding(padding: const EdgeInsets.only(bottom: 40))
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
