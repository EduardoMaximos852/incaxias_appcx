import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incaxias_appcx/models/vereador_model.dart';
import 'vereador_detalhe_page.dart';

class VereadorPage extends StatefulWidget {
  const VereadorPage({Key? key}) : super(key: key);

  @override
  State<VereadorPage> createState() => _VereadorPageState();
}

class _VereadorPageState extends State<VereadorPage> {
  String pesquisa = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vereadores'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // CAMPO DE PESQUISA
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  pesquisa = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Pesquisar vereador...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('vereadores')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro ao carregar dados.'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                    child: Text('Nenhum vereador cadastrado.'),
                  );
                }

                final listaVereadores = docs.map((doc) {
                  final dados = doc.data() as Map<String, dynamic>;

                  return Vereador.fromFirestore(
                    dados,
                    doc.id,
                  );
                }).toList();

                // Ordena pelos mandatos mais recentes
                listaVereadores.sort(
                  (a, b) => b.inicioMandato.compareTo(a.inicioMandato),
                );

                // FILTRO DE PESQUISA
                final vereadoresFiltrados = listaVereadores
                    .where((vereador) =>
                        vereador.nome.toLowerCase().contains(pesquisa))
                    .toList();

                if (vereadoresFiltrados.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhum vereador encontrado.',
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: vereadoresFiltrados.length,
                  itemBuilder: (context, index) {
                    final vereador = vereadoresFiltrados[index];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: vereador.fotoUrl.isNotEmpty
                              ? NetworkImage(vereador.fotoUrl)
                              : const AssetImage('assets/placeholder.png')
                                  as ImageProvider,
                        ),
                        title: Text(
                          vereador.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            '${vereador.inicioMandato} - ${vereador.fimMandato} | ${vereador.votos} votos (${vereador.partido})',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VereadorDetalhePage(
                                vereador: vereador,
                              ),
                            ),
                          );
                        },
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
