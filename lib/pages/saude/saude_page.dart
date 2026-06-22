import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incaxias_appcx/pages/clinicas/clinicas_detalhes_page.dart';
import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';

class SaudePage extends StatefulWidget {
  const SaudePage({super.key});

  @override
  State<SaudePage> createState() => _SaudePageState();
}

class _SaudePageState extends State<SaudePage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final clinicasRef = FirebaseFirestore.instance.collection('clinicas');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: AppText.title(
          'Clínicas de Caxias',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔍 CAMPO DE BUSCA
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por nome, bairro ou especialidade...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                isDense: true,
              ),
              onChanged: (v) => setState(() => search = v.toLowerCase()),
            ),
          ),

          // 📋 LISTA
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: clinicasRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: AppText.body('Nenhuma clínica cadastrada.'),
                  );
                }

                final clinicasFiltradas = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  final nome = (data['nome'] ?? '').toString().toLowerCase();
                  final bairro =
                      (data['bairro'] ?? '').toString().toLowerCase();
                  final especialidade =
                      (data['especialidade'] ?? '').toString().toLowerCase();

                  return nome.contains(search) ||
                      bairro.contains(search) ||
                      especialidade.contains(search);
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: clinicasFiltradas.length,
                  itemBuilder: (context, index) {
                    final doc = clinicasFiltradas[index];
                    final data = doc.data() as Map<String, dynamic>;

                    final fotoUrl = data['fotoUrl'] ?? '';
                    final nome = data['nome'] ?? '';
                    final especialidade = data['especialidade'] ?? '';
                    final endereco = data['endereco'] ?? '';
                    final bairro = data['bairro'] ?? '';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ClinicaDetalhesPage(
                                idClinica: doc.id,
                                dados: data,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(16),
                              ),
                              child: fotoUrl.isNotEmpty
                                  ? Image.network(
                                      fotoUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.local_hospital),
                                    ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText.body(
                                      nome,
                                    ),
                                    const SizedBox(height: 4),
                                    AppText.body(
                                      especialidade,
                                    ),
                                    const SizedBox(height: 6),
                                    AppText.body(
                                      bairro,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: AppText.body(
                                            endereco,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
