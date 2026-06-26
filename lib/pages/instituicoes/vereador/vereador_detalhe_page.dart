import 'package:flutter/material.dart';
import 'package:incaxias_appcx/models/vereador_model.dart';

class VereadorDetalhePage extends StatelessWidget {
  final Vereador vereador;

  const VereadorDetalhePage({Key? key, required this.vereador})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vereador.nome),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto e Info Principal
            Center(
              child: Column(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        )
                      ],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: vereador.fotoUrl.isNotEmpty
                            ? NetworkImage(vereador.fotoUrl)
                            : const AssetImage('assets/placeholder.png')
                                as ImageProvider,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    vereador.nome,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign
                        .center, // 🔸 CORRIGIDO: Era aqui o erro de compilação
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vereador.descricao,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign
                        .center, // 🔸 CORRIGIDO: Era aqui o erro de compilação
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),

            // Bloco de Dados Técnicos do Mandato
            const Text(
              'Informações do Mandato',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.flag, 'Partido', vereador.partido),
            _buildInfoRow(
                Icons.how_to_vote, 'Votação', '${vereador.votos} votos'),
            _buildInfoRow(Icons.calendar_today, 'Período',
                '${vereador.inicioMandato} até ${vereador.fimMandato}'),
            _buildInfoRow(
                Icons.location_city, 'Naturalidade', vereador.natural),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),

            // Bloco da Biografia/História
            const Text(
              'Biografia e História',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),
            Text(
              vereador.historia.isNotEmpty
                  ? vereador.historia
                  : 'Nenhuma história cadastrada.',
              style: const TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey, size: 22),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
