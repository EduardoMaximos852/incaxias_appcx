import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:incaxias_appcx/pages/turismo/turismo_detalhe_page.dart';

class TurismoPage extends StatelessWidget {
  const TurismoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('turismo')
          .orderBy('nome')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 150,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(
              child: Text(
                'Nenhum ponto turístico cadastrado.',
              ),
            ),
          );
        }

        final pontos = snapshot.data!.docs;

        return GridView.builder(
          shrinkWrap: true,
          cacheExtent: 1000,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: pontos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final doc = pontos[index];

            final nome = doc['nome'];
            final imagem = doc['imagem'];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TurismoDetalhePage(
                      docId: doc.id,
                      nome: doc['nome'],
                      imagem: doc['imagem'],
                      descricao: doc['descricao'],
                      latitude: doc['latitude'],
                      longitude: doc['longitude'],
                      cidade: doc['cidade'],
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Hero(
                        tag: doc.id,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: imagem,
                            fit: BoxFit.cover,
                            memCacheWidth: 500,
                            fadeInDuration: const Duration(milliseconds: 150),
                            placeholder: (_, __) => Container(
                              color: Colors.grey.shade200,
                            ),
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          nome,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
