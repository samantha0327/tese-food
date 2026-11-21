import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/accessibility_provider.dart';
import '../../models/cart_item_model.dart';
import '../../services/vibration_service.dart';
import '../../widgets/visual_alert_banner.dart';
import 'order_confirmation_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibilityProvider>();
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: access.backgroundColor,
      appBar: AppBar(
        backgroundColor: access.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Tu pedido',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20 * access.textScaleFactor,
          ),
        ),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                _showClearCartDialog(context, cart, access);
              },
              icon: const Icon(Icons.delete_outline, color: Colors.white70, size: 20),
              label: Text(
                'Vaciar',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13 * access.textScaleFactor,
                ),
              ),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? _buildEmptyCart(context, access)
          : _buildCartContent(context, cart, access),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : _buildBottomBar(context, cart, access),
    );
  }

  // ── Carrito vacío ─────────────────────────────────────────────────────────

  Widget _buildEmptyCart(BuildContext context, AccessibilityProvider access) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 90,
            color: access.secondaryTextColor,
          ),
          const SizedBox(height: 20),
          Text(
            'Tu carrito está vacío',
            style: TextStyle(
              fontSize: 20 * access.textScaleFactor,
              fontWeight: FontWeight.w700,
              color: access.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega productos desde el menú',
            style: TextStyle(
              fontSize: 14 * access.textScaleFactor,
              color: access.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Ir al menú'),
          ),
        ],
      ),
    );
  }

  // ── Contenido del carrito ─────────────────────────────────────────────────

  Widget _buildCartContent(
    BuildContext context,
    CartProvider cart,
    AccessibilityProvider access,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Encabezado con cantidad de productos
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            '${cart.items.length} ${cart.items.length == 1 ? 'producto' : 'productos'}',
            style: TextStyle(
              fontSize: 14 * access.textScaleFactor,
              color: access.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Lista de productos
        ...cart.items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CartItemCard(item: item, access: access, cart: cart),
          ),
        ),

        const SizedBox(height: 8),

        // Resumen del pedido
        _buildOrderSummary(cart, access),

        const SizedBox(height: 100),
      ],
    );
  }

  // ── Resumen del pedido ────────────────────────────────────────────────────

  Widget _buildOrderSummary(CartProvider cart, AccessibilityProvider access) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: access.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: access.highContrast ? Border.all(color: Colors.white24) : null,
        boxShadow: [
          if (!access.highContrast)
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 14 * access.textScaleFactor,
                  color: access.secondaryTextColor,
                ),
              ),
              Text(
                '\$${cart.totalPrice.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 14 * access.textScaleFactor,
                  color: access.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: access.highContrast ? Colors.white24 : Colors.grey.shade200),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 18 * access.textScaleFactor,
                  fontWeight: FontWeight.w800,
                  color: access.textColor,
                ),
              ),
              Text(
                '\$${cart.totalPrice.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 22 * access.textScaleFactor,
                  fontWeight: FontWeight.w900,
                  color: access.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Barra inferior con botón confirmar ────────────────────────────────────

  Widget _buildBottomBar(
    BuildContext context,
    CartProvider cart,
    AccessibilityProvider access,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: access.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: access.primaryColor,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () async {
          if (access.vibrationEnabled) await VibrationService.success();
          if (context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const OrderConfirmationScreen(),
              ),
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Confirmar pedido  •  \$${cart.totalPrice.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 16 * access.textScaleFactor,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Diálogo vaciar carrito ────────────────────────────────────────────────

  void _showClearCartDialog(
    BuildContext context,
    CartProvider cart,
    AccessibilityProvider access,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: access.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '¿Vaciar carrito?',
          style: TextStyle(
            color: access.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18 * access.textScaleFactor,
          ),
        ),
        content: Text(
          'Se eliminarán todos los productos de tu pedido.',
          style: TextStyle(
            color: access.secondaryTextColor,
            fontSize: 14 * access.textScaleFactor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(color: access.secondaryTextColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              cart.clear();
              Navigator.of(ctx).pop();
              VisualAlertBanner.show(
                context,
                message: 'Carrito vaciado',
                type: AlertType.warning,
              );
            },
            child: const Text('Vaciar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta de producto en el carrito ─────────────────────────────────────────

class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final AccessibilityProvider access;
  final CartProvider cart;

  const _CartItemCard({
    required this.item,
    required this.access,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: access.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: access.highContrast ? Border.all(color: Colors.white24) : null,
        boxShadow: [
          if (!access.highContrast)
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Emoji
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: access.highContrast
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFF0EDE6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  item.product.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Nombre y precio unitario
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: TextStyle(
                      fontSize: 15 * access.textScaleFactor,
                      fontWeight: FontWeight.w700,
                      color: access.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.product.priceLabel,
                    style: TextStyle(
                      fontSize: 13 * access.textScaleFactor,
                      color: access.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

            // Controles de cantidad
            Row(
              children: [
                _SmallButton(
                  icon: item.quantity == 1 ? Icons.delete_outline : Icons.remove,
                  color: item.quantity == 1 ? Colors.red.shade400 : access.primaryColor,
                  onTap: () async {
                    cart.removeProduct(item.product);
                    if (access.vibrationEnabled) await VibrationService.light();
                  },
                ),
                SizedBox(
                  width: 32,
                  child: Text(
                    '${item.quantity}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16 * access.textScaleFactor,
                      fontWeight: FontWeight.bold,
                      color: access.textColor,
                    ),
                  ),
                ),
                _SmallButton(
                  icon: Icons.add,
                  color: access.primaryColor,
                  onTap: () async {
                    cart.addProduct(item.product);
                    if (access.vibrationEnabled) await VibrationService.light();
                  },
                ),
              ],
            ),

            const SizedBox(width: 10),

            // Subtotal del producto
            Text(
              '\$${item.subtotal.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 15 * access.textScaleFactor,
                fontWeight: FontWeight.w800,
                color: access.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SmallButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
