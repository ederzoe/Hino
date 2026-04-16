import 'package:flutter/material.dart';
import 'package:hinos/src/hino.dart';
import 'package:hinos/hino_page.dart';
import 'package:hinos/lista_page.dart';

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
    final bool isKeyboardVisible =
        MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0), // Off-white moderno
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Falando e Cantando Entre Vós',
          style:
              TextStyle(color: Color(0xFF1B3A4B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
          Icon(Icons.music_note_outlined, size: 80, color: Colors.black12),
          const SizedBox(height: 16),
          Text(
            "Digite o número ou título do hino",
            style: TextStyle(color: Colors.black38, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildHinoList() {
    return ListView.builder(
      itemCount: _hinos.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final hino = _hinos[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            onTap: () => exibir(_hinos[index]['Id']),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF1B3A4B),
              child: Text(hino['Id'].toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
            title: Text(hino['Titulo'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(hino['Texto'],
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_right, color: Colors.black26),
          ),
        );
      },
    );
  }

  Widget _buildBottomPanel(bool hideNumericPad) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Campo de Texto Moderno
          TextField(
            controller: _searchController,
            onChanged: _buscaPorNome,
            decoration: InputDecoration(
              hintText: 'Pesquisa por título ou verso',
              filled: true,
              fillColor: const Color(0xFFF2F2F2),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF1B3A4B)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
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
            const SizedBox(height: 20),
            // Display do Número Digitado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _numeroSelecionado.isEmpty ? "000" : _numeroSelecionado,
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: _numeroSelecionado.isEmpty
                        ? Colors.black12
                        : const Color(0xFF1B3A4B),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.backspace_outlined,
                      color: Colors.redAccent),
                  onPressed: _backspace,
                ),
              ],
            ),
            const Divider(height: 30),
            // Teclado Numérico Estilizado
            _buildNumericKeyboard(),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                carregarLista();
              }, //
              child: const Text("Ver todos os hinos",
                  style: TextStyle(
                      color: Color(0xFFB59410), fontWeight: FontWeight.bold)),
            ),
          ],
        ],
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
            padding: const EdgeInsets.symmetric(vertical: 4),
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
        height: 55,
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F5F0),
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B3A4B)),
        ),
      ),
    );
  }
}
