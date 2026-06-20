import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class CulturaDetalhePage extends StatefulWidget {
  final String categoriaId;
  final String subcategoriaId;

  const CulturaDetalhePage({
    super.key,
    required this.categoriaId,
    required this.subcategoriaId,
  });

  @override
  State<CulturaDetalhePage> createState() => _CulturaDetalhePageState();
}

class _CulturaDetalhePageState extends State<CulturaDetalhePage> {
  Map<String, dynamic>? dados;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final docRef = FirebaseFirestore.instance
        .collection('cultura')
        .doc(widget.categoriaId)
        .collection('subcategorias')
        .doc(widget.subcategoriaId);

    final snapshot = await docRef.get();

    if (snapshot.exists) {
      setState(() {
        dados = snapshot.data()!;
      });
    }
  }

  Future<void> _abrirLink(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dados == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List imagens = dados!['imagens'] ?? [];
    final String historia = dados!['historia'] ?? 'Sem história disponível';
    final String? videoUrl = dados!['videoUrl'];
    final String? contato = dados!['contato'];
    final String? whatsapp = dados!['whatsapp'];
    final String? localAgenda = dados!['localAgenda'];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: const Icon(Icons.home),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: AppText.title(dados!['nome'] ?? 'Detalhes da Cultura'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              );
              // Lógica para compartilhar
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HISTÓRIA
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppText.body(
                historia,
              ),
            ),

            // GALERIA DE IMAGENS
            if (imagens.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppText.caption(
                  'Galeria de Imagens',
                ),
              ),
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: imagens.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: imagens[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, size: 40),
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 20),

            // LOCAL DA AGENDA
            if (localAgenda != null && localAgenda.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppText.body(
                        'Local da agenda: $localAgenda',
                      ),
                    ),
                  ],
                ),
              ),

            // CONTATOS
            if (contato != null || whatsapp != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.caption(
                      'Contatos',
                    ),
                    const SizedBox(height: 10),
                    if (contato != null)
                      Row(
                        children: [
                          const Icon(Icons.phone, color: Colors.deepPurple),
                          const SizedBox(width: 8),
                          Text(contato),
                        ],
                      ),
                    if (whatsapp != null)
                      InkWell(
                        onTap: () {
                          final url = "https://wa.me/$whatsapp";
                          _abrirLink(url);
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.green),
                            const SizedBox(width: 8),
                            AppText.button('WhatsApp: $whatsapp'),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // BOTÃO DE VÍDEO
            if (videoUrl != null && videoUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _abrirLink(videoUrl),
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text('Ver vídeo cultural'),
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
