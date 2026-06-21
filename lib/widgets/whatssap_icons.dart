import 'package:flutter/material.dart';

class WhatsAppIconSimple extends StatelessWidget {
  final double size;
  final Color? color;

  const WhatsAppIconSimple({
    super.key,
    this.size = 28,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chat,
      size: size,
      color: color ?? const Color(0xFF25D366),
    );
  }
}
