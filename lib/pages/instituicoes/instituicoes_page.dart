import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:incaxias_appcx/pages/instituicoes/class_instituicoes.dart';

class InstituicoesPage extends StatelessWidget {
  const InstituicoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('instituicoes')
          .orderBy('nome')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhuma instituição cadastrada.'));
        }

        final instituicoes = snapshot.data!.docs;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // três colunas
            childAspectRatio: 0.8,
            crossAxisSpacing: 8,
            mainAxisSpacing: 4,
          ),
          itemCount: instituicoes.length,
          itemBuilder: (context, index) {
            final doc = instituicoes[index];

            // 🌟 PASSO CRUCIAL: Mapeia os dados internos do documento do Firebase
            final data = doc.data() as Map<String, dynamic>;

            final nome = data['nome'] ?? 'Sem nome';
            final imagem = data['imagem'] ?? '';
            final descricao = data['descricao'] ?? 'Sem descrição.';
            final link = data['link'] ?? '';

            // 🌟 A SOLUÇÃO DA DINÂMICA: Captura o campo de texto 'rota' (Ex: "/prefeitura").
            // Caso o campo não exista ou esteja nulo no banco, usa o 'doc.id' como plano B.
            final rotaDinamicadoBanco = data['rota'] ?? doc.id;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InstituicaoDetalhePage(
                      nome: nome,
                      imagem: imagem,
                      descricao: descricao,
                      link: link,
                      // 🟢 CORREÇÃO: Enviamos a String amigável da rota e não mais o ID aleatório
                      rota: rotaDinamicadoBanco,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: imagem,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          nome,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 6.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
