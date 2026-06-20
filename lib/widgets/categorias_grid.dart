import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoriasGrid extends StatelessWidget {
  const CategoriasGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categorias').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final categorias = snapshot.data!.docs;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(5),
                    child: CachedNetworkImage(
                      imageUrl: iconeUrl,
                      width: 40,
                      height: 40,
                      placeholder: (context, url) => const Icon(Icons.image),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
                  //const SizedBox(height: 6),
                  Text(
                    nome,
                    textAlign: TextAlign.center,
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
