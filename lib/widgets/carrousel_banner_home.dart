import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CarrosselReelsHome extends StatefulWidget {
  const CarrosselReelsHome({super.key});

  @override
  State<CarrosselReelsHome> createState() => _CarrosselReelsHomeState();
}

class _CarrosselReelsHomeState extends State<CarrosselReelsHome> {
  final PageController controller = PageController(
    viewportFraction: 0.78, // espaço entre cards (menor = mais espaço)
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reels_home')
            .orderBy('title')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return PageView.builder(
            controller: controller,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  // Calcula a distância do item para o centro
                  double value = 1.0;
                  if (controller.position.haveDimensions) {
                    value = controller.page! - index;
                    value = (1 - (value.abs() * 0.25)).clamp(0.85, 1.0);
                  }

                  return Center(
                    child: Transform.scale(
                      scale: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _buildCard(docs[index]),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCard(QueryDocumentSnapshot doc) {
    final imageUrl = doc['imageUrl'];
    final title = doc['title'];
    final action = doc['action'];

    return GestureDetector(
      onTap: () => _executarAcao(context, action),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withAlpha(1),
                    Colors.black.withAlpha(6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Título e botão
            Positioned(
              bottom: 18,
              left: 18,
              right: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _executarAcao(context, action),
                    child: const Text("Ver"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _executarAcao(BuildContext context, String action) {
    switch (action) {
      case "promocoes":
        Navigator.pushNamed(context, "/promocoes");
        break;
      case "eventos":
        Navigator.pushNamed(context, "/eventos");
        break;
      case "turismo":
        Navigator.pushNamed(context, "/turismo");
        break;
      default:
        print("Ação desconhecida: $action");
    }
  }
}
