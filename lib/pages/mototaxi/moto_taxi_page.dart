import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:incaxias_appcx/pages/mototaxi/moto_taxi_class.dart';
import 'package:incaxias_appcx/pages/mototaxi/mototaxi_detalhe_page.dart';

class MotoTaxiPage extends StatelessWidget {
  const MotoTaxiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moto Táxi')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('moto_taxi') // 👈 coleção raiz
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final moto = Mototaxi.fromMap(data); // ✅ agora funciona

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MototaxiDetalhePage(
                        mototaxi: data,
                      ), // Passa o mapa de dados
                    ),
                  );
                  // Aqui você pode navegar para a página de detalhes, passando os dados do mototaxi
                },
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(moto.fotoUrl),
                    ),
                    title: Text(moto.nome),
                    subtitle: Text("${moto.moto} • ${moto.placa}"),
                    trailing: Text(moto.whatsapp),
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
