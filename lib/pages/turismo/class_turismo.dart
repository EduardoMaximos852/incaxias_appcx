import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TurismoDetalhePages extends StatelessWidget {
  final String nome;
  final String imagem;
  final String descricao;
  final double latitude;
  final double longitude;
  final String cidade;

  const TurismoDetalhePages({
    super.key,
    required this.nome,
    required this.imagem,
    required this.descricao,
    required this.latitude,
    required this.longitude,
    required this.cidade,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nome)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: imagem,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.redAccent),
                      const SizedBox(width: 6),
                      Text(cidade, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    descricao,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final url =
                            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                        final uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Não foi possível abrir o mapa.'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.map),
                      label: const Text('Ver no Google Maps'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
