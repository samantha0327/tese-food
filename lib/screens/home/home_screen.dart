import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/accessibility_provider.dart';
import '../../screens/settings/accessibility_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibilityProvider>();

    return Scaffold(
      backgroundColor: access.backgroundColor,
      appBar: _buildAppBar(context, access),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(access),
            const SizedBox(height: 28),
            _buildSectionTitle('¿Qué deseas hacer?', access),
            const SizedBox(height: 16),
            _buildMenuGrid(context, access),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, AccessibilityProvider access) {
    return AppBar(
      backgroundColor: access.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
      title: Text(
        'Cafetería TESE',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20 * access.textScaleFactor,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        // Botón de accesibilidad
        IconButton(
          icon: const Icon(Icons.accessibility_new),
          tooltip: 'Accesibilidad',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AccessibilityScreen(),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBanner(AccessibilityProvider access) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: access.highContrast
              ? [
                  const Color(0xFF004D00),
                  const Color(0xFF007000),
                ]
              : [
                  const Color(0xFF2D5016),
                  const Color(0xFF4A7C2F),
                  const Color(0xFF6B9E3F),
                ],
        ),
      ),
      child: Stack(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Disfruta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28 * access.textScaleFactor,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                Text(
                  'nuestro menú',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28 * access.textScaleFactor,
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
                  child: Text(
                    '☕  Recién preparado para ti',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13 * access.textScaleFactor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildSectionTitle(String title, AccessibilityProvider access) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18 * access.textScaleFactor,
          fontWeight: FontWeight.w700,
          color: access.textColor,
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context, AccessibilityProvider access) {
    final List<_MenuOption> options = [
      _MenuOption(
        icon: Icons.shopping_cart_outlined,
        label: 'Realizar\npedido',
        color: access.highContrast
            ? const Color(0xFF00CC00)
            : const Color(0xFF2D5016),
        onTap: () {},
      ),
      _MenuOption(
        icon: Icons.receipt_long_outlined,
        label: 'Mi\npedido',
        color: access.highContrast
            ? const Color(0xFF4FC3F7)
            : const Color(0xFF1565C0),
        onTap: () {},
      ),
      _MenuOption(
        icon: Icons.restaurant_menu_outlined,
        label: 'Menú',
        color: access.highContrast
            ? const Color(0xFFCE93D8)
            : const Color(0xFF6A1E55),
        onTap: () {},
      ),
      _MenuOption(
        icon: Icons.notifications_outlined,
        label: 'Notificaciones',
        color: access.highContrast
            ? const Color(0xFFFFB74D)
            : const Color(0xFFE65100),
        onTap: () {},
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
        children: options
            .map((option) => _MenuCard(option: option, access: access))
            .toList(),
      ),
    );
  }
}

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

class _MenuCard extends StatelessWidget {
  final _MenuOption option;
  final AccessibilityProvider access;

  const _MenuCard({required this.option, required this.access});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: option.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: access.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: access.highContrast
                ? Border.all(color: option.color, width: 2)
                : null,
            boxShadow: [
              if (!access.highContrast)
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
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: option.color.withAlpha(access.highContrast ? 60 : 25),
                  shape: BoxShape.circle,
                ),
                child: Icon(option.icon, size: 32, color: option.color),
              ),
              const SizedBox(height: 12),
              Text(
                option.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14 * access.textScaleFactor,
                  fontWeight: FontWeight.w600,
                  color: access.textColor,
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
