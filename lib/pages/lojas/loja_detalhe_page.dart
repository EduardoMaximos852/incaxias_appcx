import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'produto_detalhe_page.dart';

class LojaDetalhePage extends StatelessWidget {
  final String lojaId;
  const LojaDetalhePage({super.key, required this.lojaId});

  void abrirWhatsApp(String numero, String mensagem) async {
    final url = Uri.parse(
      "https://wa.me/$numero?text=${Uri.encodeComponent(mensagem)}",
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Erro ao abrir WhatsApp");
    }
  }

  @override
  Widget build(BuildContext context) {
    final lojaRef = FirebaseFirestore.instance.collection('lojas').doc(lojaId);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: FutureBuilder<DocumentSnapshot>(
        future: lojaRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Loja não encontrada'));
          }

          final loja = snapshot.data!;
          final nome = loja['nome'] ?? '';
          final descricao = loja['descricao'] ?? '';
          final imagemUrl = loja['imagemUrl'] ?? '';
          final whatsapp = loja['whatsapp'] ?? '';

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // 🔝 AppBar com imagem
                  SliverAppBar(
                    expandedHeight: 220,
                    pinned: true,
                    backgroundColor: Colors.black87,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        imagemUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),

                  // 🏪 Cabeçalho com informações da loja
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(26),
                          topRight: Radius.circular(26),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.title2(
                              nome,
                            ),
                            AppText.subtitle(
                              descricao,
                            ),
                            const SizedBox(height: 16),
                            if (whatsapp.isNotEmpty)
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => abrirWhatsApp(
                                  whatsapp
                                      .replaceAll('+', '')
                                      .replaceAll(' ', ''),
                                  'Olá! Gostaria de informações sobre os produtos da loja $nome.',
                                ),
                                icon: const Icon(
                                  FlutterIcons.whatsapp_faw,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                label: AppText.button(
                                  'Falar com a loja',
                                ),
                              ),
                            SizedBox(height: 16),
                            AppText.subtitle2(
                              "Produtos",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 🛍️ Grid de produtos
                  StreamBuilder<QuerySnapshot>(
                    stream: lojaRef.collection('produtos').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(
                              child:
                                  AppText.caption('Nenhum produto disponível'),
                            ),
                          ),
                        );
                      }

                      final produtos = snapshot.data!.docs;

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.75,
                          ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final produto = produtos[index];
                            final imagem = produto['imagemUrl'] ?? '';
                            final nome = produto['nome'] ?? '';
                            final preco = produto['preco'] ?? '';

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProdutoDetalhePage(
                                      lojaId: lojaId,
                                      produtoId: produto.id,
                                    ),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: 'produto_${produto.id}',
                                child: Material(
                                  color: Colors.transparent,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 6,
                                          offset: const Offset(2, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        // 🖼️ Imagem centralizada e ajustada
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Center(
                                                child: AspectRatio(
                                                  aspectRatio:
                                                      1, // mantém proporção quadrada
                                                  child: Image.network(
                                                    imagem,
                                                    fit: BoxFit
                                                        .contain, // ajusta e centraliza
                                                    alignment: Alignment.center,
                                                    errorBuilder: (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return const Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        size: 50,
                                                        color: Colors.grey,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // 🏷️ Informações
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText.escrito(
                                                nome,
                                              ),
                                              const SizedBox(height: 2),
                                              AppText.valorElipse(
                                                "R\$ $preco",
                                              ),
                                              const SizedBox(height: 6),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }, childCount: produtos.length),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // 🟢 Botão flutuante WhatsApp
              if (whatsapp.isNotEmpty)
                Positioned(
                  bottom: 18,
                  right: 18,
                  child: FloatingActionButton(
                    backgroundColor: Colors.green.shade600,
                    onPressed: () => abrirWhatsApp(
                      whatsapp.replaceAll('+', '').replaceAll(' ', ''),
                      'Olá! Gostaria de falar com a loja $nome.',
                    ),
                    child: const Icon(
                      FlutterIcons.whatsapp_faw,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
