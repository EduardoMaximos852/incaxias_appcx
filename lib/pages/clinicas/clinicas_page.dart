import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incaxias_appcx/pages/clinicas/clinicas_detalhes_page.dart';
import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';

class ClinicaPage extends StatefulWidget {
  const ClinicaPage({super.key});

  @override
  State<ClinicaPage> createState() => _ClinicaPageState();
}

class _ClinicaPageState extends State<ClinicaPage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: AppText.title('Clínicas de Caxias'),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(
              16,
              0,
              16,
              16,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar clínica, bairro ou especialidade...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  search = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('clinicas').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: AppText.body(
                      'Nenhuma clínica cadastrada.',
                    ),
                  );
                }

                final docs = snapshot.data!.docs.where((doc) {
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
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];

                    final data = doc.data() as Map<String, dynamic>;

                    final foto = data['fotoUrl'] ?? '';

                    final nome = data['nome'] ?? '';

                    final especialidade = data['especialidade'] ?? '';

                    final bairro = data['bairro'] ?? '';

                    final endereco = data['endereco'] ?? '';

                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: 14,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(
                                  20,
                                ),
                              ),
                              child: foto.isNotEmpty
                                  ? Image.network(
                                      foto,
                                      width: double.infinity,
                                      height: 180,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) {
                                        return Container(
                                          height: 180,
                                          color: Colors.grey.shade200,
                                          child: const Icon(
                                            Icons.local_hospital,
                                            size: 60,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      height: 180,
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(
                                          Icons.local_hospital,
                                          size: 60,
                                        ),
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText.subtitle(
                                    nome,
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                    child: Text(
                                      especialidade,
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: AppText.body(
                                          bairro,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  AppText.body(
                                    endereco,
                                  ),
                                ],
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
