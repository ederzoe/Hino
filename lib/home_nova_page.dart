import 'package:flutter/material.dart';
import 'package:hinos/src/hino.dart';
import 'package:hinos/hino_page.dart';
import 'package:hinos/lista_page.dart';
import 'package:hinos/contato_page.dart';

class HomeNovaPage extends StatefulWidget {
  const HomeNovaPage({Key? key}) : super(key: key);

  @override
  HomeNovaPageState createState() => HomeNovaPageState();
}

class HomeNovaPageState extends State<HomeNovaPage> {
  // Simulação do dbHelper para o exemplo compilar
  final dbHelper = DatabaseHelper.instance;
  final _searchController = TextEditingController();

  List<Map<String, dynamic>> _hinos = [];
  String _numeroSelecionado = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- Lógica ---

  Future<void> _carregarPesquisa() async {
    final items = await dbHelper.searchById(_numeroSelecionado);
    setState(() => _hinos = items);
  }

  void exibir(String id) {
    carregarHino(id);
  }

  Future<void> _buscaPorNome(String texto) async {
    if (texto.length > 1) {
      final items = await dbHelper.searchByText(texto);
      setState(() => _hinos = items);
    } else if (texto.isEmpty) {
      setState(() => _hinos = []);
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
      setState(() => _numeroSelecionado += valor);
      _carregarPesquisa();
    }
  }

  void _backspace() {
    if (_numeroSelecionado.isNotEmpty) {
      setState(() {
        _numeroSelecionado =
            _numeroSelecionado.substring(0, _numeroSelecionado.length - 1);
      });
      _carregarPesquisa();
    }
  }

  // --- Widgets de Interface ---

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isKeyboardVisible =
        MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'HINOS',
          style: TextStyle(
              color: colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Fale Conosco',
            icon: const Icon(Icons.support_agent, color: Colors.blueAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContatoPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Área da Lista de Resultados
          Expanded(
            child: _hinos.isEmpty ? _buildEmptyState() : _buildHinoList(),
          ),

          // Painel Inferior (Busca e Teclado)
          _buildBottomPanel(isKeyboardVisible),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note_outlined,
              size: 80, color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 16),
          Text(
            "Digite o número ou título do hino",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildHinoList() {
    return ListView.builder(
      itemCount: _hinos.length,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      itemBuilder: (context, index) {
        final hino = _hinos[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            onTap: () => exibir(_hinos[index]['Id']),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(hino['Id'].toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
            title: Text(hino['Titulo'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(hino['Texto'],
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Icon(Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        );
      },
    );
  }

  Widget _buildBottomPanel(bool hideNumericPad) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.12),
                blurRadius: 12)
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Campo de Texto Moderno
            TextField(
              controller: _searchController,
              onChanged: _buscaPorNome,
              decoration: InputDecoration(
                hintText: 'Pesquisa por título ou verso',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                prefixIcon: Icon(Icons.search,
                    color: Theme.of(context).colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _hinos = []);
                        },
                      )
                    : null,
              ),
            ),

            if (!hideNumericPad) ...[
              const SizedBox(height: 6),
              // Display do Número Digitado
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _numeroSelecionado.isEmpty ? "000" : _numeroSelecionado,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: _numeroSelecionado.isEmpty
                          ? Theme.of(context).colorScheme.outlineVariant
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.backspace_outlined,
                        color: Colors.redAccent, size: 21),
                    onPressed: _backspace,
                  ),
                ],
              ),
              const Divider(height: 14),
              // Teclado Numérico Estilizado
              _buildNumericKeyboard(),
              TextButton(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  minimumSize: const Size(0, 36),
                ),
                onPressed: () {
                  carregarLista();
                }, //
                child: Text("Todos os Hinos",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNumericKeyboard() {
    return Column(
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['0']
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((val) => _buildKey(val)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildKey(String label) {
    return InkWell(
      onTap: () => _selecionarNumero(label),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 42,
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(11),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}
