import 'package:flutter/material.dart';

class AdditionalWidgetItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AdditionalWidgetItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(icon),
      const SizedBox(
        height: 8,
      ),
      Text(label),
      const SizedBox(
        height: 8,
      ),
      Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ]);
  }
}
