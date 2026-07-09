import 'package:fruitstime/core/data/network/config.dart';
import 'package:fruitstime/features/banner/domain/entity/banner_entity.dart';

class BannerDto {
  final String id;
  final String title;
  final String content;
  final String image;
  final String? thumbnail;
  final bool popup;

  BannerDto({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    this.thumbnail,
    this.popup = false,
  });

  factory BannerDto.parse(Map<String, dynamic> data) => BannerDto(
    id: data['id'],
    title: data['title'],
    content: data['content'],
    image: data['image'],
    thumbnail: data['thumbnail'],
    popup: data['popup'] ?? false,
  );

  BannerEntity toEntity() => BannerEntity(
    id: id,
    title: title,
    content: content,
    imageUrl: '$baseCdnUrl/banner/$image',
    thumbnailUrl: thumbnail != null ? '$baseCdnUrl/banner/$thumbnail' : null,
    popup: popup,
  );
}
