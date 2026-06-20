import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incaxias_appcx/pages/instituicoes/academia/membros_detalhes_page.dart';

class AcademiaDetalhePage extends StatelessWidget {
  final String academiaId;

  const AcademiaDetalhePage({super.key, required this.academiaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Academia'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('academia')
            .doc(academiaId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final membrosIds = List<String>.from(data['membros'] ?? []);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data['imagemUrl'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      data['imagemUrl'],
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  data['nome'] ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  data['historia'] ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Membros da Academia',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 10),
                _buildMembrosList(context, membrosIds),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMembrosList(BuildContext context, List<String> membrosIds) {
    if (membrosIds.isEmpty) {
      return const Text('Nenhum membro cadastrado.');
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('membros')
          .where(FieldPath.documentId, whereIn: membrosIds)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final membros = snapshot.data!.docs;

        return Column(
          children: membros.map((membro) {
            final data = membro.data() as Map<String, dynamic>;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(data['fotoUrl'] ?? ''),
                ),
                title: Text(data['nome'] ?? ''),
                subtitle: Text(data['descricao'] ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MembroDetalhePage(membroId: membro.id),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
