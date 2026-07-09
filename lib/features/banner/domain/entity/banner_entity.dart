class BannerEntity {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String? thumbnailUrl;
  final bool popup;

  BannerEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    this.thumbnailUrl,
    this.popup = false,
  });
}
