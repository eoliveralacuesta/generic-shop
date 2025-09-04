class Category {
  final String name;
  final String slug;
  final int id;

  Category({
    required this.name,
    required this.slug,
    required this.id
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      id: json['id'] is int 
        ? json['id'] 
        : int.tryParse(json['id'].toString()) ?? 0
    );
  }
}
