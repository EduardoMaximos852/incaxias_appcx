// ============================================================================
//  PÁGINA 2 — DETALHES DA FARMÁCIA (FarmaciaDetalhe)
// ============================================================================
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class FarmaciaDetalhe extends StatelessWidget {
  const FarmaciaDetalhe({super.key});

  @override
  Widget build(BuildContext context) {
    // RECEBE O ID VIA ARGUMENTOS DA NAVEGAÇÃO
    final farmaciaId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: Icon(Icons.home),
      ),
      appBar: AppBar(
        title: AppText.title('Farmacia'),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('farmacias')
            .doc(farmaciaId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: AppText.body(
                'Farmácia não encontrada',
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final nome = data['nome'] ?? '';
          final bairro = data['bairro'] ?? '';
          final endereco = data['endereco'] ?? '';
          final whatsapp = data['whatsapp'] ?? '';
          final imageUrl = data['imageUrl'] ?? '';
          final avaliacao = (data['avaliacao'] is num)
              ? (data['avaliacao'] as num).toDouble()
              : 0.0;
          final products =
              (data['products'] as List<dynamic>? ?? []).cast<String>();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGEM PRINCIPAL
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: imageUrl.isEmpty
                        ? Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.local_pharmacy, size: 60),
                          )
                        : CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 10),

                // NOME E AVALIAÇÃO
                AppText.body(
                  nome,
                ),

                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    AppText.caption(
                      avaliacao == 0
                          ? 'Sem avaliação'
                          : avaliacao.toStringAsFixed(1),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                const Text(
                  'Endereço:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                AppText.caption(endereco),
                AppText.caption('Bairro: $bairro'),

                const SizedBox(height: 20),

                // BOTÃO WHATSAPP
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () => _openWhatsapp(whatsapp),
                  icon: const Icon(FlutterIcons.whatsapp_faw5d),
                  label: const Text('Chamar no WhatsApp'),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Produtos em Exposição:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                products.isEmpty
                    ? const Text('Nenhum produto cadastrado.')
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: products[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ABRIR WHATSAPP
  void _openWhatsapp(String number) async {
    if (number.isEmpty) return;
    final url = Uri.parse("https://wa.me/$number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

// ============================================================================
//  FIM — Tudo limpo, organizado e funcional
// ============================================================================
