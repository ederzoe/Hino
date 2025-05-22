import 'package:flutter/material.dart';
import 'package:flutter_application_sqlite/src/hino.dart';
import 'package:flutter_application_sqlite/hino_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _hinos = [];
  String _letraSelecionada = 'H';
  String _numeroSelecionado = '';

  Future<void> carregarLista() async {
    final List<Map<String, dynamic>> items =
        await dbHelper.searchById(_letraSelecionada + _numeroSelecionado);
    setState(() {
      _hinos = items;
    });
  }

  void exibir(String id) {
    carregarHino(id);
  }

  Future<void> buscaPorNome(String texto) async {
    print(texto);
    if (texto.isNotEmpty && texto.length > 3) {
      final List<Map<String, dynamic>> items3 =
          await dbHelper.searchByText(_usernameController.text);
      setState(() {
        _hinos = items3;
      });
    }
  }

  void carregarHino(String id) async {
    final List<Map<String, dynamic>> items2 = await dbHelper.searchById(id);
    print(items2);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HinoPage(args: id),
      ),
    );
  }

  void _selecionarLetra(String valor) {
    setState(() {
      _letraSelecionada = valor;
    });

    carregarLista();
  }

  void _selecionarNumero(String valor) {
    if (_numeroSelecionado.isEmpty && valor == '0') return;

    if (_numeroSelecionado.length < 3) {
      setState(() {
        _numeroSelecionado += valor;
      });
    }

    carregarLista();
  }

  void _backspace() {
    if (_numeroSelecionado.isNotEmpty) {
      setState(() {
        _numeroSelecionado = _numeroSelecionado.substring(
          0,
          _numeroSelecionado.length - 1,
        );
      });

      carregarLista();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title: Text('Hinos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _hinos.isEmpty
                ? Text('')
                : Expanded(
                    child: ListView.builder(
                      itemCount: _hinos.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            onTap: () => exibir(_hinos[index]['Id']),
                            title: Text(_hinos[index]['Titulo']),
                            trailing: Icon(Icons.arrow_forward),
                          ),
                        );
                      },
                    ),
                  ),
            SizedBox(height: 20),
            Card(
              color: Colors.lightBlue[200],
              child: Padding(
                padding: EdgeInsets.all(7),
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
            Card(
              color: Colors.lightBlue[200],
              child: Padding(
                padding: EdgeInsets.all(7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _letraSelecionada,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        Text(
                          _numeroSelecionado,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _selecionarLetra('H');
                          },
                          child: const Text('H'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _selecionarLetra('C');
                          },
                          child: const Text('C'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _selecionarLetra('S');
                          },
                          child: const Text('S'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _selecionarNumero('1');
                          },
                          child: const Text('1'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _selecionarNumero('2');
                          },
                          child: const Text('2'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
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
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _selecionarNumero('4');
                          },
                          child: const Text('4'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _selecionarNumero('5');
                          },
                          child: const Text('5'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
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
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _selecionarNumero('7');
                          },
                          child: const Text('7'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _selecionarNumero('8');
                          },
                          child: const Text('8'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
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
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _selecionarNumero('0');
                          },
                          child: const Text(''),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _selecionarNumero('0');
                          },
                          child: const Text('0'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _backspace();
                          },
                          child: const Icon(Icons.backspace),
                        ),
                      ],
                    ),
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
