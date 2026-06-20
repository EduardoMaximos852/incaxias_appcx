// servicos_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicosPage extends StatefulWidget {
  const ServicosPage({super.key});

  @override
  State<ServicosPage> createState() => _ServicosPageState();
}

class _ServicosPageState extends State<ServicosPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _search = '';
  String _categoria = 'Todos';

  final List<String> _categorias = [
    'Todos',
    'Eletricista',
    'Encanador',
    'Pedreiro',
    'Pintor',
    'Jardineiro',
    'Técnico',
    'Outros',
  ];

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _search = _searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> _servicosStream() {
    return FirebaseFirestore.instance.collection('servicos').snapshots();
  }

  Future<void> _abrirWhatsApp(String numero) async {
    if (numero.isEmpty) return;
    final clean = numero.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('https://wa.me/$clean');
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _abrirMaps(String endereco) async {
    if (endereco.isEmpty) return;
    final q = Uri.encodeComponent(endereco);
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$q');
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Search field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nome ou bairro',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Clear button
              InkWell(
                onTap: () {
                  _searchCtrl.clear();
                  FocusScope.of(context).unfocus();
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.filter_list, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Category chips (horizontal)
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categorias.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final cat = _categorias[idx];
                final selected = _categoria == cat;
                return ChoiceChip(
                  label: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  selected: selected,
                  onSelected: (_) => setState(() => _categoria = cat),
                  selectedColor: Colors.blueAccent.shade700,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  elevation: selected ? 6 : 2,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> data) {
    final String nome = (data['nome'] ?? '');
    final String profissao = (data['profissao'] ?? '');
    final String imagem = (data['imagemUrl'] ?? '');
    final double avaliacao = (data['avaliacao'] is num)
        ? (data['avaliacao'] as num).toDouble()
        : 0.0;
    final String bairro = (data['bairro'] ?? '');
    final String endereco = (data['endereco'] ?? '');
    final String whatsapp = (data['whatsapp'] ?? '');
    final String indicacao = (data['indicacao'] ?? '');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do profissional
            imagem.isNotEmpty
                ? Image.network(
                    imagem,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 140,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome + avaliação
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade600,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              avaliacao.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Profissão
                  Text(
                    profissao,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Bairro
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.redAccent,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          bairro,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Indicação
                  Text(
                    indicacao,
                    style: const TextStyle(color: Colors.black45, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  // Botões WhatsApp e Mapa
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _abrirWhatsApp(whatsapp),
                          icon: const Icon(Icons.phone, size: 18),
                          label: const Text("WhatsApp"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            minimumSize: const Size(0, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _abrirMaps(endereco),
                          icon: const Icon(Icons.map_rounded, size: 18),
                          label: const Text("Mapa"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            minimumSize: const Size(0, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
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
    );
  }

  bool _matchesFilter(Map<String, dynamic> data) {
    final nome = (data['nome'] ?? '').toString().toLowerCase();
    final bairro = (data['bairro'] ?? '').toString().toLowerCase();
    final profissao = (data['profissao'] ?? '').toString();
    final searchMatch =
        _search.isEmpty || nome.contains(_search) || bairro.contains(_search);
    final catMatch =
        _categoria == 'Todos' ||
        profissao.toLowerCase() == _categoria.toLowerCase();
    return searchMatch && catMatch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Profissionais',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _servicosStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data?.docs ?? [];
                final filtered = docs
                    .map((d) => d.data() as Map<String, dynamic>)
                    .toList()
                    .where(_matchesFilter)
                    .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.search_off, size: 56, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            'Nenhum profissional encontrado',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, idx) {
                    final data = filtered[idx];
                    return _buildCard(data);
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
