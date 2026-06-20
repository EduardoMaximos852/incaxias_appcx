import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class VagaDetalhePage extends StatelessWidget {
  const VagaDetalhePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vagaId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar:
          AppBar(title: AppText.title("Detalhes da Vaga"), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        icon: const Icon(Icons.home),
        label: AppText.body("Início"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('vagas').doc(vagaId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Vaga não encontrada"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 IMAGEM + TÍTULO
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    data['imageUrl'],
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 10),

                AppText.title(
                  data['titulo'],
                ),

                const SizedBox(height: 6),

                AppText.body(
                  data['empresa'],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: AppText.body(
                        "${data['bairro']} - ${data['endereco']}",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// 🔹 BOTÕES DE AÇÃO RÁPIDA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _actionButton(
                      icon: FlutterIcons.whatsapp_faw5d,
                      color: Colors.green,
                      label: "WhatsApp",
                      onTap: () => _abrirWhatsApp(data),
                    ),
                    _actionButton(
                      icon: Icons.email_outlined,
                      color: Colors.blue,
                      label: "Email",
                      onTap: () => _abrirEmail(data),
                    ),
                    _actionButton(
                      icon: Icons.map_outlined,
                      color: Colors.orange,
                      label: "Rota",
                      onTap: () => _abrirMapa(data['endereco']),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// 🔹 DESCRIÇÃO
                _sectionCard(
                  title: "Descrição da vaga",
                  child: AppText.body(data['descricao']),
                ),

                const SizedBox(height: 10),

                /// 🔹 REQUISITOS
                _sectionCard(
                  title: "Requisitos",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      (data['requisitos'] as List).length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: AppText.body("• ${data['requisitos'][index]}"),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔹 BENEFÍCIOS
                _sectionCard(
                  title: "Benefícios",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      (data['beneficios'] as List).length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: AppText.body("• ${data['beneficios'][index]}"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔹 BOTÃO DE AÇÃO PERSONALIZADO
  Widget _actionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: CircleAvatar(
            radius: 26,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  /// 🔹 CARD DE SEÇÃO
  Widget _sectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  /// 🔹 AÇÕES EXTERNAS
  Future<void> _abrirMapa(String endereco) async {
    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(endereco)}",
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _abrirWhatsApp(Map<String, dynamic> data) async {
    final number = data['whatsapp'];
    final msg = Uri.encodeComponent(
      "Olá, estou interessado na vaga ${data['titulo']}",
    );
    final url = Uri.parse("https://wa.me/$number?text=$msg");
    await launchUrl(url);
  }

  Future<void> _abrirEmail(Map<String, dynamic> data) async {
    final email = data['emailContato'];
    final subject = Uri.encodeComponent("Interesse na vaga ${data['titulo']}");
    final url = Uri.parse("mailto:$email?subject=$subject");
    await launchUrl(url);
  }
}
