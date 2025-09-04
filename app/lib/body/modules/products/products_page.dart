import 'package:app/models/product.dart';
import 'package:app/models/product_filter.dart';
import 'package:app/services/products_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'product_filters.dart';
import 'product_grid.dart';

class ProductsPage extends StatefulWidget {
  final Map<String, String>? params;
  const ProductsPage({super.key, this.params});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];
  bool isLoading = true;
  int currentPage = 1;
  int totalProducts = 0; // <- Total de productos para paginación

  late ProductFilter filters;

  @override
  void initState() {
    super.initState();
    filters = ProductFilter.fromParams(widget.params);
    fetchProducts(); // Solo al iniciar
  }

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);

    final response = await ProductsApi.getProducts(
      q: filters.query,
      oos: filters.includeOutOfStock,
      category: filters.category,
      limit: filters.limit,
      offset: filters.offset,
    );

    setState(() {
      products = response.items;
      totalProducts = response.total;
      isLoading = false;
    });
  }

  void _updateFilters(ProductFilter updated, {int page = 1}) {
    setState(() {
      filters = updated;
      currentPage = page;
      filters.offset = (currentPage - 1) * filters.limit;
    });

    // Actualiza la URL, pero NO llama fetchProducts automáticamente
    final queryString = <String>[];
    if (filters.query.isNotEmpty) queryString.add('q=${Uri.encodeComponent(filters.query)}');
    if (filters.includeOutOfStock) queryString.add('oos=true');
    if (filters.category != null) queryString.add('category=${Uri.encodeComponent(filters.category!)}');
    queryString.add('page=$currentPage');

    final url = '/productos?${queryString.join('&')}';
    GoRouter.of(context).go(url);
  }

  @override
  Widget build(BuildContext context) {
    final canGoPrev = currentPage > 1;
    final canGoNext = (currentPage * filters.limit) < totalProducts;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar SIN color de fondo
          SizedBox(
            width: 250,
            child: SingleChildScrollView(
              child: ProductFilters(
                filter: filters,
                onFilterChanged: (f) {
                  _updateFilters(f, page: 1);
                  fetchProducts(); // Solo se ejecuta cuando se presiona "Buscar"
                },
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      products.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('No hay productos para mostrar.'),
                            )
                          : ProductsGrid(products: products),
                      const SizedBox(height: 16),
                      if (products.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (canGoPrev)
                              ElevatedButton(
                                onPressed: () {
                                  _updateFilters(filters, page: currentPage - 1);
                                  fetchProducts();
                                },
                                child: const Text('Anterior'),
                              ),
                            if (canGoPrev) const SizedBox(width: 16),
                            Text('Página $currentPage'),
                            const SizedBox(width: 16),
                            if (canGoNext)
                              ElevatedButton(
                                onPressed: () {
                                  _updateFilters(filters, page: currentPage + 1);
                                  fetchProducts();
                                },
                                child: const Text('Siguiente'),
                              ),
                          ],
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
