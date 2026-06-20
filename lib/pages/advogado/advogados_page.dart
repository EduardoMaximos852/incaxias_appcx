import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import 'advogado_detalhe_page.dart';

class AdvogadosPage extends StatefulWidget {
  const AdvogadosPage({super.key});

  @override
  State<AdvogadosPage> createState() => _AdvogadosPageState();
}

class _AdvogadosPageState extends State<AdvogadosPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _filtro = 'nome'; // 'nome' | 'especialidade' | 'cidade'
  String _query = '';

  // Helper: aplica filtro local nos documentos
  List<Map<String, dynamic>> _aplicarFiltro(List<QueryDocumentSnapshot> docs) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) {
      return docs.map((d) => d.data() as Map<String, dynamic>).toList();
    }
    return docs.map((d) => d.data() as Map<String, dynamic>).where((map) {
      final campo = (map[_filtro] ?? '').toString().toLowerCase();
      return campo.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: AppText.title('Advogados de Caxias'),
        backgroundColor: Colors.deepPurple.shade600,
        elevation: 1,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // BARRA DE BUSCA SUPERIOR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Row(
              children: [
                // Campo de texto
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 0.9,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (v) => setState(() => _query = v),
                            decoration: const InputDecoration(
                              isDense: true,
                              hintText: 'Buscar...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        if (_query.isNotEmpty)
                          GestureDetector(
                            onTap: () => setState(() => _query = ''),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.grey.shade500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Dropdown para escolher filtro
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200, width: 0.9),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _filtro,
                      items: const [
                        DropdownMenuItem(value: 'nome', child: Text('Nome')),
                        DropdownMenuItem(
                          value: 'especialidade',
                          child: Text('Especialidade'),
                        ),
                        DropdownMenuItem(
                          value: 'cidade',
                          child: Text('Cidade'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _filtro = v);
                      },
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LISTAGEM (expande)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('advogados')
                  .orderBy('nome')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhum advogado encontrado.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  );
                }

                final filtered = _aplicarFiltro(snapshot.data!.docs);

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhum resultado para a busca.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  );
                }

                // Lista compacta (altura ~64)
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 6,
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 3),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final adv = filtered[index];
                    return _buildAdvogadoCard(context, adv);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvogadoCard(BuildContext context, Map<String, dynamic> adv) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AdvogadoDetalhePage(dados: adv)),
        );
      },
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade200, width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            // FOTO pequena
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                adv['fotoUrl'] ?? '',
                height: 42,
                width: 42,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 42,
                  width: 42,
                  color: Colors.deepPurple.shade100,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // TEXTO
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adv['nome'] ?? 'Sem nome',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    adv['especialidade'] ?? '',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.deepPurple.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ÍCONE
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdvogadoDetalhePage(dados: adv),
                  ),
                );
              },
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: Colors.deepPurple,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
