import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EletricistaDetalhePage extends StatelessWidget {
  final Map<String, dynamic> dados;

  const EletricistaDetalhePage({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: const Icon(Icons.home),
      ),
      appBar: AppBar(
        title: Text(dados['nome'] ?? 'Eletricista'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: dados['fotoUrl'] ?? '',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 50),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // NOME
            Center(
              child: Text(
                dados['nome'] ?? 'Sem nome',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // CATEGORIA E AVALIAÇÃO
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dados['categoria'] ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(width: 12),
                Row(
                  children: List.generate(5, (i) {
                    final rating = dados['avaliacao'] ?? 0.0;
                    return Icon(
                      i < rating.round() ? Icons.star : Icons.star_border,
                      color: Colors.amber[600],
                      size: 18,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // INFORMAÇÕES DETALHADAS
            _buildInfoRow(Icons.phone, 'Telefone', dados['telefone']),
            _buildInfoRow(Icons.email, 'Email', dados['email']),
            _buildInfoRow(Icons.location_on, 'Endereço', dados['endereco']),
            _buildInfoRow(Icons.location_city, 'Cidade', dados['cidade']),
            _buildInfoRow(Icons.account_box, 'CPF', dados['cpf']),
            _buildInfoRow(
              Icons.work,
              'OAB / Especialidade',
              dados['especialidade'],
            ),
            _buildInfoRow(
              Icons.date_range,
              'Data Inscrição',
              dados['dataInscricao'],
            ),

            const SizedBox(height: 16),

            // DESCRIÇÃO
            if ((dados['descricao'] ?? '').isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Descrição:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dados['descricao'] ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
