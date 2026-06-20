import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:icons_flutter/icons_flutter.dart';

class PizzariaDetalhesPage extends StatefulWidget {
  final String pizzariaId;
  const PizzariaDetalhesPage({super.key, required this.pizzariaId});

  @override
  State<PizzariaDetalhesPage> createState() => _PizzariaDetalhesPageState();
}

class _PizzariaDetalhesPageState extends State<PizzariaDetalhesPage> {
  double _rating = 0;
  final TextEditingController _comentarioController = TextEditingController();

  // Enviar avaliação
  Future<void> _enviarAvaliacao() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione uma nota para avaliar.")),
      );
      return;
    }

    try {
      // Adiciona avaliação na subcoleção
      await FirebaseFirestore.instance
          .collection('pizzarias')
          .doc(widget.pizzariaId)
          .collection('avaliacoes')
          .add({
        "nota": _rating,
        "comentario": _comentarioController.text,
        "data": Timestamp.now(),
      });

      // Atualiza o campo 'ultimaNota' do documento da pizzaria
      await FirebaseFirestore.instance
          .collection('pizzarias')
          .doc(widget.pizzariaId)
          .update({'ultimaNota': _rating});

      // Limpa rating e comentário
      setState(() {
        _rating = 0;
        _comentarioController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Avaliação enviada! Obrigado.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao enviar avaliação: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: AppText.title("Pizzaria"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pizzarias')
            .doc(widget.pizzariaId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final nome = data['nome'] ?? "";
          final foto = data['foto'] ?? "";
          final descricao = data['descricao'] ?? "";
          final bairro = data['bairro'] ?? "";
          final endereco = data['endereco'] ?? "";
          final cardapio = data['cardapio'] ?? "";
          final telefone = data['telefone'] ?? "";
          final whatsapp = data['whatsapp'] ?? "";
          final ultimaNota = (data['ultimaNota'] ?? 0).toDouble();
          final fotosSabores = List<String>.from(data['fotosSabores'] ?? []);
          final precos = Map<String, dynamic>.from(data['precos'] ?? {});

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Carrossel principal
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CarouselSlider(
                  items: [
                    Image.network(
                      foto,
                      width: double.infinity,
                      height: 240,
                      fit: BoxFit.cover,
                    ),
                  ],
                  options: CarouselOptions(height: 240, viewportFraction: 1),
                ),
              ),
              const SizedBox(height: 16),

              // Nome da pizzaria
              AppText.title2(
                nome,
              ),
              const SizedBox(height: 2),

              // Bairro
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.red),
                  const SizedBox(width: 4),
                  AppText.caption(
                    bairro,
                  ),
                ],
              ),

              const SizedBox(height: 2),

              // Avaliação mais alta
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  AppText.caption(
                    "Última nota: ${ultimaNota.toStringAsFixed(1)}",
                  ),
                ],
              ),

              const SizedBox(height: 2),

              // Descrição
              AppText.escrito(
                descricao,
              ),
              const SizedBox(height: 2),

              // Endereço
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppText.escrito(
                      "Endereço: $endereco",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final url =
                            "https://www.google.com/maps/search/?api=1&query=$endereco";
                        launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      icon: const Icon(Icons.pin_drop,
                          color: Colors.white, size: 38),
                      label: AppText.button(''),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              // Contato
              if (telefone.isNotEmpty)
                _contactTile(
                  icon: Icons.phone,
                  text: telefone,
                  onTap: () => launchUrl(Uri.parse("tel:$telefone")),
                ),

              if (whatsapp.isNotEmpty)
                _contactTile(
                  icon: FlutterIcons.whatsapp_faw5d,
                  text: whatsapp,
                  onTap: () => launchUrl(
                    Uri.parse("https://wa.me/55$whatsapp?text=Olá!"),
                    mode: LaunchMode.externalApplication,
                  ),
                ),

              // Cardápio online
              if (cardapio.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () => launchUrl(
                    Uri.parse(cardapio),
                    mode: LaunchMode.externalApplication,
                  ),
                  icon: const Icon(Icons.menu_book),
                  label: AppText.button("Abrir Cardápio"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                  ),
                ),

              const SizedBox(height: 2),

              // Carrossel sabores
              if (fotosSabores.isNotEmpty)
                CarouselSlider(
                  items: fotosSabores
                      .map(
                        (img) => ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            img,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                    height: 160,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.78,
                  ),
                ),

              const SizedBox(height: 20),

              // Preços
              if (precos.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.subtitle(
                      "Preços das Pizzas",
                    ),
                    const SizedBox(height: 8),
                    ...precos.entries.map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText.caption(
                              e.key.toUpperCase(),
                            ),
                            AppText.valorElipse(
                              "R\$ ${e.value},00",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 2),

              // Avaliação do usuário
              const Text(
                "Avalie esta Pizzaria",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    icon: Icon(
                      i < _rating ? Icons.star : Icons.star_border,
                      size: 32,
                      color: Colors.amber,
                    ),
                    onPressed: () =>
                        setState(() => _rating = (i + 1).toDouble()),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              TextField(
                controller: _comentarioController,
                decoration: InputDecoration(
                  hintText: "Deixe um comentário (opcional)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _enviarAvaliacao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: AppText.button("Enviar Avaliação"),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _contactTile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 32, color: Colors.green.shade700),
      title: Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    );
  }
}
