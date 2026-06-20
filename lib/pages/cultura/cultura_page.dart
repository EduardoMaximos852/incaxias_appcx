import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incaxias_appcx/pages/cultura/subcultura_page.dart';
import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';

class CulturaPage extends StatelessWidget {
  const CulturaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference culturaRef =
        FirebaseFirestore.instance.collection('cultura');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: AppText.title(
          'Cultura de Caxias',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: culturaRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: AppText.menucultura('Erro ao carregar cultura.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(
              child:
                  AppText.menucultura('Nenhuma categoria cultural encontrada.'),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final nomeCategoria = doc.id; // nome do documento (ex: bumba_boi)
              final data = doc.data() as Map<String, dynamic>? ?? {};
              final imageUrl = data['imageUrl'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: imageUrl.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                          radius: 26,
                        )
                      : const CircleAvatar(child: Icon(Icons.image)),
                  title: AppText.menutitle(
                    nomeCategoria.replaceAll('_', ' ').toUpperCase(),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black54,
                  ),
                  onTap: () {
                    // ✅ Aqui passamos os argumentos corretamente
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SubCulturaPage(
                          categoriaId: doc.id,
                          nomeCategoria: nomeCategoria,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
