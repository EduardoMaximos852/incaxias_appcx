import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import 'eletricista_detalhe_page.dart';

class EletricistasPage extends StatefulWidget {
  const EletricistasPage({super.key});

  @override
  State<EletricistasPage> createState() => _EletricistasPageState();
}

class _EletricistasPageState extends State<EletricistasPage> {
  String _searchQuery = '';

  List<Map<String, dynamic>> _filterData(List<QueryDocumentSnapshot> docs) {
    final query = _searchQuery.trim().toLowerCase();
    return docs.map((d) => d.data() as Map<String, dynamic>).where((data) {
      final nome = (data['nome'] ?? '').toString().toLowerCase();
      return nome.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.title('Eletricistas em Caxias'),
        
        
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Campo de busca
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Buscar eletricista...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
              ),
            ),
          ),

          // Lista de eletricistas
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('categorias')
                  .doc('eletricista')
                  .collection('fornecedores')
                  .orderBy('avaliacao', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: AppText.body(
                      'Nenhum eletricista cadastrado ⚡'                      
                    ),
                  );
                }

                final filtered = _filterData(snapshot.data!.docs);

                if (filtered.isEmpty) {
                  return Center(
                    child: AppText.body(
                      'Nenhum eletricista corresponde à busca ⚡',)
                      
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final data = filtered[index];

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: data['fotoUrl'] ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              width: 50,
                              height: 50,
                              child: const Icon(Icons.person, size: 30),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.broken_image, size: 30),
                          ),
                        ),
                        title: AppText.subtitle(
                          data['nome'] ?? 'Sem nome',
                          
                        ),
                        subtitle: Row(
                          children: [
                            Row(
                              children: List.generate(5, (i) {
                                final rating = data['avaliacao'] ?? 0.0;
                                return Icon(
                                  i < rating.round()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber[600],
                                  size: 14,
                                );
                              }),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EletricistaDetalhePage(dados: data),
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
