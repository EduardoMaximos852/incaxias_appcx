import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // Cabeçalho com design leve
          UserAccountsDrawerHeader(
            accountName: Text(''),
            accountEmail: Text(''),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(Icons.person, color: Colors.deepOrange),
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange, Colors.orangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 🔹 Opções de navegação
          _drawerItem(
            icon: Icons.home,
            text: 'Início',
            onTap: () => Navigator.pop(context),
          ),
          _drawerItem(
            icon: Icons.local_pizza,
            text: 'Pizzarias',
            onTap: () => Navigator.pushNamed(context, '/pizzarias'),
          ),
          _drawerItem(
            icon: Icons.account_balance,
            text: 'Institucionais',
            onTap: () => Navigator.pushNamed(context, '/institucionais'),
          ),
          _drawerItem(
            icon: Icons.park,
            text: 'Turismo',
            onTap: () => Navigator.pushNamed(context, '/turismo'),
          ),
          const Divider(),
          _drawerItem(
            icon: Icons.logout,
            text: 'Sair',
            color: Colors.redAccent,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color color = Colors.deepOrange,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }
}
