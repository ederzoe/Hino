import 'package:flutter/material.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color? initialColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerDialog({
    Key? key,
    this.initialColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  final List<Color> colors = [
    Color(0xFFFFFFFF),
    Color(0xFFFFF4D6),
    Color(0xFFECEFF1),
    Color(0xFFDCEAF7),
    Color(0xFFDDE8D5),
    Color(0xFFc9c3b1),
    Color(0xFFcf98c7),
    Color(0xFF073f61),
    Color(0xFF27373a),
    Color(0xFF151315),
  ];

  Color? selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          Theme.of(context).colorScheme.surface.withValues(alpha: 0.82),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      actionsPadding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
      content: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: colors.map((color) {
          final isSelected = color == selectedColor;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedColor = color;
              });
              widget.onColorSelected(color);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 54 : 46,
              height: isSelected ? 54 : 46,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                  width: isSelected ? 3 : 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
