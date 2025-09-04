import 'package:flutter/material.dart';
import '../../../models/product.dart';


class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            'http://localhost:8080/${product.image}',
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/images/default.jpg', 
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(product.title, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('${product.price} ${product.currency}'),
          ),
          if (product.stock == 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Sin stock', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }
}
