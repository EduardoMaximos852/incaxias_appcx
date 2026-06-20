import 'package:flutter/material.dart';

class PetshopPage extends StatelessWidget {
  final String title;
  final String message;
  final String homeRouteName;

  const PetshopPage({
    super.key,
    this.title = 'Manutenção',
    this.message = 'Estamos em manutenção. Voltamos em breve!',
    this.homeRouteName = '/home',
  });

  void _goHome(BuildContext context) {
    // Remove todas as rotas e vai para a rota home (se existir).
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(homeRouteName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isWide = media.size.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 700),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícone com animação simples
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1.0),
                    duration: Duration(milliseconds: 600),
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) {
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: Container(
                      padding: EdgeInsets.all(isWide ? 28 : 20),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.construction,
                        size: isWide ? 84 : 64,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),

                  SizedBox(height: 28),

                  // Título
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isWide ? 28 : 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[900],
                    ),
                  ),

                  SizedBox(height: 12),

                  // Mensagem
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isWide ? 18 : 15,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 28),

                  // Botões: Voltar para Home + opção de atualizar
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _goHome(context),
                        icon: Icon(Icons.home_outlined),
                        label: Text('Voltar para a Home'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),

                      SizedBox(height: 18),

                      // Texto de rodapé pequeno
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
