import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('banner').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'Nenhum banner disponível',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        final banners = snapshot.data!.docs;

        return SizedBox(
          height: 220,
          child: Column(
            children: [
              Expanded(
                child: Swiper(
                  itemCount: banners.length,
                  autoplay: banners.length > 1,
                  autoplayDelay: 3500,
                  duration: 500,
                  loop: banners.length > 1,
                  onIndexChanged: (index) {
                    if (_current != index && mounted) {
                      setState(() {
                        _current = index;
                      });
                    }
                  },
                  itemBuilder: (context, index) {
                    final data = banners[index].data() as Map<String, dynamic>;

                    final imageUrl = data['imageUrl'] ?? '';

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 150),
                          placeholder: (_, __) => Container(
                            color: Colors.grey.shade200,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  banners.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _current == index ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _current == index
                          ? Colors.blue
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
