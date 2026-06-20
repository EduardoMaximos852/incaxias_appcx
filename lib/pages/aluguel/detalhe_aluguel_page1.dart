import 'package:flutter/material.dart';
import 'package:incaxias_appcx/models/aluguel.dart';
import 'package:incaxias_appcx/services/favoritos_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalheAluguelPage extends StatelessWidget {
  final Aluguel aluguel;

  const DetalheAluguelPage({super.key, required this.aluguel});

  Future<void> abrirWhatsApp() async {
    final url = Uri.parse("https://wa.me/55${aluguel.whatsapp}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> abrirMapa() async {
    final url = Uri.parse(aluguel.mapsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// ===== HEADER COM IMAGENS =====
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            title: Text(
              aluguel.titulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: aluguel.imagens.isEmpty
                  ? Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.home, size: 80),
                    )
                  : PageView.builder(
                      itemCount: aluguel.imagens.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          aluguel.imagens[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                /// PREÇO
                Text(
                  "R\$ ${aluguel.preco.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 4),

                /// TIPO
                Text(
                  aluguel.tipo.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                /// ENDEREÇO
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, size: 18),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        aluguel.endereco,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// GRID INFO
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 360 ? 3 : 2;

                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.1,
                      children: [
                        _infoItem(
                          Icons.bed,
                          "Quartos",
                          aluguel.quartos.toString(),
                        ),
                        _infoItem(
                          Icons.bathtub,
                          "Banheiros",
                          aluguel.banheiros.toString(),
                        ),
                        _infoItem(
                          Icons.chair,
                          "Salas",
                          aluguel.salas.toString(),
                        ),
                        _infoItem(
                          Icons.kitchen,
                          "Cozinha",
                          aluguel.cozinhaAmericana
                              ? "Americana"
                              : "Tradicional",
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  "Descrição",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                Text(aluguel.descricao, style: const TextStyle(fontSize: 14)),

                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),

      /// ===== BOTÕES FIXOS =====
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: abrirMapa,
                icon: const Icon(Icons.map),
                label: const Text("Mapa"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: abrirWhatsApp,
                icon: const Icon(Icons.phone),
                label: const Text("WhatsApp"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
