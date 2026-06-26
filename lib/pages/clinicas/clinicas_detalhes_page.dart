import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:incaxias_appcx/theme/app_colors.dart';
import 'package:incaxias_appcx/theme/app_text.dart';
import 'package:incaxias_appcx/widgets/whatssap_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicaDetalhesPage extends StatelessWidget {
  final String idClinica;
  final Map<String, dynamic> dados;

  const ClinicaDetalhesPage({
    super.key,
    required this.idClinica,
    required this.dados,
  });

  Future<void> _abrirWhatsApp() async {
    final numero = dados['whatsapp'] ?? '';

    if (numero.isEmpty) return;

    await launchUrl(
      Uri.parse('https://wa.me/55$numero'),
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _abrirMapa() async {
    final localizacao = dados['localizacao'] ?? '';

    if (localizacao.isEmpty) return;

    await launchUrl(
      Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$localizacao',
      ),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> profissionaisMap = dados['profissionais'] != null
        ? Map<String, dynamic>.from(
            dados['profissionais'],
          )
        : {};

    final List<Map<String, dynamic>> profissionais = profissionaisMap.values
        .map(
          (e) => Map<String, dynamic>.from(e),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: AppText.title(
          dados['nome'] ?? 'Clínica',
        ),
      ),
      body: ListView(
        children: [
          _buildCapa(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInformacoes(),
                const SizedBox(height: 20),
                if (profissionais.isNotEmpty)
                  _buildProfissionais(profissionais),
                const SizedBox(height: 20),
                _buildEscalaMedica(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapa() {
    final foto = dados['fotoCapa'] ?? '';

    if (foto.toString().isEmpty) {
      return Container(
        height: 220,
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.local_hospital,
          size: 80,
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: Image.network(
        foto,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) {
          return Container(
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.local_hospital,
              size: 80,
            ),
          );
        },
      ),
    );
  }

  Widget _buildInformacoes() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppText.body(
                    dados['endereco'] ?? '',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _abrirWhatsApp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const WhatsAppIconSimple(
                      size: 24,
                    ),
                    label: const Text(
                      'WhatsApp',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _abrirMapa,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Localização',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfissionais(List profissionais) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.subtitle(
          'Profissionais',
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: profissionais.length,
            itemBuilder: (_, index) {
              final p = profissionais[index];

              return Container(
                width: 170,
                margin: const EdgeInsets.only(
                  right: 12,
                ),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            p['foto'] ?? '',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                height: 120,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.person,
                                  size: 50,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          p['nome'] ?? '',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          p['especialidade'] ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEscalaMedica() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.subtitle(
          'Escala Médica da Semana',
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('clinicas')
              .doc(idClinica)
              .collection('escala')
              .orderBy('data')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppText.body(
                    'Nenhum médico cadastrado na escala.',
                  ),
                ),
              );
            }

            return Column(
              children: snapshot.data!.docs.map((doc) {
                final e = doc.data() as Map<String, dynamic>;

                final Timestamp ts = e['data'];

                final data = ts.toDate();

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatarData(data),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              e['horario'] ?? '',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.medical_services,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                e['medico'] ?? '',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          e['especialidade'] ?? '',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

String _formatarData(DateTime data) {
  return "${data.day.toString().padLeft(2, '0')}/"
      "${data.month.toString().padLeft(2, '0')}/"
      "${data.year}";
}
