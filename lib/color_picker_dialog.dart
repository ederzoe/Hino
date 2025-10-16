import 'package:flutter/material.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color? initialColor;

  const ColorPickerDialog({Key? key, this.initialColor});

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  final List<Color> colors = [
    Color.fromARGB(255, 255, 255, 255),
    Color.fromARGB(237, 239, 238, 238),
    Color.fromARGB(254, 246, 235, 235),
    Color.fromARGB(255, 36, 36, 36),
    Color.fromARGB(255, 13, 45, 77),
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
              width: isSelected ? 50 : 40,
              height: isSelected ? 50 : 40,
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
