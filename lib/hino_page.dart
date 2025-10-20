import 'package:flutter/material.dart';
import 'package:hinos/src/hino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'color_picker_dialog.dart';

class HinoPage extends StatefulWidget {
  final String? args;
  const HinoPage({Key? key, this.args}) : super(key: key);

  @override
  State<HinoPage> createState() => _HinoPageState();
}

class _HinoPageState extends State<HinoPage> {
  final dbHelper = DatabaseHelper.instance;
  String appBarTitle = 'Título Inicial';
  bool isWidgetVisible = true;
  bool ehUltimoHino = false;
  String idHinoHinoAtual = '';

  double fonteTamanho = 24.0;
  Color fonteCor = Colors.black;
  Color fundoCor = Colors.white;

  Map<int, List<Map<String, dynamic>>> agrupado = {};

  @override
  void initState() {
    super.initState();
    preferenciaCarrega();
    carregarHino(widget.args ?? '0');
  }

  Future<void> preferenciaCarrega() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fonteTamanho = prefs.getDouble('fonteTamanho') ?? fonteTamanho;

      String fonteCorString = prefs.getString('fonteCor') ??
          Colors.white.value.toRadixString(16).padLeft(8, '0');
      fonteCor = Color(int.parse(fonteCorString, radix: 16));

      String fundoCorString = prefs.getString('fundoCor') ??
          Colors.white.value.toRadixString(16).padLeft(8, '0');
      fundoCor = Color(int.parse(fundoCorString, radix: 16));
    });
  }

  Future<void> preferenciaPersiste(String nome, double valor) async {
    setState(() => fonteTamanho);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(nome, fonteTamanho);
  }

  Future<void> fundoCorPersiste(Color cor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'fundoCor', cor.value.toRadixString(16).padLeft(8, '0'));
  }

  Future<void> fonteCorPersiste(Color cor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'fonteCor', cor.value.toRadixString(16).padLeft(8, '0'));
  }

  void fonteTamanhoPersiste() {
    preferenciaPersiste('fonteTamanho', fonteTamanho);
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

    fonteTamanhoPersiste();
    setState(() {});
  }

  void carregarHino(String id) async {
    final List<Map<String, dynamic>> versos = await dbHelper.getVersos(id);
    agrupado = {};
    if (versos.isNotEmpty) {
      setState(() {
        appBarTitle =
            versos[0]['IdHino'] + ' ' + versos[0]['Titulo'] ?? 'Carregando...';

        for (var item in versos) {
          final estrofe = item['Estrofe'] as int;
          agrupado.putIfAbsent(estrofe, () => []).add(item);
        }

        idHinoHinoAtual = id;
      });
    }
  }

  Future<void> _openColorPicker() async {
    final color = await showDialog<Color>(
      context: context,
      builder: (context) => ColorPickerDialog(initialColor: fundoCor),
    );

    if (color != null) {
      if (color == Color(0xFF151315) || color == Color(0xFF1E2545)) {
        fonteCor = Colors.white;
      } else {
        fonteCor = Colors.black;
      }

      fundoCorPersiste(color);
      fonteCorPersiste(fonteCor);

      setState(() {
        fundoCor = color;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fundoCor,
        foregroundColor: fonteCor,
        title: Text(appBarTitle),
      ),
      backgroundColor: fundoCor,
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(children: [
          agrupado.isEmpty
              ? Text('')
              : Expanded(
                  child: GestureDetector(
                  onTap: () {
                    isWidgetVisible = !isWidgetVisible;
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
                                      fontSize: fonteTamanho,
                                      color: fonteCor),
                                  textAlign: TextAlign.left,
                                ),
                            ]);
                      }),
                )),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
          visible: isWidgetVisible,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Column(
                    children: [
                      FloatingActionButton(
                        heroTag: "btn1",
                        onPressed: () {
                          retrocederHino();
                        },
                        child: const Icon(Icons.navigate_before, size: 42),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      FloatingActionButton(
                        heroTag: "btn2",
                        onPressed: () {
                          mudarTamanhoFonte(false);
                        },
                        child: const Icon(Icons.zoom_out, size: 42),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        heroTag: "btn3",
                        onPressed: _openColorPicker,
                        child: const Icon(Icons.color_lens, size: 42),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      FloatingActionButton(
                        heroTag: "btn4",
                        onPressed: () {
                          mudarTamanhoFonte(true);
                        },
                        child: const Icon(Icons.zoom_in, size: 42),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      FloatingActionButton(
                        heroTag: "btn5",
                        onPressed: () {
                          avancarHino();
                        },
                        child: const Icon(Icons.navigate_next, size: 42),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20)
            ],
          )),
    );
  }
}
