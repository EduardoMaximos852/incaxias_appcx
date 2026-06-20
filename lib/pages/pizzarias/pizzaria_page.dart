import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incaxias_appcx/pages/pizzarias/pizzaria_detalhes_page.dart';
import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';

class PizzariaPage extends StatefulWidget {
  const PizzariaPage({super.key});

  @override
  State<PizzariaPage> createState() => _PizzariaPageState();
}

class _PizzariaPageState extends State<PizzariaPage> {
  String busca = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: AppText.title(
          "Pizzarias",
        ),
      ),
      body: Column(
        children: [
          // 🔍 CAMPO DE BUSCA
          Padding(
            padding: const EdgeInsets.all(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 30,
                  ),
                  labelText: "Pizzaria/nome ou bairro...",
                  labelStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (value) =>
                    setState(() => busca = value.toLowerCase()),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pizzarias')
                  .orderBy('nome')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                final filtrados = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final nome = (data['nome'] ?? "").toLowerCase();
                  final bairro = (data['bairro'] ?? "").toLowerCase();
                  final desc = (data['descricao'] ?? "").toLowerCase();

                  return busca.isEmpty ||
                      nome.contains(busca) ||
                      bairro.contains(busca) ||
                      desc.contains(busca);
                }).toList();

                if (filtrados.isEmpty) {
                  return Center(
                    child: AppText.caption("Nenhuma pizzaria encontrada."),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtrados.length,
                  itemBuilder: (context, index) {
                    final doc = filtrados[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final double ultimaNota = double.tryParse(
                          data['ultimaNota']?.toString() ?? "0",
                        ) ??
                        0;

                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 350 + (index * 80)),
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, (1 - value) * 20),
                          child: child,
                        ),
                      ),

                      // 🔥 CARD MODERNIZADO
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PizzariaDetalhesPage(pizzariaId: doc.id),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // FOTO MAIOR
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(18),
                                ),
                                child: Stack(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Image.network(
                                        data['foto'] ?? '',
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: Colors.grey.shade200,
                                          child: const Icon(
                                            Icons.local_pizza,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // ⭐ AVALIAÇÃO NO CANTO SUPERIOR
                                    Positioned(
                                      right: 12,
                                      top: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.65),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              size: 16,
                                              color: Colors.amber,
                                            ),
                                            const SizedBox(width: 4),
                                            AppText.menucultura(
                                              ultimaNota.toStringAsFixed(1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // NOME E INFORMAÇÕES
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // NOME EM DESTAQUE
                                    AppText.subtitle2(
                                      data['nome'] ?? 'Sem nome',
                                    ),

                                    const SizedBox(height: 2),

                                    // BAIRRO
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: Colors.red.shade400,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: AppText.caption(
                                            data['bairro'] ??
                                                'Bairro não informado',
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 2),

                                    // BOTÃO "VER DETALHES"
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Ver detalhes",
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            color: Colors.red.shade600,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 25,
                                          color: Colors.red.shade600,
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
          ),
        ],
      ),
    );
  }
}
