import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incaxias_appcx/theme/app_text.dart';

class BarDetalhesPage extends StatelessWidget {
  final String barId;
  final String nome;

  const BarDetalhesPage({super.key, required this.barId, required this.nome});

  // Subcoleção de imagens do ambiente
  Stream<QuerySnapshot> _streamAmbiente() {
    return FirebaseFirestore.instance
        .collection('bares')
        .doc(barId)
        .collection('galeria')
        .snapshots();
  }

  // Subcoleção de bebidas
  Stream<QuerySnapshot> _streamBebidas() {
    return FirebaseFirestore.instance
        .collection('bares')
        .doc(barId)
        .collection('bebidas')
        .orderBy('nome')
        .snapshots();
  }

  // Subcoleção de comidas
  Stream<QuerySnapshot> _streamComidas() {
    return FirebaseFirestore.instance
        .collection('bares')
        .doc(barId)
        .collection('comidas')
        .orderBy('nome')
        .snapshots();
  }

  // Subcoleção de programações
  Stream<QuerySnapshot> _streamProgramacoes() {
    return FirebaseFirestore.instance
        .collection('bares')
        .doc(barId)
        .collection('programacoes')
        .orderBy('dia')
        .snapshots();
  }

  // Dados gerais (ex.: endereço)
  Future<DocumentSnapshot> _getBarData() async {
    return FirebaseFirestore.instance.collection('bares').doc(barId).get();
  }

  Widget _buildTitulo(String titulo) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: AppText.subtitle(
          titulo,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: AppText.body(
          nome,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getBarData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          final endereco = data['endereco'] ?? 'Localização não informada';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📍 Endereço
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: Colors.redAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppText.body(
                          endereco,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🏠 Galeria do ambiente
                _buildTitulo("Ambiente"),
                SizedBox(
                  height: 140,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _streamAmbiente(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final docs = snapshot.data?.docs ?? [];
                      if (docs.isEmpty) {
                        return Center(
                          child: AppText.body("Nenhuma imagem do ambiente."),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final imagem = docs[index]['imagemUrl'] ?? '';
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(imagem),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(2, 3),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // 🍹 Bebidas
                _buildTitulo("Bebidas e Drinks"),
                SizedBox(
                  height: 200,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _streamBebidas(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final docs = snapshot.data?.docs ?? [];
                      if (docs.isEmpty) {
                        return Center(
                          child: AppText.body("Nenhuma bebida cadastrada."),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final bebida =
                              docs[index].data() as Map<String, dynamic>;
                          final imagem = bebida['imagemUrl'] ?? '';
                          final nome = bebida['nome'] ?? '';
                          final preco = bebida['preco'] ?? '';

                          return Container(
                            width: 160,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(2, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    imagem,
                                    height: 110,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.body(
                                        nome,
                                      ),
                                      const SizedBox(height: 4),
                                      AppText.valorElipse(
                                        "R\$ ${preco.toString()}",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // 🍽️ Comidas e Porções
                _buildTitulo("Comidas e Porções"),
                SizedBox(
                  height: 200,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _streamComidas(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final docs = snapshot.data?.docs ?? [];
                      if (docs.isEmpty) {
                        return Center(
                          child: AppText.body("Nenhum prato cadastrado."),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final comida =
                              docs[index].data() as Map<String, dynamic>;
                          final imagem = comida['imagemUrl'] ?? '';
                          final nome = comida['nome'] ?? '';
                          final preco = comida['preco'] ?? '';

                          return Container(
                            width: 160,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(2, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    imagem,
                                    height: 110,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.body(
                                        nome,
                                      ),
                                      const SizedBox(height: 4),
                                      AppText.valorElipse(
                                        "R\$ ${preco.toString()}",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // 🎶 Programações
                _buildTitulo("Programação da Semana"),
                StreamBuilder<QuerySnapshot>(
                  stream: _streamProgramacoes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child:
                              AppText.body("Nenhuma programação disponível."),
                        ),
                      );
                    }

                    return Column(
                      children: docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.subtitle(
                                  data['dia'] ?? '',
                                ),
                                const SizedBox(height: 2),
                                AppText.escrito(
                                  data['evento'] ?? '',
                                ),
                                const SizedBox(height: 2),
                                AppText.escrito(
                                  "Horário: ${data['horario'] ?? ''}",
                                ),
                                const SizedBox(height: 4),
                                AppText.escrito(data['descricao'] ?? ''),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
