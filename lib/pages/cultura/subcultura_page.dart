import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import 'cultura_detalhe_page.dart'; // importa a página de detalhes

class SubCulturaPage extends StatelessWidget {
  final String categoriaId;
  final String nomeCategoria;

  const SubCulturaPage({
    super.key,
    required this.categoriaId,
    required this.nomeCategoria,
  });

  @override
  Widget build(BuildContext context) {
    final subRef = FirebaseFirestore.instance
        .collection('cultura')
        .doc(categoriaId)
        .collection('subcategorias');

    return Scaffold(
      appBar: AppBar(
        title: AppText.title(nomeCategoria.replaceAll('_', ' ').toUpperCase()),
        backgroundColor: AppColors.primary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: subRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: AppText.menucultura('Erro ao carregar subcategorias.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final subDocs = snapshot.data!.docs;
          if (subDocs.isEmpty) {
            return Center(
                child: AppText.menucultura('Nenhum item nesta categoria.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: subDocs.length,
            itemBuilder: (context, index) {
              final data = subDocs[index].data() as Map<String, dynamic>;
              final nome = data['nome'] ?? '';
              final imageUrl = data['imageUrl'] ?? '';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CulturaDetalhePage(
                        categoriaId: categoriaId,
                        subcategoriaId: subDocs[index].id,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 40),
                      ),
                      Container(
                        color: Colors.white.withValues(alpha: 0.6),
                        width: double.infinity,
                        padding: const EdgeInsets.all(6),
                        child: AppText.caption(
                          nome,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
