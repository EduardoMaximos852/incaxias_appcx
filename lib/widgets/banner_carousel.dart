import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
        if (!snapshot.hasData) {
          return SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final banners = snapshot.data!.docs;

        return Column(
          children: [
            CarouselSlider(
              items: banners.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () {
                    // Ação ao clicar (ex: abrir página)
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: data['imageUrl'] ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade300,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 200,
                viewportFraction: 0.9,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                onPageChanged: (index, reason) {
                  setState(() => _current = index);
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: banners.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => setState(() => _current = entry.key),
                  child: Container(
                    width: _current == entry.key ? 12.0 : 8.0,
                    height: _current == entry.key ? 12.0 : 8.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == entry.key
                          ? Colors.blue.shade700
                          : Colors.grey.shade400,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
