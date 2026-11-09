import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBeige,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            const SizedBox(height: 28),
            _buildSectionTitle('¿Qué deseas hacer?'),
            const SizedBox(height: 16),
            _buildMenuGrid(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      title: const Text(
        'Cafetería TESE',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () {
            // TODO: navegar al carrito
          },
        ),
      ],
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryGreen,
            AppTheme.lightGreen,
            AppTheme.accentGreen,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Círculos decorativos de fondo
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(20),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(15),
              ),
            ),
          ),

          // Contenido del banner
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Disfruta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const Text(
                  'nuestro menú',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '☕  Recién preparado para ti',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Ícono decorativo derecho
          Positioned(
            right: 24,
            top: 0,
            bottom: 0,
            child: Center(
              child: Icon(
                Icons.coffee,
                size: 72,
                color: Colors.white.withAlpha(60),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppTheme.textDark,
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final List<_MenuOption> options = [
      _MenuOption(
        icon: Icons.shopping_cart_outlined,
        label: 'Realizar\npedido',
        color: AppTheme.primaryGreen,
        onTap: () {
          // TODO: navegar a menú de productos
        },
      ),
      _MenuOption(
        icon: Icons.receipt_long_outlined,
        label: 'Mi\npedido',
        color: const Color(0xFF1565C0),
        onTap: () {
          // TODO: navegar a mis pedidos
        },
      ),
      _MenuOption(
        icon: Icons.restaurant_menu_outlined,
        label: 'Menú',
        color: const Color(0xFF6A1E55),
        onTap: () {
          // TODO: navegar al menú
        },
      ),
      _MenuOption(
        icon: Icons.notifications_outlined,
        label: 'Notificaciones',
        color: const Color(0xFFE65100),
        onTap: () {
          // TODO: navegar a notificaciones
        },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.1,
        children: options.map((option) => _MenuCard(option: option)).toList(),
      ),
    );
  }
}

// ─── Modelo interno ────────────────────────────────────────────────────────────

class _MenuOption {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

// ─── Tarjeta de opción ─────────────────────────────────────────────────────────

class _MenuCard extends StatelessWidget {
  final _MenuOption option;

  const _MenuCard({required this.option});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: option.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(18),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícono con fondo de color
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: option.color.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  option.icon,
                  size: 32,
                  color: option.color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                option.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
