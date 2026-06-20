import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incaxias_appcx/pages/instituicoes/academia/academia_detalhes_page.dart';

class AcademiaPage extends StatelessWidget {
  const AcademiaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academia Caxiense de Letras'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('academia').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: data['imagemUrl'] != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(data['imagemUrl']),
                        )
                      : const CircleAvatar(child: Icon(Icons.book)),
                  title: Text(data['nome'] ?? 'Sem nome'),
                  subtitle: Text(
                    data['historia']?.toString().substring(0, 50) ?? '',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AcademiaDetalhePage(academiaId: doc.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
