import 'package:flutter/material.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color? initialColor;

  const ColorPickerDialog({Key? key, this.initialColor}) : super(key: key);

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  final List<Color> colors = [
    Color(0xFFFFFFFF),
    Color(0xFFc9c3b1),
    Color(0xFF27373a),
    Color(0xFF073f61),
    Color(0xFF151315),
    Color(0xFFcf98c7),
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
      title: const Text('Selecione uma cor'),
      content: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: colors.map((color) {
          final isSelected = color == selectedColor;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedColor = color;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 70 : 60,
              height: isSelected ? 70 : 60,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey.shade400,
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
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, selectedColor),
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
