import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'hotel_detalhes_page.dart';

class HotelPage extends StatefulWidget {
  const HotelPage({super.key});

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  Stream<QuerySnapshot> _streamHoteis() {
    return FirebaseFirestore.instance.collection('hoteis').snapshots();
  }

  void _abrirMaps(String endereco) async {
    final url = Uri.encodeFull(
      'https://www.google.com/maps/search/?api=1&query=$endereco',
    );
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.title(
          'Hotéis da Cidade',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamHoteis(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum hotel encontrado.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              final nome = data['nome'] ?? 'Hotel Desconhecido';
              final cidade = data['cidade'] ?? '';
              final bairro = data['bairro'] ?? '';
              final avaliacao = (data['avaliacao'] ?? 0).toDouble();
              final imagemUrl = data['imagemUrl'] ??
                  'https://cdn-icons-png.flaticon.com/512/584/584796.png';
              final endereco = data['endereco'] ?? 'Endereço não informado';
              final preco = (data['preco'] ?? 200).toDouble();

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            HotelDetalhesPage(hotelId: docs[i].id, nome: nome),
                      ),
                    );
                  },
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(imagemUrl),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nome,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 6,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.white70,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: AppText.caption(
                                      "$bairro - $cidade",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _abrirMaps(endereco),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.85),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.map_outlined,
                                            color: Colors.black87,
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          AppText.caption(
                                            "Ver no mapa",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      AppText.caption(
                                        avaliacao.toStringAsFixed(1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Ícones de serviços do hotel
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.pool,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.spa,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.restaurant,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.event,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: AppText.caption(
                                      'Avaliação',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
