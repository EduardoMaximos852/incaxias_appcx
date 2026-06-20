import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';

class FarmaciaPage extends StatefulWidget {
  const FarmaciaPage({super.key});

  @override
  State<FarmaciaPage> createState() => _FarmaciaPageState();
}

class _FarmaciaPageState extends State<FarmaciaPage> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: AppText.title("Farmácias")),
      body: Column(
        children: [
          // 🔍 CAMPO DE BUSCA
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar farmácia...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => search = value.trim());
              },
            ),
          ),

          // 🔹 LISTA DE FARMÁCIAS
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('farmacias')
                  .orderBy('nome')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                // 🔍 FILTRAR RESULTADOS
                final filtered = docs.where((doc) {
                  final nome = doc['nome'].toString().toLowerCase();
                  final bairro = doc['bairro'].toString().toLowerCase();

                  final query = search.toLowerCase();

                  return nome.contains(query) || bairro.contains(query);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: AppText.subtitle2(
                      "Nenhuma farmácia encontrada.",
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final farmacia = filtered[index];
                    final data = farmacia.data() as Map<String, dynamic>;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(data['imageUrl']),
                      ),
                      title: AppText.caption(data['nome']),
                      subtitle: AppText.escrito("${data['bairro']}"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/farmaciaDetalhe',
                          arguments: farmacia.id,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
