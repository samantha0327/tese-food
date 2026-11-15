enum ProductCategory { bebidas, alimentos, extras }

class ProductModel {
  final String id;
  final String name;
  final double price;
  final ProductCategory category;
  final String description;
  final String emoji; // ícono visual del producto

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.emoji,
  });

  String get categoryLabel {
    switch (category) {
      case ProductCategory.bebidas:
        return 'Bebidas';
      case ProductCategory.alimentos:
        return 'Alimentos';
      case ProductCategory.extras:
        return 'Extras';
    }
  }

  String get priceLabel => '\$${price.toStringAsFixed(0)}';
}

/// Catálogo de productos de la Cafetería TESE
class ProductCatalog {
  static const List<ProductModel> all = [
    // ── Bebidas ────────────────────────────────────────────────────────
    ProductModel(
      id: 'b1',
      name: 'Café americano',
      price: 25,
      category: ProductCategory.bebidas,
      description: 'Café negro recién preparado',
      emoji: '☕',
    ),
    ProductModel(
      id: 'b2',
      name: 'Latte',
      price: 35,
      category: ProductCategory.bebidas,
      description: 'Espresso con leche vaporizada',
      emoji: '🥛',
    ),
    ProductModel(
      id: 'b3',
      name: 'Capuchino',
      price: 35,
      category: ProductCategory.bebidas,
      description: 'Espresso con espuma de leche',
      emoji: '☕',
    ),
    ProductModel(
      id: 'b4',
      name: 'Té verde',
      price: 20,
      category: ProductCategory.bebidas,
      description: 'Té verde natural caliente o frío',
      emoji: '🍵',
    ),
    ProductModel(
      id: 'b5',
      name: 'Jugo de naranja',
      price: 25,
      category: ProductCategory.bebidas,
      description: 'Jugo natural exprimido',
      emoji: '🍊',
    ),
    ProductModel(
      id: 'b6',
      name: 'Agua mineral',
      price: 15,
      category: ProductCategory.bebidas,
      description: 'Agua mineralizada fría',
      emoji: '💧',
    ),

    // ── Alimentos ──────────────────────────────────────────────────────
    ProductModel(
      id: 'a1',
      name: 'Panini',
      price: 45,
      category: ProductCategory.alimentos,
      description: 'Pan tostado con jamón y queso',
      emoji: '🥪',
    ),
    ProductModel(
      id: 'a2',
      name: 'Ensalada',
      price: 40,
      category: ProductCategory.alimentos,
      description: 'Ensalada fresca con aderezo',
      emoji: '🥗',
    ),
    ProductModel(
      id: 'a3',
      name: 'Quesadilla',
      price: 35,
      category: ProductCategory.alimentos,
      description: 'Tortilla con queso derretido',
      emoji: '🫓',
    ),
    ProductModel(
      id: 'a4',
      name: 'Hotcakes',
      price: 40,
      category: ProductCategory.alimentos,
      description: 'Tres hotcakes con miel y mantequilla',
      emoji: '🥞',
    ),
    ProductModel(
      id: 'a5',
      name: 'Sándwich',
      price: 38,
      category: ProductCategory.alimentos,
      description: 'Sándwich de pavo con vegetales',
      emoji: '🥙',
    ),

    // ── Extras ─────────────────────────────────────────────────────────
    ProductModel(
      id: 'e1',
      name: 'Muffin de chocolate',
      price: 22,
      category: ProductCategory.extras,
      description: 'Muffin esponjoso con chispas de chocolate',
      emoji: '🧁',
    ),
    ProductModel(
      id: 'e2',
      name: 'Dona glaseada',
      price: 18,
      category: ProductCategory.extras,
      description: 'Dona suave con glaseado de azúcar',
      emoji: '🍩',
    ),
    ProductModel(
      id: 'e3',
      name: 'Galletas',
      price: 15,
      category: ProductCategory.extras,
      description: 'Paquete de galletas surtidas',
      emoji: '🍪',
    ),
    ProductModel(
      id: 'e4',
      name: 'Fruta picada',
      price: 25,
      category: ProductCategory.extras,
      description: 'Mezcla de frutas de temporada',
      emoji: '🍓',
    ),
  ];

  static List<ProductModel> byCategory(ProductCategory category) =>
      all.where((p) => p.category == category).toList();

  static List<ProductModel> search(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return all;
    return all
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q))
        .toList();
  }
}
