import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InstituicaoDetalhePage extends StatelessWidget {
  final String nome;
  final String imagem;
  final String descricao;
  final String link;
  final String
      rota; // 🔸 Recebe dinamicamente o valor do campo 'rota' do Firestore

  const InstituicaoDetalhePage({
    super.key,
    required this.nome,
    required this.imagem,
    required this.descricao,
    required this.link,
    required this.rota,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Fundo ultra-limpo minimalista
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📸 Banner de imagem moderno com botão flutuante de voltar
            Stack(
              children: [
                Hero(
                  tag: 'hero_img_$rota',
                  child: CachedNetworkImage(
                    imageUrl: imagem,
                    height: 320,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 320,
                      color: Colors.grey.shade200,
                      child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 320,
                      color: Colors.blue.shade50,
                      child: const Icon(Icons.account_balance,
                          size: 64, color: Colors.blue),
                    ),
                  ),
                ),
                // Botão de voltar customizado minimalista
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(230),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),

            // 📝 Corpo do Conteúdo
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoria sutil superior
                  Text(
                    "INSTITUIÇÃO PÚBLICA",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue.shade800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Título Principal
                  Text(
                    nome,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cards Informativos Rápidos (Minimalistas)
                  Row(
                    children: [
                      _buildMiniBadge(
                          Icons.location_on_outlined, "Caxias - MA"),
                      const SizedBox(width: 10),
                      _buildMiniBadge(
                          Icons.verified_user_outlined, "Módulo Interno"),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Seção Sobre
                  const Text(
                    "Sobre a Instituição",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    descricao,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF718096),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 🕹️ PAINEL DE AÇÕES: Totalmente dinâmico e expansível
                  Row(
                    children: [
                      // Botão Acessar Site Externo
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            if (link.isNotEmpty) {
                              final uri = Uri.parse(link);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri,
                                    mode: LaunchMode.externalApplication);
                                return;
                              }
                            }
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Portal da web não cadastrado para esta unidade.')),
                              );
                            }
                          },
                          icon: const Icon(Icons.public, size: 18),
                          label: const Text('Portal Web'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue.shade800,
                            side: BorderSide(
                                color: Colors.blue.shade200, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Botão de Navegação Interna Direta (CORRIGIDO, FECHADO E SEGURO)
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            // 1. Limpa os espaços e armazena a rota que veio do Firestore
                            final rotaDestino = rota.trim();

                            if (rotaDestino.isNotEmpty &&
                                rotaDestino != "null") {
                              try {
                                // 🌟 A MUDANÇA ESTÁ AQUI: Trocamos '/prefeitos' pela variável rotaDestino
                                Navigator.pushNamed(context, rotaDestino);
                              } catch (e) {
                                // Se você digitar a rota errada no Firebase (ex: /acedemia em vez de /academia)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'A rota "$rotaDestino" não foi configurada no arquivo de rotas do código.'),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Esta instituição ainda não possui uma página interna vinculada.'),
                                ),
                              );
                            } // Fechamento do else
                          }, // Fechamento do onPressed
                          icon: const Icon(Icons.arrow_forward_ios,
                              size: 14, color: Colors.white),
                          label: const Text(
                            'Acessar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Auxiliar para as Tags Minimalistas
  Widget _buildMiniBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
