import 'package:flutter/material.dart';
import '../../../models/product.dart';
import 'product_card.dart';

class ProductsGrid extends StatelessWidget {
  final List<Product> products;
  final double cardWidth; // ancho fijo de cada card

  const ProductsGrid({
    super.key,
    required this.products,
    this.cardWidth = 200, // ajustable según diseño
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: products.map((product) {
        return SizedBox(
          width: cardWidth,
          child: ProductCard(product: product),
        );
      }).toList(),
    );
  }
}
