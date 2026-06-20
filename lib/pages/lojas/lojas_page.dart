import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'loja_detalhe_page.dart';

class LojasPage extends StatefulWidget {
  const LojasPage({super.key});

  @override
  State<LojasPage> createState() => _LojasPageState();
}

class _LojasPageState extends State<LojasPage> {
  String search = "";

  void abrirWhatsApp(String numero, String nomeLoja) async {
    final url = Uri.parse(
      "https://wa.me/$numero?text=Olá! Gostaria de saber mais sobre a loja $nomeLoja.",
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Erro ao abrir WhatsApp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: AppText.title(
          'Lojas',
        ),
      ),
      body: Column(
        children: [
          // 🔍 Campo de busca
          /// 🔎 BUSCA PADRÃO MELHORADA
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 0.6,
                ),
              ),
              child: TextField(
                style: const TextStyle(
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  hintText: "Buscar por vaga, empresa ou bairro...",
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.black54,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                ),
                onChanged: (value) {
                  setState(() => search = value.trim().toLowerCase());
                },
              ),
            ),
          ),

          // 🏪 Lista de lojas
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('lojas').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Nenhuma loja cadastrada.'));
                }

                final lojas = snapshot.data!.docs.where((doc) {
                  final nome = (doc['nome'] ?? '').toString().toLowerCase();
                  final bairro = (doc['bairro'] ?? '').toString().toLowerCase();
                  return nome.contains(search) || bairro.contains(search);
                }).toList();

                if (lojas.isEmpty) {
                  return const Center(child: Text('Nenhuma loja encontrada.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  itemCount: lojas.length,
                  itemBuilder: (context, index) {
                    final loja = lojas[index];
                    final id = loja.id;
                    final nome = loja['nome'] ?? '';
                    final imagemUrl = loja['imagemUrl'] ?? '';
                    final descricao = loja['descricao'] ?? '';
                    final bairro = loja['bairro'] ?? 'Bairro não informado';
                    final whatsapp = loja['whatsapp'] ?? '';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LojaDetalhePage(lojaId: id),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 🖼️ Imagem da loja
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                              ),
                              child: Image.network(
                                imagemUrl,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) {
                                  return Container(
                                    color: Colors.grey.shade200,
                                    height: 80,
                                    width: 80,
                                    child: const Icon(
                                      Icons.storefront,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),

                            // 🏪 Informações da loja
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText.caption(
                                      nome,
                                    ),
                                    AppText.escrito(
                                      bairro,
                                    ),
                                    AppText.escrito(
                                      descricao,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // 💬 Botão WhatsApp
                            if (whatsapp.isNotEmpty)
                              IconButton(
                                icon: const Icon(
                                  FlutterIcons.whatsapp_faw5d,
                                  color: Colors.green,
                                  size: 28,
                                ),
                                onPressed: () => abrirWhatsApp(
                                  whatsapp
                                      .replaceAll('+', '')
                                      .replaceAll(' ', ''),
                                  nome,
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
