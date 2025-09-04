import 'package:app/models/category.dart';
import 'package:app/models/product_filter.dart';
import 'package:app/services/categories_api.dart';
import 'package:flutter/material.dart';

class ProductFilters extends StatefulWidget {
  final ProductFilter filter;
  final Function(ProductFilter) onFilterChanged;

  const ProductFilters({
    super.key,
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  State<ProductFilters> createState() => _ProductFiltersState();
}

class _ProductFiltersState extends State<ProductFilters> {
  List<Category> categories = [];
  bool isLoadingCategories = true;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.filter.query);
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final result = await CategoriesApi.getCategories();
      setState(() {
        categories = result;
        isLoadingCategories = false;
      });
    } catch (e) {
      setState(() {
        categories = [];
        isLoadingCategories = false;
      });
    }
  }

  void _onSearchPressed() {
    widget.onFilterChanged(widget.filter);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Buscar',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (val) => widget.filter.query = val,
        ),
        const SizedBox(height: 16),
        isLoadingCategories
            ? const Center(child: CircularProgressIndicator())
            : DropdownButtonFormField<String>(
                value: categories.any((c) => c.slug == widget.filter.category)
                    ? widget.filter.category
                    : '',
                isExpanded: true,
                items: [
                  const DropdownMenuItem(value: '', child: Text('Todas las categorías')),
                  ...categories.map((c) => DropdownMenuItem(value: c.slug, child: Text(c.name))),
                ],
                onChanged: (val) => widget.filter.category = val?.isEmpty ?? true ? null : val,
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: widget.filter.includeOutOfStock,
              onChanged: (val) => setState(() => widget.filter.includeOutOfStock = val ?? false),
            ),
            const Text('Incluir productos fuera de stock'),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _onSearchPressed, child: const Text('Buscar')),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
