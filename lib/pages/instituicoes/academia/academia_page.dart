import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incaxias_appcx/pages/instituicoes/academia/academia_detalhes_page.dart';

class AcademiaPage extends StatefulWidget {
  const AcademiaPage({super.key});

  @override
  State<AcademiaPage> createState() => _AcademiaPageState();
}

class _AcademiaPageState extends State<AcademiaPage> {
  String searchQuery = '';
  String filtroCategoria = 'todos';

  Widget _buildFiltroButton(
    String texto,
    String valor,
    IconData icone,
  ) {
    final selecionado = filtroCategoria == valor;

    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          filtroCategoria = valor;
        });
      },
      icon: Icon(
        icone,
        size: 18,
      ),
      label: Text(texto),
      style: ElevatedButton.styleFrom(
        backgroundColor: selecionado ? Colors.blue.shade800 : Colors.white,
        foregroundColor: selecionado ? Colors.white : Colors.blue.shade800,
        elevation: selecionado ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          );
        },
        child: const Icon(Icons.home),
      ),
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Academia Caxiense de Letras",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
                  hintText: 'Buscar Acadêmico...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.blue,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          ),

          // Filtros
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFiltroButton(
                    'Todos',
                    'todos',
                    Icons.groups,
                  ),
                  const SizedBox(width: 8),
                  _buildFiltroButton(
                    'Fundadores',
                    'fundador',
                    Icons.history_edu,
                  ),
                  const SizedBox(width: 8),
                  _buildFiltroButton(
                    'Patronos',
                    'patrono',
                    Icons.menu_book,
                  ),
                  const SizedBox(width: 8),
                  _buildFiltroButton(
                    'Titulares',
                    'titular',
                    Icons.school,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('academia')
                  .orderBy('nome')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nenhum acadêmico cadastrado.",
                    ),
                  );
                }

                final docs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  final nome = (data['nome'] ?? '').toString().toLowerCase();

                  final categoria =
                      (data['categoria'] ?? '').toString().toLowerCase();

                  final buscaOk = nome.contains(
                    searchQuery.toLowerCase(),
                  );

                  final categoriaOk = filtroCategoria == 'todos'
                      ? true
                      : categoria == filtroCategoria;

                  return buscaOk && categoriaOk;
                }).toList();

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nenhum resultado encontrado.",
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final docId = doc.id;

                    final data = doc.data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () {
                        data['id'] = docId;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AcademiaDetalhesPage(
                              data: data,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.blue.shade50,
                            ],
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
                              Hero(
                                tag: 'foto_acad_$docId',
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.amber.shade100,
                                  backgroundImage: data['fotoUrl'] != null &&
                                          data['fotoUrl'].toString().isNotEmpty
                                      ? NetworkImage(
                                          data['fotoUrl'],
                                        )
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
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        (data['categoria'] ?? '')
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.blue.shade800,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Cadeira: ${data['cadeira'] ?? 'N/A'}",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.assignment_ind_outlined,
                                          size: 15,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            "Admissão: ${data['admissao'] ?? 'Não informada'}",
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 13,
                                            ),
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
