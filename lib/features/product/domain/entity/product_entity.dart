class ProductEntity {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> compound;
  final int price;

  ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.compound,
    required this.price,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
