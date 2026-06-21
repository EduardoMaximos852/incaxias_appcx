import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';

class PizzariaDetalhesPage extends StatefulWidget {
  final String pizzariaId;

  const PizzariaDetalhesPage({
    super.key,
    required this.pizzariaId,
  });

  @override
  State<PizzariaDetalhesPage> createState() => _PizzariaDetalhesPageState();
}

class _PizzariaDetalhesPageState extends State<PizzariaDetalhesPage> {
  double _rating = 0;
  final TextEditingController _comentarioController = TextEditingController();
  final NumberFormat _currency =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _enviarAvaliacao() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma nota para avaliar.'),
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('pizzarias')
          .doc(widget.pizzariaId)
          .collection('avaliacoes')
          .add({
        'nota': _rating,
        'comentario': _comentarioController.text.trim(),
        'data': Timestamp.now(),
      });

      await FirebaseFirestore.instance
          .collection('pizzarias')
          .doc(widget.pizzariaId)
          .update({
        'ultimaNota': _rating,
      });

      if (!mounted) return;

      setState(() {
        _rating = 0;
        _comentarioController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Avaliação enviada! Obrigado.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar avaliação: $e'),
        ),
      );
    }
  }

  Future<void> _abrirUrl(
    String url, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final uri = Uri.parse(url);

    final sucesso = await launchUrl(uri, mode: mode);

    if (!sucesso && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir o link.'),
        ),
      );
    }
  }

  String _somenteNumeros(String valor) {
    return valor.replaceAll(RegExp(r'\D'), '');
  }

  String _formatarPreco(dynamic valor) {
    if (valor == null) return 'R\$ 0,00';

    if (valor is num) {
      return _currency.format(valor);
    }

    final texto = valor.toString().trim();

    final numero = double.tryParse(
      texto
          .replaceAll('R\$', '')
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .trim(),
    );

    if (numero != null) {
      return _currency.format(numero);
    }

    return texto;
  }

  Widget _buildImage(String imageUrl, {double? height}) {
    if (imageUrl.isEmpty) {
      return Container(
        height: height,
        width: double.infinity,
        color: Colors.grey.shade300,
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 42,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Image.network(
      imageUrl,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          height: height,
          color: Colors.grey.shade300,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: double.infinity,
          color: Colors.grey.shade300,
          child: const Center(
            child: Icon(
              Icons.broken_image,
              size: 42,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  Widget _contactTile({
    required Widget icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: icon,
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: AppText.title('Pizzaria'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('pizzarias')
            .doc(widget.pizzariaId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar os dados da pizzaria.'),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('Pizzaria não encontrada.'),
            );
          }

          final data = snapshot.data!.data();
          if (data == null) {
            return const Center(
              child: Text('Dados indisponíveis.'),
            );
          }

          final nome = data['nome']?.toString() ?? '';
          final foto = data['foto']?.toString() ?? '';
          final descricao = data['descricao']?.toString() ?? '';
          final bairro = data['bairro']?.toString() ?? '';
          final endereco = data['endereco']?.toString() ?? '';
          final cardapio = data['cardapio']?.toString() ?? '';
          final telefone = data['telefone']?.toString() ?? '';
          final whatsapp = data['whatsapp']?.toString() ?? '';

          final ultimaNota = data['ultimaNota'] is num
              ? (data['ultimaNota'] as num).toDouble()
              : 0.0;

          final fotosSabores = (data['fotosSabores'] as List?)
                  ?.map((e) => e.toString())
                  .where((e) => e.isNotEmpty)
                  .toList() ??
              [];

          final precos = Map<String, dynamic>.from(data['precos'] ?? {});

          final enderecoBusca =
              Uri.encodeComponent('$endereco, $bairro, Caxias - MA');
          final whatsappLimpo = _somenteNumeros(whatsapp);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 240,
                  child: _buildImage(foto, height: 240),
                ),
              ),
              const SizedBox(height: 16),
              AppText.title2(nome),
              const SizedBox(height: 8),
              if (bairro.isNotEmpty)
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Expanded(child: AppText.caption(bairro)),
                  ],
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  AppText.caption(
                    'Última nota: ${ultimaNota.toStringAsFixed(1)}',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (descricao.isNotEmpty) AppText.escrito(descricao),
              if (descricao.isNotEmpty) const SizedBox(height: 16),
              if (endereco.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppText.escrito('Endereço: $endereco'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        _abrirUrl(
                          'https://www.google.com/maps/search/?api=1&query=$enderecoBusca',
                        );
                      },
                      icon: const Icon(
                        Icons.pin_drop,
                        color: Colors.white,
                      ),
                      label: AppText.button('Mapa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              if (telefone.isNotEmpty)
                _contactTile(
                  icon: Icon(
                    Icons.phone,
                    size: 28,
                    color: Colors.green.shade700,
                  ),
                  text: telefone,
                  onTap: () => _abrirUrl(
                    'tel:${_somenteNumeros(telefone)}',
                    mode: LaunchMode.platformDefault,
                  ),
                ),
              if (whatsappLimpo.isNotEmpty)
                _contactTile(
                  icon: Icon(
                    Icons.message,
                    size: 28,
                    color: Colors.green.shade700,
                  ),
                  text: whatsapp,
                  onTap: () => _abrirUrl(
                    'https://wa.me/55$whatsappLimpo?text=${Uri.encodeComponent('Olá! Vi sua pizzaria no app Incaxias.')}',
                  ),
                ),
              if (cardapio.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton.icon(
                    onPressed: () => _abrirUrl(cardapio),
                    icon: const Icon(Icons.menu_book),
                    label: AppText.button('Abrir Cardápio'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              if (fotosSabores.isNotEmpty) ...[
                AppText.subtitle('Sabores'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 180,
                  child: Swiper(
                    itemCount: fotosSabores.length,
                    autoplay: fotosSabores.length > 1,
                    viewportFraction: 0.82,
                    scale: 0.9,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: _buildImage(
                          fotosSabores[index],
                          height: 180,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (precos.isNotEmpty) ...[
                AppText.subtitle('Preços das Pizzas'),
                const SizedBox(height: 8),
                ...precos.entries.map(
                  (e) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AppText.caption(e.key.toUpperCase()),
                        ),
                        AppText.valorElipse(_formatarPreco(e.value)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              const Text(
                'Avalie esta Pizzaria',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    onPressed: () {
                      setState(() {
                        _rating = (i + 1).toDouble();
                      });
                    },
                    icon: Icon(
                      i < _rating ? Icons.star : Icons.star_border,
                      size: 32,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _comentarioController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Deixe um comentário (opcional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),
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
                child: AppText.button('Enviar Avaliação'),
              ),
            ],
          );
        },
      ),
    );
  }
}
