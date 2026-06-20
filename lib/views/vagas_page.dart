import 'package:flutter/material.dart';
import 'package:incaxias_appcx/respository/vagas_repository.dart';
import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import '../../models/vaga.dart';
import 'package:incaxias_appcx/routes/routes.dart';

class VagasPage extends StatefulWidget {
  const VagasPage({super.key});

  @override
  State<VagasPage> createState() => _VagasPageState();
}

class _VagasPageState extends State<VagasPage> {
  final repository = VagasRepository();
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: AppText.title(
          "Vagas Emprego",
        ),
      ),
      body: Column(
        children: [
          /// 🔎 BUSCA PADRÃO MELHORADA
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 0.6,
                ),
              ),
              child: TextField(
                style: const TextStyle(
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  hintText: "Buscar por vaga, empresa ou bairro...",
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.black54,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                ),
                onChanged: (value) {
                  setState(() => search = value.trim().toLowerCase());
                },
              ),
            ),
          ),

          const Divider(height: 1),

          /// 📋 LISTA
          Expanded(
            child: StreamBuilder<List<Vaga>>(
              stream: repository.getVagas(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }

                final vagas = snapshot.data!;
                final query = search;

                final filtered = vagas.where((vaga) {
                  return vaga.titulo.toLowerCase().contains(query) ||
                      vaga.empresa.toLowerCase().contains(query) ||
                      vaga.bairro.toLowerCase().contains(query) ||
                      vaga.tipoVaga.toLowerCase().contains(query);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: AppText.body(
                      "Nenhuma vaga encontrada",
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Colors.black12),
                  itemBuilder: (context, index) {
                    final vaga = filtered[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.vagaDetalhe,
                            arguments: vaga.id,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              /// IMAGEM
                              Image.network(
                                vaga.imageUrl,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) {
                                  return Container(
                                    color: Colors.grey.shade200,
                                    height: 80,
                                    width: 80,
                                    child: const Icon(
                                      Icons.storefront,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(width: 12),

                              /// TEXTO
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText.caption(
                                      vaga.titulo,
                                    ),
                                    const SizedBox(height: 2),
                                    AppText.menutitle(
                                      vaga.empresa,
                                    ),
                                    const SizedBox(height: 2),
                                    AppText.menutitle(
                                      "Bairro: ${vaga.bairro}",
                                    ),
                                  ],
                                ),
                              ),

                              /// SETA
                              const Icon(
                                Icons.chevron_right,
                                size: 18,
                                color: Colors.black38,
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
