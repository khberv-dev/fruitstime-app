import 'package:fruitstime/core/data/network/config.dart';
import 'package:fruitstime/features/banner/domain/entity/banner_entity.dart';

class BannerDto {
  final String title;
  final String content;
  final String image;

  BannerDto({required this.title, required this.content, required this.image});

  factory BannerDto.parse(Map<String, dynamic> data) =>
      BannerDto(title: data['title'], content: data['content'], image: data['image']);

  BannerEntity toEntity() =>
      BannerEntity(title: title, content: content, imageUrl: '$baseCdnUrl/banner/$image');
}
