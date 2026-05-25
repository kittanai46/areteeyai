import 'package:equatable/equatable.dart';
import 'category.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final CategoryType categoryType;
  final String restaurantId;
  final String restaurantName;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final List<String> tags;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryType,
    this.restaurantId = '',
    this.restaurantName = '',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isAvailable = true,
    this.tags = const [],
  });

  @override
  List<Object?> get props => [id];
}
