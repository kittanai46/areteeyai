import 'package:equatable/equatable.dart';

enum CategoryType { food, delivery, freshFood, coupons }

class Category extends Equatable {
  final String id;
  final String name;
  final String iconPath;
  final CategoryType type;
  final String description;

  const Category({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.type,
    this.description = '',
  });

  @override
  List<Object?> get props => [id, name, type];
}
