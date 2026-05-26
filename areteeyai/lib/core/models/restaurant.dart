import 'package:equatable/equatable.dart';
import 'product.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String coverImageUrl;
  final double rating;
  final int reviewCount;
  final String deliveryTime; // e.g. "20–35 นาที"
  final int deliveryFee; // บาท
  final List<String> tags;
  final bool isNearby;
  final double distanceKm;
  final List<Product> menu;

  const Restaurant({
    required this.id,
    required this.name,
    required this.coverImageUrl,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.tags,
    required this.isNearby,
    required this.distanceKm,
    required this.menu,
  });

  @override
  List<Object?> get props => [id];
}
