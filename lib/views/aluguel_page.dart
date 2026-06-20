import 'package:flutter/material.dart';
import 'package:incaxias_appcx/models/aluguel.dart';
import 'package:incaxias_appcx/pages/aluguel/detalhe_aluguel_page1.dart';
import 'package:incaxias_appcx/viewmodels/aluguel_viewmodel.dart';

class AluguelPage extends StatefulWidget {
  const AluguelPage({super.key});

  @override
  State<AluguelPage> createState() => _AluguelPageState();
}

class _AluguelPageState extends State<AluguelPage> {
  final vm = AluguelViewModel();

  final tipos = ["Todos", "Casa", "Sítio", "Kitnet", "Apartamento"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Aluguéis",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          /// 🔎 FILTROS
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Column(
              children: [
                SizedBox(
                  height: 36,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Buscar bairro...",
                      prefixIcon: const Icon(Icons.search, size: 18),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => vm.bairroBusca = value);
                    },
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: vm.tipoSelecionado,
                        items: tipos
                            .map(
                              (t) => DropdownMenuItem(value: t, child: Text(t)),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => vm.tipoSelecionado = value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text("Até R\$ ${vm.precoMax.toInt()}"),
                  ],
                ),

                Slider(
                  value: vm.precoMax,
                  min: 300,
                  max: 10000,
                  divisions: 50,
                  onChanged: (value) {
                    setState(() => vm.precoMax = value);
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          /// 📦 LISTA
          Expanded(
            child: StreamBuilder<List<Aluguel>>(
              stream: vm.streamAlugueis(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filtrados = vm.filtrar(snapshot.data!);

                if (filtrados.isEmpty) {
                  return const Center(child: Text("Nenhum resultado"));
                }

                return ListView.builder(
                  itemCount: filtrados.length,
                  itemBuilder: (context, index) {
                    final item = filtrados[index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetalheAluguelPage(aluguel: item),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            if (item.imagens.isNotEmpty)
                              Image.network(
                                item.imagens.first,
                                width: 90,
                                height: 70,
                                fit: BoxFit.cover,
                              ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.titulo,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(item.bairro),
                                  Text("${item.quartos}q • ${item.banheiros}b"),
                                ],
                              ),
                            ),

                            Text(
                              "R\$ ${item.preco.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
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
