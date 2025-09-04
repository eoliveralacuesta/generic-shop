class ProductFilter {
  String query;
  bool includeOutOfStock;
  String? category; // opcional por ahora
  int limit;
  int offset;

  ProductFilter({
    this.query = '',
    this.includeOutOfStock = false,
    this.category,
    this.limit = 4,
    this.offset = 0,
  });

  factory ProductFilter.fromParams(Map<String, dynamic>? params) {
    if (params != null && params.isNotEmpty) {
      int currentPage = int.tryParse(params['page'] ?? '1') ?? 1;
      
      return ProductFilter(
        query: params['q'] ?? '',
        includeOutOfStock: params['oos'] == 'true',
        category: params['category'] ?? '',
        offset: (currentPage - 1) * 4,
        limit: 4
      );
    }
    
    return ProductFilter();
  }
}
