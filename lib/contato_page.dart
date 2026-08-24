import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContatoPage extends StatelessWidget {
  const ContatoPage({Key? key}) : super(key: key);

  static const String _chavePix = 'eder.fs.zoe@gmail.com';
  static const String _whatsApp = '5511945767267';

  Future<void> _abrirWhatsApp(
    BuildContext context, {
    required String mensagem,
  }) async {
    final uri = Uri.https('wa.me', '/$_whatsApp', {'text': mensagem});

    try {
      final abriu = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!abriu && context.mounted) {
        _mostrarErroWhatsApp(context);
      }
    } catch (_) {
      if (context.mounted) {
        _mostrarErroWhatsApp(context);
      }
    }
  }

  void _mostrarErroWhatsApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Não foi possível abrir o WhatsApp.'),
      ),
    );
  }

  Future<void> _copiarChavePix(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: _chavePix));
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chave Pix copiada.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fale Conosco')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ContatoCard(
            icon: Icons.lightbulb_outline,
            title: 'Sugestões',
            description: 'Ideias ou novos recursos para o aplicativo.',
            buttonText: 'Enviar Sugenstão',
            onPressed: () => _abrirWhatsApp(
              context,
              mensagem:
                  'Olá! Gostaria de enviar uma sugestão para o aplicativo Hinos:\n\n',
            ),
          ),
          const SizedBox(height: 12),
          _ContatoCard(
            icon: Icons.bug_report_outlined,
            title: 'Informar um problema',
            description: 'Diga também em qual tela ocorreu, se puder.',
            buttonText: 'Informar Erro',
            onPressed: () => _abrirWhatsApp(
              context,
              mensagem:
                  'Olá! Encontrei o seguinte problema no aplicativo Hinos:\n\n',
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.volunteer_activism_outlined, size: 30),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Fazer uma doação',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Podemos chegar mais longe juntos.',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Chave Pix:',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(child: SelectableText(_chavePix)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: () => _copiarChavePix(context),
                      icon: const Icon(Icons.copy),
                      label: const Text('Copiar chave Pix'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContatoCard extends StatelessWidget {
  const _ContatoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: onPressed,
                icon: const FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Color(0xFF25D366),
                ),
                label: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
