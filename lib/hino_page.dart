import 'package:flutter/material.dart';
import 'package:hinos/partitura_page.dart';
import 'package:hinos/src/hino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'color_picker_dialog.dart';

class HinoPage extends StatefulWidget {
  final String? args;
  const HinoPage({Key? key, this.args}) : super(key: key);

  @override
  State<HinoPage> createState() => _HinoPageState();
}

class _HinoPageState extends State<HinoPage> with WidgetsBindingObserver {
  static const List<String> _fontesDisponiveis = [
    'Gentium Plus',
    'OpenDyslexic',
    'Source Serif 4',
    'Roboto Serif',
    'Roboto Sans',
    'Roboto Sans Mono',
  ];

  final dbHelper = DatabaseHelper.instance;
  String appBarTitle = '';
  bool isWidgetVisible = true;
  bool ehUltimoHino = false;
  String idHinoHinoAtual = '';

  double fonteTamanho = 24.0;
  String fonteFamilia = 'Roboto Sans';
  Color fonteCor = Colors.black;
  Color fundoCor = Colors.white;
  bool _temCorPersonalizada = false;

  Map<int, List<Map<String, dynamic>>> agrupado = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _usarCoresDoSistema();
    preferenciaCarrega();
    carregarHino(widget.args ?? '0');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (!_temCorPersonalizada && mounted) {
      setState(_usarCoresDoSistema);
    }
  }

  void _usarCoresDoSistema() {
    final isDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    fonteCor = isDark ? Colors.white : Colors.black;
    fundoCor = isDark ? const Color(0xFF111417) : Colors.white;
  }

  Future<void> preferenciaCarrega() async {
    final prefs = await SharedPreferences.getInstance();
    var fonteFamiliaSalva = prefs.getString('fonteFamilia');
    if (fonteFamiliaSalva == 'Untitled Serif') {
      fonteFamiliaSalva = 'Source Serif 4';
      await prefs.setString('fonteFamilia', fonteFamiliaSalva);
    }
    if (!mounted) return;

    setState(() {
      fonteTamanho = prefs.getDouble('fonteTamanho') ?? fonteTamanho;
      if (_fontesDisponiveis.contains(fonteFamiliaSalva)) {
        fonteFamilia = fonteFamiliaSalva!;
      }

      final fonteCorSalva = prefs.getString('fonteCor');
      String fonteCorString = fonteCorSalva ??
          fonteCor.toARGB32().toRadixString(16).padLeft(8, '0');
      fonteCor = Color(int.parse(fonteCorString, radix: 16));

      final fundoCorSalva = prefs.getString('fundoCor');
      String fundoCorString = fundoCorSalva ??
          fundoCor.toARGB32().toRadixString(16).padLeft(8, '0');
      fundoCor = Color(int.parse(fundoCorString, radix: 16));
      _temCorPersonalizada = fonteCorSalva != null || fundoCorSalva != null;
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
        'fundoCor', cor.toARGB32().toRadixString(16).padLeft(8, '0'));
  }

  Future<void> fonteCorPersiste(Color cor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'fonteCor', cor.toARGB32().toRadixString(16).padLeft(8, '0'));
  }

  void fonteTamanhoPersiste() {
    preferenciaPersiste('fonteTamanho', fonteTamanho);
  }

  Future<void> _selecionarFonte(String fonte) async {
    setState(() => fonteFamilia = fonte);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fonteFamilia', fonte);
  }

  Future<void> _openFontPicker() async {
    final fonteSelecionada = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Selecionar fonte'),
        children: [
          for (final fonte in _fontesDisponiveis)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, fonte),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: fonte == fonteFamilia
                        ? const Icon(Icons.check, size: 20)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(fonte, style: TextStyle(fontFamily: fonte)),
                ],
              ),
            ),
        ],
      ),
    );

    if (fonteSelecionada != null) {
      await _selecionarFonte(fonteSelecionada);
    }
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
            (versos[0]['IdHino'].contains('N') ? '' : versos[0]['IdHino']) +
                    ' ' +
                    versos[0]['Titulo'] ??
                'Carregando...';

        for (var item in versos) {
          final estrofe = item['Estrofe'] as int;
          agrupado.putIfAbsent(estrofe, () => []).add(item);
        }

        idHinoHinoAtual = id;
      });
    }
  }

  void partituraHino(String id) async {
    if (id.length == 3) {
      id = id
          .replaceAll('H', 'H0')
          .replaceAll('C', 'C0')
          .replaceAll('S', 'S0')
          .replaceAll('N', 'N0');
    } else if (id.length == 2) {
      id = id
          .replaceAll('H', 'H00')
          .replaceAll('C', 'C00')
          .replaceAll('S', 'S00')
          .replaceAll('N', 'N00');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PartituraWidget(args: id),
      ),
    );
  }

  Future<void> _openColorPicker() async {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) => ColorPickerDialog(
        initialColor: fundoCor,
        onColorSelected: _aplicarCorDeFundo,
      ),
    );
  }

  void _aplicarCorDeFundo(Color color) {
    _temCorPersonalizada = true;
    if (color == const Color(0xFF151315) ||
        color == const Color(0xFF073f61) ||
        color == const Color(0xFF27373a)) {
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

  String _montarTextoCompartilhamento(Set<int> estrofesSelecionadas) {
    final partes = <String>[appBarTitle.trim()];

    for (final entry in agrupado.entries) {
      if (!estrofesSelecionadas.contains(entry.key)) continue;

      final versos = entry.value.map((item) => '${item['Texto']}').join('\n');
      partes.add(versos);
    }

    return partes.join('\n\n');
  }

  Future<void> _compartilharEstrofes() async {
    if (agrupado.isEmpty) return;

    final estrofesSelecionadas = agrupado.keys.toSet();
    final selecionadas = await showDialog<Set<int>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final todasSelecionadas =
              estrofesSelecionadas.length == agrupado.length;

          return AlertDialog(
            title: const Text('Compartilhar letra'),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Selecionar todas'),
                      value: todasSelecionadas,
                      onChanged: (marcarTodas) {
                        setDialogState(() {
                          estrofesSelecionadas.clear();
                          if (marcarTodas == true) {
                            estrofesSelecionadas.addAll(agrupado.keys);
                          }
                        });
                      },
                    ),
                    const Divider(),
                    for (final entry in agrupado.entries)
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(entry.value.first['Coro'] == 1
                            ? 'Coro'
                            : 'Estrofe ${entry.key}'),
                        subtitle: Text(
                          '${entry.value.first['Texto']}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: estrofesSelecionadas.contains(entry.key),
                        onChanged: (selecionar) {
                          setDialogState(() {
                            if (selecionar == true) {
                              estrofesSelecionadas.add(entry.key);
                            } else {
                              estrofesSelecionadas.remove(entry.key);
                            }
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              FilledButton.icon(
                onPressed: estrofesSelecionadas.isEmpty
                    ? null
                    : () => Navigator.pop(
                          dialogContext,
                          Set<int>.from(estrofesSelecionadas),
                        ),
                icon: const Icon(Icons.share),
                label: const Text('Compartilhar'),
              ),
            ],
          );
        },
      ),
    );

    if (selecionadas == null || !mounted) return;

    final tamanhoTela = MediaQuery.sizeOf(context);
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: _montarTextoCompartilhamento(selecionadas),
          subject: appBarTitle,
          sharePositionOrigin: Rect.fromLTWH(
            tamanhoTela.width / 2,
            tamanhoTela.height / 2,
            1,
            1,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir o compartilhamento.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fundoCor,
        foregroundColor: fonteCor,
        title: Text(appBarTitle),
        actions: [
          IconButton(
            tooltip: 'Compartilhar letra',
            onPressed: agrupado.isEmpty ? null : _compartilharEstrofes,
            icon: const Icon(Icons.share),
          ),
        ],
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
                                      fontFamily: fonteFamilia,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            heroTag: "btnFonte",
                            tooltip: 'Selecionar fonte',
                            onPressed: _openFontPicker,
                            child: const Icon(
                              Icons.font_download_outlined,
                              size: 42,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          FloatingActionButton(
                            heroTag: "btn6",
                            onPressed: () {
                              partituraHino(idHinoHinoAtual);
                            },
                            child: const Icon(Icons.music_note, size: 42),
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
                ),
              ),
              SizedBox(height: 20)
            ],
          )),
    );
  }
}
