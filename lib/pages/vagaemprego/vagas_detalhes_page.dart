import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class VagaDetalhePage extends StatelessWidget {
  const VagaDetalhePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vagaId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: AppText.title("Detalhes da Vaga"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        icon: const Icon(Icons.home),
        label: AppText.body("Início"),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future:
            FirebaseFirestore.instance.collection('vagas').doc(vagaId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao carregar a vaga."),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text("Vaga não encontrada"),
            );
          }

          final data = snapshot.data!.data();
          if (data == null) {
            return const Center(
              child: Text("Dados da vaga indisponíveis."),
            );
          }

          final String titulo = data['titulo']?.toString() ?? '';
          final String empresa = data['empresa']?.toString() ?? '';
          final String bairro = data['bairro']?.toString() ?? '';
          final String endereco = data['endereco']?.toString() ?? '';
          final String descricao = data['descricao']?.toString() ?? '';
          final String imageUrl = data['imageUrl']?.toString() ?? '';
          final String whatsapp = data['whatsapp']?.toString() ?? '';
          final String emailContato = data['emailContato']?.toString() ?? '';

          final List<String> requisitos = (data['requisitos'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];

          final List<String> beneficios = (data['beneficios'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// IMAGEM
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.broken_image,
                                size: 48,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                ),

                const SizedBox(height: 16),

                AppText.title(titulo),
                const SizedBox(height: 8),

                AppText.body(empresa),
                const SizedBox(height: 12),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: AppText.body(
                        "$bairro - $endereco",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// BOTÕES DE AÇÃO
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (whatsapp.isNotEmpty)
                      _actionButton(
                        icon: Icon(
                          Icons.chat,
                          color: Colors.green.shade700,
                        ),
                        color: Colors.green,
                        label: "WhatsApp",
                        onTap: () => _abrirWhatsApp(context, data),
                      ),
                    if (emailContato.isNotEmpty)
                      _actionButton(
                        icon: Icon(
                          Icons.email,
                          color: Colors.blue.shade700,
                        ),
                        color: Colors.blue,
                        label: "Email",
                        onTap: () => _abrirEmail(context, data),
                      ),
                    if (endereco.isNotEmpty)
                      _actionButton(
                        icon: const Icon(
                          Icons.map_outlined,
                          color: Colors.orange,
                        ),
                        color: Colors.orange,
                        label: "Rota",
                        onTap: () => _abrirMapa(context, "$endereco, $bairro"),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                if (descricao.isNotEmpty)
                  _sectionCard(
                    title: "Descrição da vaga",
                    child: AppText.body(descricao),
                  ),

                if (descricao.isNotEmpty) const SizedBox(height: 12),

                if (requisitos.isNotEmpty)
                  _sectionCard(
                    title: "Requisitos",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: requisitos
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: AppText.body("• $item"),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                if (requisitos.isNotEmpty) const SizedBox(height: 12),

                if (beneficios.isNotEmpty)
                  _sectionCard(
                    title: "Benefícios",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: beneficios
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: AppText.body("• $item"),
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _actionButton({
    required Widget icon,
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
            child: icon,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Future<void> _abrirMapa(BuildContext context, String endereco) async {
    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(endereco)}",
    );

    final ok = await launchUrl(url, mode: LaunchMode.externalApplication);

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Não foi possível abrir o mapa.")),
      );
    }
  }

  Future<void> _abrirWhatsApp(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final number =
        (data['whatsapp'] ?? '').toString().replaceAll(RegExp(r'\D'), '');
    final titulo = data['titulo']?.toString() ?? '';
    final msg = Uri.encodeComponent(
      "Olá, estou interessado na vaga $titulo",
    );

    if (number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("WhatsApp não disponível.")),
      );
      return;
    }

    final url = Uri.parse("https://wa.me/55$number?text=$msg");
    final ok = await launchUrl(url, mode: LaunchMode.externalApplication);

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Não foi possível abrir o WhatsApp.")),
      );
    }
  }

  Future<void> _abrirEmail(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final email = (data['emailContato'] ?? '').toString();
    final titulo = data['titulo']?.toString() ?? '';
    final subject = Uri.encodeComponent("Interesse na vaga $titulo");

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("E-mail não disponível.")),
      );
      return;
    }

    final url = Uri.parse("mailto:$email?subject=$subject");
    final ok = await launchUrl(url, mode: LaunchMode.externalApplication);

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Não foi possível abrir o e-mail.")),
      );
    }
  }
}
