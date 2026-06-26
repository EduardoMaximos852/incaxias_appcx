import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoriasGrid extends StatelessWidget {
  const CategoriasGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('categorias').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox(
            height: 80,
            child: Center(
              child: Text(
                'Nenhuma categoria encontrada.',
              ),
            ),
          );
        }

        final categorias = snapshot.data!.docs;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          cacheExtent: 1000,
          padding: const EdgeInsets.all(8),
          itemCount: categorias.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final data = categorias[index].data() as Map<String, dynamic>;

            final nome = data['nome'] ?? 'Sem nome';
            final iconeUrl = data['iconeUrl'] ?? '';
            final rota = data['rota'] ?? '';

            return GestureDetector(
              onTap: () {
                if (rota.isNotEmpty) {
                  Navigator.pushNamed(context, rota);
                }
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(5),
                    child: CachedNetworkImage(
                      imageUrl: iconeUrl,
                      width: 40,
                      height: 40,
                      memCacheWidth: 120,
                      fadeInDuration: const Duration(milliseconds: 150),
                      placeholder: (_, __) => const Icon(Icons.image),
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
                  Text(
                    nome,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
