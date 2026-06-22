import 'package:flutter/material.dart';
import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import 'package:incaxias_appcx/widgets/whatssap_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SaudeDetalhesPage extends StatelessWidget {
  final String idClinica;
  final Map<String, dynamic> dados;

  const SaudeDetalhesPage({
    super.key,
    required this.idClinica,
    required this.dados,
  });

  void _abrirWhatsApp() async {
    final numero = dados['whatsapp'] ?? '';
    if (numero.isEmpty) return;

    final url = "https://wa.me/55$numero";
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _abrirMapa() async {
    final localizacao = dados['localizacao'] ?? '';
    if (localizacao.isEmpty) return;

    final url = "https://www.google.com/maps/search/?api=1&query=$localizacao";
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: AppText.title(dados['nome'] ?? 'Clínica'),
      ),

      // 📍 BOTÃO FLUTUANTE MAPA
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: _abrirMapa,
        child: const Icon(
          Icons.location_on,
          color: Colors.white,
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== NOME =====
          AppText.subtitle('Especialidades'),

          const SizedBox(height: 6),

          // ===== ESPECIALIDADE =====
          AppText.body(
            dados['especialidade'] ?? '',
          ),

          const SizedBox(height: 5),

          _infoRow(Icons.access_time, dados['horarioAtendimento'] ?? ''),
          const SizedBox(height: 3),
          _infoRow(Icons.location_on, dados['endereco'] ?? ''),

          const SizedBox(height: 5),

          AppText.subtitle(
            "Médicos em atendimento na semana",
          ),

          const SizedBox(height: 4),

          // ===== ESCALA DA SEMANA =====
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('clinicas')
                .doc(idClinica)
                .collection('escala')
                .orderBy('data') // 🔥 ordena por mês e dia automaticamente
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: AppText.body("Nenhum médico cadastrado na escala."),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((doc) {
                  final e = doc.data() as Map<String, dynamic>;

                  final Timestamp ts = e['data'];
                  final DateTime data = ts.toDate();

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.medical_services),
                      title: AppText.body(
                          "${_formatarData(data)} • ${e['horario']}"),
                      subtitle: AppText.body(
                          "${e['medico']} — ${e['especialidade']}"),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),

      // 📞 BOTÃO CONTATO
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: _abrirWhatsApp,
          icon: const WhatsAppIconSimple(size: 28),
          label: const Text("Entrar em contato"),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blue.shade700),
        const SizedBox(width: 6),
        Expanded(child: AppText.body(text)),
      ],
    );
  }
}

String _formatarData(DateTime data) {
  return "${data.day.toString().padLeft(2, '0')}/"
      "${data.month.toString().padLeft(2, '0')}/"
      "${data.year}";
}
