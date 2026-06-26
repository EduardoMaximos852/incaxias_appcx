import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incaxias_appcx/pages/instituicoes/prefeitos/prefeitos_detalhes_page.dart';

class PrefeitosPage extends StatefulWidget {
  const PrefeitosPage({super.key});

  @override
  State<PrefeitosPage> createState() => _PrefeitosPageState();
}

class _PrefeitosPageState extends State<PrefeitosPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        child: const Icon(Icons.home),
      ),
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Prefeitos de Caxias",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Campo de busca
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar prefeito...',
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                ),
                onChanged: (value) => setState(() => searchQuery = value),
              ),
            ),
          ),

          // Lista de prefeitos
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('prefeitos')
                  .orderBy('inicioMandato', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Nenhum prefeito cadastrado."),
                  );
                }

                // Filtragem pela busca digitada pelo usuário
                final docs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final nome = (data['nome'] ?? '').toString().toLowerCase();
                  return nome.contains(searchQuery.toLowerCase());
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final docId =
                        doc.id; // Captura o ID único do documento do Firebase
                    final data = doc.data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () {
                        // Injeta o ID único dentro do mapa de dados antes de enviar para a tela de detalhes
                        data['id'] = docId;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PrefeitoDetalhePage(data: data),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.blue.shade50],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Alterado a tag fixa do nome para uma tag combinada com o ID único do Firebase
                              Hero(
                                tag: 'foto_prefe_$docId',
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.amber.shade100,
                                  backgroundImage: data['fotoUrl'] != null &&
                                          data['fotoUrl'].toString().isNotEmpty
                                      ? NetworkImage(data['fotoUrl'])
                                      : null,
                                  child: data['fotoUrl'] == null ||
                                          data['fotoUrl'].toString().isEmpty
                                      ? const Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.grey,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['nome'] ?? 'Sem nome',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Partido: ${data['partido'] ?? 'N/D'}",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          size: 15,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${data['inicioMandato']} - ${data['fimMandato']}",
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
