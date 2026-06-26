import 'package:flutter/material.dart';
import 'package:incaxias_appcx/pages/instituicoes/instituicoes_page.dart';

import 'package:incaxias_appcx/pages/turismo/turismo_page.dart';
import 'package:incaxias_appcx/widgets/banner_carousel.dart';
import 'package:incaxias_appcx/widgets/categorias_grid.dart';
import 'package:incaxias_appcx/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'InCaxias',
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.deepOrange),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.deepOrange),
            tooltip: 'Sair',
            onPressed: () {},
          ),
        ],
      ),
      drawer: const Drawer(child: DrawerPage()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // 🔹 Carrossel Firebase
            BannerCarousel(),
            SizedBox(height: 10),
            // 🔹 Botoes Firebase
            Text(
              'Comercio de Caxias',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            CategoriasGrid(),

            //CarroucelReelsIncaxias(),
            const SizedBox(height: 16),
            Text(
              'Instituições em Caxias',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            InstituicoesPage(),
            const SizedBox(height: 16),
            Text(
              'Turismo em Caxias, 🛤',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            TurismoPage(),
            const SizedBox(height: 16),
            Text(
              'Cultura de Caxias 🎭',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/cultura');
                  },
                  child: Stack(
                    children: [
                      // IMAGEM
                      Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPeH_s8AmR3pbdI9gUGrKyLH_FuAVSiiUthAzW61D_3Q&s=10',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      // SOBREPOSIÇÃO ESCURA
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(
                            alpha: 0.3,
                          ), // intensidade da sobreposição
                        ),
                      ),
                      // TEXTO OU BOTÃO CENTRAL
                      const Center(
                        child: Text(
                          'CULTURA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/devteam');
                  },
                  child: Text('Devteam Contato'),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),

        // 🔹 Ícones de acesso rápido
      ),
    );
  }
}
