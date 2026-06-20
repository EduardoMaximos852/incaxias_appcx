import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MototaxiDetalhePage extends StatelessWidget {
  final Map<String, dynamic> mototaxi;

  const MototaxiDetalhePage({super.key, required this.mototaxi});

  void _abrirWhatsApp(String numero) async {
    final uri = Uri.parse("https://wa.me/$numero");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _info(String label, String? valor) {
    if (valor == null || valor.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Expanded(child: Text(valor, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mototaxi['nome'] ?? 'Detalhes'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                mototaxi['fotoUrl'] ?? '',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.motorcycle, size: 80),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _info('Nome', mototaxi['nome']),
            _info('Bairro', mototaxi['bairro']),
            _info('Endereço', mototaxi['endereco']),
            _info('Localidade', mototaxi['localidade']),
            _info('Modelo', mototaxi['modelo']),
            _info('Placa', mototaxi['placa']),
            _info('CPF', mototaxi['cpf']),
            const SizedBox(height: 20),

            if (mototaxi['whatsapp'] != null &&
                mototaxi['whatsapp'].toString().isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () =>
                      _abrirWhatsApp(mototaxi['whatsapp'].toString()),
                  icon: const Icon(Icons.phone, color: Colors.white),
                  label: const Text(
                    "Chamar no WhatsApp",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
