import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrefeitoDetalhePage extends StatelessWidget {
  final Map<String, dynamic> data;

  const PrefeitoDetalhePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Recupera o ID único injetado pela tela de listagem
    final String prefeitoId = data['id'] ?? '';

    final String nome = data['nome'] ?? 'Sem nome';
    final String fotoUrl = data['fotoUrl'] ?? '';
    final String inicioMandato = data['inicioMandato'] ?? '';
    final String fimMandato = data['fimMandato'] ?? '';
    final String partido = data['partido'] ?? 'N/D';
    final String descricao = data['descricao'] ?? 'Sem descrição disponível.';
    final String historia = data['historia'] ?? 'História não informada.';
    final String eleicao = data['eleicao'] ?? 'Não informado';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        title: Text(
          nome,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Imagem centralizada com borda dourada
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade200, Colors.amber.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                // Adicionado o widget Hero correspondente à listagem principal
                child: Hero(
                  tag:
                      'foto_prefe_$prefeitoId', // Bate exatamente com a tag dinâmica da lista
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        (fotoUrl.isNotEmpty) ? NetworkImage(fotoUrl) : null,
                    child: (fotoUrl.isEmpty)
                        ? const Icon(Icons.person, size: 70, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              nome,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Partido: $partido",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 20),

            // Informações do mandato
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow(
                      Icons.calendar_month,
                      "Mandato:",
                      "$inicioMandato - $fimMandato",
                    ),
                    const SizedBox(height: 10),
                    _infoRow(Icons.how_to_vote, "Eleição:", eleicao),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            _sectionTitle("Descrição"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                descricao,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),

            const SizedBox(height: 25),

            _sectionTitle("História do Prefeito"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                historia,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 10),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// 📜 Histórico de Prefeitos - Linha do Tempo (Corrigida)
// ==========================================================
class HistoricoPrefeitosPage extends StatelessWidget {
  const HistoricoPrefeitosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Histórico de Prefeitos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('prefeitos')
            .orderBy('inicioMandato', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum prefeito localizado.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final String nomePrefeito = data['nome'] ?? 'Sem nome';
              final String fotoPrefeito = data['fotoUrl'] ?? '';
              final String partidoPrefeito = data['partido'] ?? 'N/D';
              final String anosMandato =
                  "${data['inicioMandato'] ?? ''} - ${data['fimMandato'] ?? ''}";

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Mantido sem o widget Hero aqui para evitar duplicação em segundo plano na pilha de telas
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue.shade100,
                        backgroundImage: fotoPrefeito.isNotEmpty
                            ? NetworkImage(fotoPrefeito)
                            : null,
                        child: fotoPrefeito.isEmpty
                            ? const Icon(Icons.person, color: Colors.blueAccent)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              nomePrefeito,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Gestão: $anosMandato",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              "Partido: $partidoPrefeito",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
