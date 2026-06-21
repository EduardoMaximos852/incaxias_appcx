import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incaxias_appcx/pages/bares/bares_detalhes_page.dart';
import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import 'package:incaxias_appcx/widgets/whatssap_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class BaresPage extends StatefulWidget {
  const BaresPage({super.key});

  @override
  State<BaresPage> createState() => _BaresPageState();
}

class _BaresPageState extends State<BaresPage> {
  String _busca = '';

  // Abre conversa no WhatsApp
  Future<void> _abrirWhatsApp(String numero, String nome) async {
    if (numero.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Número de WhatsApp não informado')),
      );
      return;
    }

    final cleaned = numero.replaceAll(RegExp(r'[^0-9]'), '');
    final url = Uri.parse(
      'https://wa.me/$cleaned?text=${Uri.encodeComponent('Olá! Gostaria de saber mais sobre $nome')}',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o WhatsApp')),
      );
    }
  }

  // Stream de leitura da coleção "bares"
  Stream<QuerySnapshot> _streamBares() {
    return FirebaseFirestore.instance.collection('bares').snapshots();
  }

  // Filtra os resultados da busca
  List<QueryDocumentSnapshot> _filtrar(List<QueryDocumentSnapshot> docs) {
    if (_busca.trim().isEmpty) return docs;
    final texto = _busca.toLowerCase();
    return docs.where((doc) {
      final nome = (doc['nome'] ?? '').toString().toLowerCase();
      return nome.contains(texto);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.title("Bares de Caxias"),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          // Campo de busca
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (v) => setState(() => _busca = v),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Buscar bar pelo nome...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Lista de bares
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _streamBares(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro: ${snapshot.error.toString()}'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = _filtrar(snapshot.data!.docs);

                if (docs.isEmpty) {
                  return const Center(child: Text('Nenhum bar encontrado.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final nome = doc['nome'] ?? '';
                    final imagem = doc['imagemUrl'] ?? '';
                    final whatsapp = doc['whatsapp'] ?? '';
                    final status = doc['status'] ?? 'Fechado';
                    final avaliacao = (doc['avaliacao'] ?? 0).toDouble();

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BarDetalhesPage(barId: doc.id, nome: nome),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(2, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Imagem do bar
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(14),
                                topRight: Radius.circular(14),
                              ),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  imagem,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stack) =>
                                      Container(
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: Icon(
                                        Icons.storefront,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Informações
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppText.body(
                                          nome,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: status == 'Aberto'
                                              ? Colors.green.shade50
                                              : Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                            color: status == 'Aberto'
                                                ? Colors.green.shade800
                                                : Colors.red.shade700,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      AppText.body(
                                        avaliacao.toStringAsFixed(1),
                                      ),
                                      const Spacer(),
                                      if (whatsapp.isNotEmpty)
                                        IconButton(
                                          onPressed: () =>
                                              _abrirWhatsApp(whatsapp, nome),
                                          icon: const WhatsAppIconSimple(
                                              size: 28),
                                          color: Colors.green,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
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
