import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:incaxias_appcx/pages/educacao/escola_detalhes_page.dart';

class EscolasPage extends StatefulWidget {
  const EscolasPage({super.key});

  @override
  State<EscolasPage> createState() => _EscolasPageState();
}

class _EscolasPageState extends State<EscolasPage> {
  String pesquisa = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Escolas Particulares"),
        backgroundColor: Colors.blue,
      ),

      body: Column(
        children: [

          /// PESQUISA
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Pesquisar escola...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  pesquisa = value.toLowerCase();
                });
              },
            ),
          ),

          /// LISTA
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("escolas_particulares")
                  .orderBy("nome")
                  .snapshots(),

              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro: ${snapshot.error}",
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Nenhuma escola encontrada."),
                  );
                }

                final docs = snapshot.data!.docs.where((doc) {

                  Map<String, dynamic> dados =
                      doc.data() as Map<String, dynamic>;

                  String nome =
                      (dados["nome"] ?? "").toString().toLowerCase();

                  return nome.contains(pesquisa);

                }).toList();

                return ListView.builder(
                  itemCount: docs.length,

                  itemBuilder: (context, index) {

                    var escola = docs[index];

                    Map<String, dynamic> dados =
                        escola.data() as Map<String, dynamic>;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),

                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                          )
                        ],
                      ),

                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EscolaDetalhesPage(
                                escola: escola,
                              ),
                            ),
                          );
                        },

                        child: Row(
                          children: [

                            /// FOTO
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),

                              child: Image.network(
                                dados["imagemPrincipal"] ?? "",

                                width: 130,
                                height: 120,
                                fit: BoxFit.cover,

                                errorBuilder: (_, __, ___) {
                                  return Container(
                                    width: 130,
                                    height: 120,
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.school,
                                      size: 40,
                                    ),
                                  );
                                },
                              ),
                            ),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(15),

                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [

                                    /// NOME
                                    Text(
                                      dados["nome"] ?? "",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    /// ENDEREÇO
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [

                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 18,
                                        ),

                                        const SizedBox(width: 5),

                                        Expanded(
                                          child: Text(
                                            dados["endereco"] ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,

                                            style: TextStyle(
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 10),

                                    /// AVALIAÇÃO
                                    Row(
                                      children: [

                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 18,
                                        ),

                                        const SizedBox(width: 5),

                                        Text(
                                          "${dados["avaliacao"] ?? 0}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
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