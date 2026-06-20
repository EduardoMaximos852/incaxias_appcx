import 'package:flutter/material.dart';
import 'package:incaxias_appcx/theme/app_text.dart';

class AdvogadoDetalhePage extends StatelessWidget {
  final Map<String, dynamic> dados;
  const AdvogadoDetalhePage({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: const Icon(Icons.home),
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: AppText.caption(
          dados['nome'] ?? 'Detalhes do Advogado',
        ),
        backgroundColor: Colors.deepPurple.shade600,
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO do advogado
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  dados['fotoUrl'] ?? '',
                  height: 160,
                  width: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 160,
                    width: 160,
                    color: Colors.deepPurple.shade100,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Nome e especialidade
            Center(
              child: Column(
                children: [
                  AppText.caption(
                    dados['nome'] ?? 'Sem nome',
                  ),
                  const SizedBox(height: 3),
                  Text(
                    dados['especialidade'] ?? 'Sem especialidade',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.deepPurple.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            _buildInfoTile(Icons.email_outlined, 'Email', dados['email']),
            _buildInfoTile(Icons.phone_iphone, 'Telefone', dados['telefone']),
            _buildInfoTile(Icons.badge_outlined, 'OAB', dados['oab']),
            _buildInfoTile(Icons.perm_identity, 'CPF', dados['cpf']),
            _buildInfoTile(
              Icons.location_on_outlined,
              'Endereço',
              dados['endereco'],
            ),
            _buildInfoTile(
              Icons.location_city_outlined,
              'Cidade',
              dados['cidade'],
            ),

            _buildInfoTile(
              Icons.calendar_today_outlined,
              'Data Inscrição',
              dados['dataInscricao'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String? value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple.shade400, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: AppText.body(
              '$label: ${value ?? '-'}',
            ),
          ),
        ],
      ),
    );
  }
}
