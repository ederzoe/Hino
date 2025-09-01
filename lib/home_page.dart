import 'package:flutter/material.dart';
import 'package:hinos/src/hino.dart';
import 'package:hinos/hino_page.dart';

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
    if (texto.isNotEmpty && texto.length > 3) {
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
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 13, 45, 77),
        foregroundColor: Colors.white,
        title: Text('Hinos'),
      ),
      backgroundColor: Color.fromARGB(255, 13, 45, 77),
      body: Align(
        //padding: const EdgeInsets.all(16.0),
        alignment: FractionalOffset.bottomCenter,
        child: Column(
          children: [
            _hinos.isEmpty
                ? Expanded(child: Text(""))
                : Expanded(
                    child: ListView.builder(
                      itemCount: _hinos.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            onTap: () => exibir(_hinos[index]['Id']),
                            title: Text(_hinos[index]['Id'] +
                                ' ' +
                                _hinos[index]['Titulo'],  overflow: TextOverflow.ellipsis, maxLines: 1),
                            subtitle: Text(_hinos[index]['Texto'],  overflow: TextOverflow.ellipsis, maxLines: 1,style: TextStyle(fontSize: 14),),
                            trailing: Icon(Icons.arrow_forward, size: 42),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_letraSelecionada,
                              style: Theme.of(context).textTheme.displayMedium),
                          Text(_numeroSelecionado,
                              style: Theme.of(context).textTheme.displayMedium),
                          TextButton(
                            onPressed: () {
                              _backspace();
                            },
                            child: const Icon(Icons.backspace, size: 42, color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              _selecionarLetra('H');
                            },
                            child: const Text('H'),
                          ),
                          TextButton(
                            onPressed: () {
                              _selecionarLetra('C');
                            },
                            child: const Text('C'),
                          ),
                          TextButton(
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
