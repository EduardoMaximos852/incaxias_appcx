import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TaxiDetailPage extends StatefulWidget {
  final String nome;
  final String endereco;
  final String fotoUrl;
  final String placa;
  final String automovel;
  final String dataInicio;
  final String local;
  final String bairro;
  final String whatsapp;

  const TaxiDetailPage({
    super.key,
    required this.nome,
    required this.endereco,
    required this.fotoUrl,
    required this.placa,
    required this.automovel,
    required this.dataInicio,
    required this.local,
    required this.bairro,
    required this.whatsapp,
  });

  @override
  State<TaxiDetailPage> createState() => _TaxiDetailPageState();
}

class _TaxiDetailPageState extends State<TaxiDetailPage> {
  double avaliacaoAtual = 0;

  void avaliar(double nota) {
    setState(() => avaliacaoAtual = nota);
  }

  Future<void> abrirWhatsapp() async {
    final url = Uri.parse(
      "https://wa.me/55${widget.whatsapp}?text=Olá%20motorista,%20preciso%20de%20um%20transporte!",
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: const Icon(Icons.home),
      ),

      appBar: AppBar(
        title: Text(widget.nome),
        backgroundColor: Colors.orange.shade700,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO DO MOTORISTA / TÁXI
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                widget.fotoUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.local_taxi, size: 80),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // NOME + AVALIAÇÃO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.nome,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        avaliacaoAtual.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // DADOS EM CARD
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    info("Automóvel", widget.automovel),
                    info("Placa", widget.placa),
                    info("Endereço", widget.endereco),
                    info("Bairro", widget.bairro),
                    info("Local", widget.local),
                    info("Início das atividades", widget.dataInicio),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 2),

            // ⭐ SISTEMA DE AVALIAÇÃO INTERATIVO
            const Text(
              "Avaliar Motorista:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),

            Row(
              children: List.generate(5, (i) {
                final nota = (i + 1).toDouble();
                return IconButton(
                  onPressed: () => avaliar(nota),
                  icon: Icon(
                    avaliacaoAtual >= nota ? Icons.star : Icons.star_border,
                    size: 32,
                    color: Colors.orange.shade700,
                  ),
                );
              }),
            ),

            const SizedBox(height: 3),

            // BOTÃO WHATSAPP
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: abrirWhatsapp,
                icon: ImageIcon(
                  const AssetImage(
                    "assets/icon/whatsapp.png",
                  ), //  ícone baixado
                  size: 26,
                ),
                label: const Text(
                  "Chamar no WhatsApp",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }

  Widget info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 10))),
        ],
      ),
    );
  }
}
