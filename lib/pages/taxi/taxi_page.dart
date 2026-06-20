import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'taxi_detail_page.dart';

class TaxiPage extends StatefulWidget {
  const TaxiPage({super.key});

  @override
  State<TaxiPage> createState() => _TaxiPageState();
}

class _TaxiPageState extends State<TaxiPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final taxisStream = FirebaseFirestore.instance
        .collection('taxi')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Táxis Cadastrados',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange.shade700,
      ),
      body: Column(
        children: [
          // 🔍 Campo de busca
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por nome ou bairro...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // 🔹 Lista de táxis
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: taxisStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Nenhum táxi encontrado.'));
                }

                final taxis = snapshot.data!.docs.where((doc) {
                  final nome = doc['nome'].toString().toLowerCase();
                  final bairro = doc['bairro'].toString().toLowerCase();
                  return nome.contains(searchQuery) ||
                      bairro.contains(searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: taxis.length,
                  itemBuilder: (context, index) {
                    final taxi = taxis[index];
                    final nome = taxi['nome'] ?? '';
                    final fotoUrl = taxi['fotoUrl'] ?? '';
                    final bairro = taxi['bairro'] ?? '';
                    final automovel = taxi['automovel'] ?? '';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaxiDetailPage(
                              nome: nome,
                              fotoUrl: fotoUrl,
                              endereco: taxi['endereco'] ?? '',
                              placa: taxi['placa'] ?? '',
                              automovel: automovel,
                              dataInicio: taxi['data_inicio'] ?? '',
                              local: taxi['local'] ?? '',
                              bairro: bairro,
                              whatsapp: '',
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              fotoUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.local_taxi,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          title: Text(
                            nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('$automovel\nBairro: $bairro'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                        ),
                      ),
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
