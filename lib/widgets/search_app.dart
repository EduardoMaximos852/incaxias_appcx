import 'package:flutter/material.dart';

class SearchPadrao extends StatelessWidget {
  final Function(String) onChanged;
  final String hint;

  const SearchPadrao({
    super.key,
    required this.onChanged,
    this.hint = "Buscar...",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 0.6,
          ),
        ),
        child: TextField(
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(
              Icons.search,
              size: 20,
              color: Colors.black54,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 10,
            ),
          ),
          onChanged: (value) {
            onChanged(value.toLowerCase().trim());
          },
        ),
      ),
    );
  }
}
