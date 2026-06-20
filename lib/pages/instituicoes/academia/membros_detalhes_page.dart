import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MembroDetalhePage extends StatelessWidget {
  final String membroId;

  const MembroDetalhePage({super.key, required this.membroId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Membro'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('membros')
            .doc(membroId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data['fotoUrl'] != null)
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(data['fotoUrl']),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  data['nome'] ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  data['descricao'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  data['biografia'] ?? 'Sem biografia registrada.',
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
