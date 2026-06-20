import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import 'package:url_launcher/url_launcher.dart';

class HotelDetalhesPage extends StatefulWidget {
  final String hotelId;
  final String nome;

  const HotelDetalhesPage({
    super.key,
    required this.hotelId,
    required this.nome,
  });

  @override
  State<HotelDetalhesPage> createState() => _HotelDetalhesPageState();
}

class _HotelDetalhesPageState extends State<HotelDetalhesPage> {
  final _nomeController = TextEditingController();
  final _dataEntradaController = TextEditingController();
  final _dataSaidaController = TextEditingController();
  String quartoSelecionado = '';

  Future<DocumentSnapshot> _getHotelData() async {
    return FirebaseFirestore.instance
        .collection('hoteis')
        .doc(widget.hotelId)
        .get();
  }

  Stream<QuerySnapshot> _streamQuartos() {
    return FirebaseFirestore.instance
        .collection('hoteis')
        .doc(widget.hotelId)
        .collection('quartos')
        .snapshots();
  }

  Stream<QuerySnapshot> _streamGaleria() {
    return FirebaseFirestore.instance
        .collection('hoteis')
        .doc(widget.hotelId)
        .collection('galeria')
        .snapshots();
  }

  Future<void> _enviarReserva() async {
    if (_nomeController.text.isEmpty ||
        _dataEntradaController.text.isEmpty ||
        _dataSaidaController.text.isEmpty ||
        quartoSelecionado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText.caption('Preencha todos os campos para reservar.'),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('hoteis')
        .doc(widget.hotelId)
        .collection('reservas')
        .add({
      'nomeCliente': _nomeController.text,
      'dataEntrada': _dataEntradaController.text,
      'dataSaida': _dataSaidaController.text,
      'quarto': quartoSelecionado,
      'status': 'pendente',
      'dataReserva': DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: AppText.caption('Reserva enviada com sucesso!')),
    );

    _nomeController.clear();
    _dataEntradaController.clear();
    _dataSaidaController.clear();
    setState(() {
      quartoSelecionado = '';
    });
  }

  void _abrirWhatsapp(String numero) async {
    final uri = Uri.parse("https://wa.me/$numero");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: AppText.title(
            widget.nome,
          )),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getHotelData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          final descricao = data['descricao'] ?? '';
          final endereco = data['endereco'] ?? '';
          final videoUrl = data['videoUrl'] ?? '';
          final whatsapp = data['whatsapp'] ?? '';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🎥 Vídeo (link)
                if (videoUrl.isNotEmpty)
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      child: Image.network(videoUrl, fit: BoxFit.cover),
                    ),
                  ),

                // 📍 Informações gerais
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.subtitle(
                        widget.nome,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: AppText.caption(
                              endereco,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AppText.caption(
                        descricao,
                      ),
                    ],
                  ),
                ),

                // 🖼️ Galeria
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: AppText.subtitle2(
                    'Galeria',
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _streamGaleria(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();
                      final docs = snapshot.data!.docs;
                      if (docs.isEmpty) {
                        return const Center(child: Text('Sem imagens.'));
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: docs.length,
                        itemBuilder: (context, i) {
                          final img = docs[i]['imagemUrl'] ?? '';
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(img),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // 🛏️ Tipos de quarto
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppText.subtitle2(
                    'Tipos de Quartos',
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _streamQuartos(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    final quartos = snapshot.data!.docs;
                    return Column(
                      children: quartos.map((q) {
                        final data = q.data() as Map<String, dynamic>;
                        return Card(
                          margin: const EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                quartoSelecionado = data['tipo'];
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    data['imagemUrl'] ?? '',
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.caption(
                                        data['tipo'] ?? '',
                                      ),
                                      AppText.body(
                                        'Capacidade: ${data['pessoas']} pessoas',
                                      ),
                                      const SizedBox(height: 4),
                                      AppText.valorElipse(
                                        'R\$ ${data['preco']}/noite',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // 📅 Formulário de reserva
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => _abrirWhatsapp(whatsapp),
                        icon: const Icon(Icons.phone, color: Colors.white),
                        label: AppText.button('Falar com o hotel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
