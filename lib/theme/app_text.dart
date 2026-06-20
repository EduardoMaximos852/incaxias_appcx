import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  // ===== TITULO PRINCIPAL 20 =====
  static Text title(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  // ===== TITULO TITULO OPCAO 22 =====
  static Text title2(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  // ===== TITULO SUBTITULO OPCAO 22 =====
  static Text subtitle2(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  // ===== SUB TITULO1 =====
  static Text subtitle(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      maxLines: 2,
    );
  }

  // ===== SUB MENU =====
  static Text menutitle(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      maxLines: 2,
    );
  }

  // ===== SUB MENU =====
  static Text menucultura(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      maxLines: 2,
    );
  }

  // ===== TEXTO PADRÃO =====
  static Text body(String text, {bool bold = false}) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
        color: Colors.black87,
      ),
    );
  }

  // ===== TEXTO SECUNDÁRIO =====
  static Text caption(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  // ===== TEXTO ESCRITO =====
  static Text escrito(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  // ===== TEXTO DE BOTÃO =====
  static Text button(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

// ===== TEXTO DENTRO DE ELIPSE =====
  static Widget valorElipse(String valor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(50), // cria formato de elipse
      ),
      child: Text(
        valor,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }
}
