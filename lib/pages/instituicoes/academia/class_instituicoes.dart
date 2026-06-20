import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InstituicaoDetalhePage extends StatelessWidget {
  final String nome;
  final String imagem;
  final String descricao;
  final String link;
  final String rota; // 🔸 rota dinâmica

  const InstituicaoDetalhePage({
    super.key,
    required this.nome,
    required this.imagem,
    required this.descricao,
    required this.link,
    required this.rota,
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
                  const SizedBox(height: 2),
                  Text(
                    descricao,
                    style: const TextStyle(fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse(link);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Não foi possível abrir o link.'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.language),
                    label: const Text('Acessar Site'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (link.isNotEmpty) {
                        Navigator.pushNamed(context, '/academia');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rota não configurada.'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.person_search),
                    label: const Text('Ver detalhes'),
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
