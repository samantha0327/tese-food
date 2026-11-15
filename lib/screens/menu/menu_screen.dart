import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/accessibility_provider.dart';
import '../../services/vibration_service.dart';
import '../../widgets/visual_alert_banner.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibilityProvider>();
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: access.backgroundColor,
      appBar: _buildAppBar(context, access, cart),
      body: Column(
        children: [
          _buildSearchBar(access),
          if (_searchQuery.isEmpty) _buildTabBar(access),
          Expanded(
            child: _searchQuery.isNotEmpty
                ? _buildSearchResults(access, cart)
                : _buildTabContent(access, cart),
          ),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AccessibilityProvider access,
    CartProvider cart,
  ) {
    return AppBar(
      backgroundColor: access.primaryColor,
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Menú',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20 * access.textScaleFactor,
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                // TODO: navegar al carrito
              },
            ),
            if (cart.totalItems > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${cart.totalItems}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // ── Barra de búsqueda ─────────────────────────────────────────────────────

  Widget _buildSearchBar(AccessibilityProvider access) {
    return Container(
      color: access.primaryColor,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        style: TextStyle(
          color: access.highContrast ? Colors.white : Colors.black87,
          fontSize: 15 * access.textScaleFactor,
        ),
        decoration: InputDecoration(
          hintText: 'Buscar productos...',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14 * access.textScaleFactor,
          ),
          prefixIcon:
              const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: access.highContrast
              ? const Color(0xFF1A1A1A)
              : Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ── Tab Bar de categorías ─────────────────────────────────────────────────

  Widget _buildTabBar(AccessibilityProvider access) {
    final categories = ['Bebidas', 'Alimentos', 'Extras'];
    final icons = [
      Icons.local_cafe_outlined,
      Icons.restaurant_outlined,
      Icons.cookie_outlined,
    ];

    return Container(
      color: access.highContrast
          ? const Color(0xFF0D0D0D)
          : const Color(0xFFEEE8DC),
      child: TabBar(
        controller: _tabController,
        labelColor: access.primaryColor,
        unselectedLabelColor: access.secondaryTextColor,
        indicatorColor: access.primaryColor,
        indicatorWeight: 3,
        labelStyle: TextStyle(
          fontSize: 13 * access.textScaleFactor,
          fontWeight: FontWeight.w600,
        ),
        tabs: List.generate(
          3,
          (i) => Tab(
            icon: Icon(icons[i], size: 20),
            text: categories[i],
          ),
        ),
      ),
    );
  }

  // ── Contenido de tabs ─────────────────────────────────────────────────────

  Widget _buildTabContent(
      AccessibilityProvider access, CartProvider cart) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildProductList(
            ProductCatalog.byCategory(ProductCategory.bebidas),
            access,
            cart),
        _buildProductList(
            ProductCatalog.byCategory(ProductCategory.alimentos),
            access,
            cart),
        _buildProductList(
            ProductCatalog.byCategory(ProductCategory.extras),
            access,
            cart),
      ],
    );
  }

  // ── Resultados de búsqueda ────────────────────────────────────────────────

  Widget _buildSearchResults(
      AccessibilityProvider access, CartProvider cart) {
    final results = ProductCatalog.search(_searchQuery);
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off,
                size: 64, color: access.secondaryTextColor),
            const SizedBox(height: 16),
            Text(
              'No se encontraron productos',
              style: TextStyle(
                fontSize: 16 * access.textScaleFactor,
                color: access.secondaryTextColor,
              ),
            ),
          ],
        ),
      );
    }
    return _buildProductList(results, access, cart);
  }

  // ── Lista de productos ────────────────────────────────────────────────────

  Widget _buildProductList(
    List<ProductModel> products,
    AccessibilityProvider access,
    CartProvider cart,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),      itemBuilder: (context, index) =>
          _ProductCard(product: products[index], access: access, cart: cart),
    );
  }
}

// ── Tarjeta de producto ───────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final AccessibilityProvider access;
  final CartProvider cart;

  const _ProductCard({
    required this.product,
    required this.access,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    final qty = cart.quantityOf(product.id);
    final inCart = qty > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: access.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: inCart
            ? Border.all(
                color: access.primaryColor,
                width: 2,
              )
            : access.highContrast
                ? Border.all(color: Colors.white24)
                : null,
        boxShadow: [
          if (!access.highContrast)
            BoxShadow(
              color: Colors.black.withAlpha(inCart ? 25 : 15),
              blurRadius: inCart ? 12 : 8,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Emoji del producto
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: access.highContrast
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFF0EDE6),
                borderRadius: BorderRadius.circular(12),
                border: access.highContrast
                    ? Border.all(color: Colors.white24)
                    : null,
              ),
              child: Center(
                child: Text(
                  product.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Nombre, descripción y precio
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 15 * access.textScaleFactor,
                      fontWeight: FontWeight.w700,
                      color: access.textColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 12 * access.textScaleFactor,
                      color: access.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.priceLabel,
                    style: TextStyle(
                      fontSize: 16 * access.textScaleFactor,
                      fontWeight: FontWeight.w800,
                      color: access.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Controles de cantidad
            if (inCart)
              _QuantityControl(
                  quantity: qty, product: product, access: access, cart: cart)
            else
              _AddButton(product: product, access: access, cart: cart),
          ],
        ),
      ),
    );
  }
}

// ── Botón agregar (+) ─────────────────────────────────────────────────────────

class _AddButton extends StatelessWidget {
  final ProductModel product;
  final AccessibilityProvider access;
  final CartProvider cart;

  const _AddButton({
    required this.product,
    required this.access,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        cart.addProduct(product);
        if (access.vibrationEnabled) await VibrationService.light();
        if (context.mounted) {
          VisualAlertBanner.show(
            context,
            message: '${product.name} agregado al carrito',
            type: AlertType.success,
          );
        }
      },
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: access.primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            if (!access.highContrast)
              BoxShadow(
                color: access.primaryColor.withAlpha(80),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 22),
      ),
    );
  }
}

// ── Control de cantidad (- N +) ───────────────────────────────────────────────

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final ProductModel product;
  final AccessibilityProvider access;
  final CartProvider cart;

  const _QuantityControl({
    required this.quantity,
    required this.product,
    required this.access,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleButton(
          icon: Icons.remove,
          color: access.highContrast
              ? Colors.white
              : access.primaryColor,
          backgroundColor: access.highContrast
              ? const Color(0xFF333333)
              : access.primaryColor.withAlpha(20),
          onTap: () async {
            cart.removeProduct(product);
            if (access.vibrationEnabled) await VibrationService.light();
          },
        ),
        SizedBox(
          width: 32,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16 * access.textScaleFactor,
              fontWeight: FontWeight.bold,
              color: access.textColor,
            ),
          ),
        ),
        _CircleButton(
          icon: Icons.add,
          color: Colors.white,
          backgroundColor: access.primaryColor,
          onTap: () async {
            cart.addProduct(product);
            if (access.vibrationEnabled) await VibrationService.light();
          },
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
