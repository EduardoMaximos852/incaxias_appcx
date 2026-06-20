import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class DevTeamPage extends StatelessWidget {
  final String empresaId;

  const DevTeamPage({super.key, required this.empresaId});

  Future<DocumentSnapshot> _getEmpresaData() async {
    return FirebaseFirestore.instance
        .collection('empresa')
        .doc(empresaId)
        .get();
  }

  Future<void> _abrirLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _abrirWhatsApp(String numero) async {
    final clean = numero.replaceAll(RegExp(r'[^0-9+]'), '');
    await _abrirLink('https://wa.me/$clean');
  }

  Future<void> _ligarTelefone(String numero) async {
    await _abrirLink('tel:$numero');
  }

  Future<void> _enviarEmail(String email) async {
    await _abrirLink('mailto:$email');
  }

  Widget _buildRedesSociais(
    String instagram,
    String facebook,
    String linkedin,
  ) {
    List<Widget> icons = [];
    if (instagram.isNotEmpty)
      icons.add(_buildIconButton(Icons.camera_alt, instagram, Colors.pink));
    if (facebook.isNotEmpty)
      icons.add(
        _buildIconButton(Icons.facebook, facebook, Colors.blue.shade800),
      );
    if (linkedin.isNotEmpty)
      icons.add(_buildIconButton(Icons.business, linkedin, Colors.blueAccent));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: icons
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: e,
            ),
          )
          .toList(),
    );
  }

  Widget _buildIconButton(IconData icon, String url, Color color) {
    return InkWell(
      onTap: () => _abrirLink(url),
      borderRadius: BorderRadius.circular(12),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: color,
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.home),
      ),
      backgroundColor: Colors.grey.shade100,

      body: FutureBuilder<DocumentSnapshot>(
        future: _getEmpresaData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || !snapshot.data!.exists)
            return const Center(child: Text('Dados não encontrados.'));

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final String nome = data['nome'] ?? 'DevTeamWeb';
          final String logoUrl = data['logoUrl'] ?? '';
          final String endereco = data['endereco'] ?? '';
          final String telefone = data['telefone'] ?? '';
          final String whatsapp = data['whatsapp'] ?? '';
          final String email = data['email'] ?? '';
          final String site = data['site'] ?? '';
          final String instagram = data['instagram'] ?? '';
          final String facebook = data['facebook'] ?? '';
          final String linkedin = data['linkedin'] ?? '';

          return Center(
            child: Card(
              margin: const EdgeInsets.all(16),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo retangular com destaque
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          logoUrl,
                          height: 150,
                          width: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      nome,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      endereco,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.black54,
                      ),
                    ),
                    const Divider(height: 20, thickness: 1),

                    // Contatos
                    Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.phone,
                            size: 20,
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            telefone,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onTap: () => _ligarTelefone(telefone),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.phone,
                            size: 20,
                            color: Colors.green,
                          ),
                          title: Text(
                            whatsapp,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onTap: () => _abrirWhatsApp(whatsapp),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.email,
                            size: 20,
                            color: Colors.redAccent,
                          ),
                          title: Text(
                            email,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onTap: () => _enviarEmail(email),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.web,
                            size: 20,
                            color: Colors.deepPurple,
                          ),
                          title: Text(
                            site,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onTap: () => _abrirLink(site),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Redes sociais como ícones
                    _buildRedesSociais(instagram, facebook, linkedin),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
