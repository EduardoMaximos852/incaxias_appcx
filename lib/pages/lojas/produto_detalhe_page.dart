import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProdutoDetalhePage extends StatelessWidget {
  final String lojaId;
  final String produtoId;

  const ProdutoDetalhePage({
    super.key,
    required this.lojaId,
    required this.produtoId,
  });

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
    final produtoRef = FirebaseFirestore.instance
        .collection('lojas')
        .doc(lojaId)
        .collection('produtos')
        .doc(produtoId);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: FutureBuilder<DocumentSnapshot>(
        future: produtoRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Produto não encontrado'));
          }

          final produto = snapshot.data!;
          final imagemUrl = produto['imagemUrl'] ?? '';
          final nome = produto['nome'] ?? '';
          final preco = (produto['preco'] ?? 0).toDouble();
          final precoPromocional = (produto['precoPromocional'] ?? preco)
              .toDouble();
          final promocaoAtiva = produto['promocaoAtiva'] ?? false;

          final descricao = produto['descricao'] ?? '';
          final detalhes = produto['detalhes'] ?? '';
          final whatsapp = produto['whatsapp'] ?? '';

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 340,
                    backgroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        tag: 'produto_$produtoId',
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(imagemUrl, fit: BoxFit.cover),
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black54],
                                ),
                              ),
                            ),

                            // 🔥 TAG PROMOCIONAL NO TOPO DA FOTO
                            if (promocaoAtiva)
                              Positioned(
                                top: 30,
                                left: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.local_offer,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Promoção",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ==================================
                          // 🔥 Nome + Preço / Preço Promocional
                          // ==================================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        nome,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    if (promocaoAtiva)
                                      const Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                        size: 32,
                                      ),
                                  ],
                                ),
                              ),

                              promocaoAtiva
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // 🔥 Preço promocional
                                        Text(
                                          'R\$ ${precoPromocional.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        // preço original riscado
                                        Text(
                                          'R\$ ${preco.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.teal.shade600,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'R\$ ${preco.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Text(
                            descricao,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (detalhes.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Mais informações",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    detalhes,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              if (whatsapp.isNotEmpty)
                Positioned(
                  bottom: 24,
                  left: 20,
                  right: 20,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: Colors.greenAccent,
                      elevation: 6,
                    ),
                    onPressed: () => abrirWhatsApp(
                      whatsapp.replaceAll('+', '').replaceAll(' ', ''),
                      'Olá! Tenho interesse no produto $nome.',
                    ),
                    icon: const Icon(
                      FlutterIcons.whatsapp_faw5d,
                      size: 26,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Falar com o vendedor",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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
