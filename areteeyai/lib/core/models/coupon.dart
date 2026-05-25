import 'package:equatable/equatable.dart';

enum CouponType { percentage, fixed }

enum CouponStatus { available, collected, used, expired }

class Coupon extends Equatable {
  final String id;
  final String code;
  final String title;
  final String description;
  final CouponType type;
  final double discountValue;
  final double minOrderAmount;
  final double? maxDiscount;
  final DateTime expiryDate;
  final CouponStatus status;
  final String category; // 'food', 'delivery', 'freshFood', 'all'

  const Coupon({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.type,
    required this.discountValue,
    required this.minOrderAmount,
    this.maxDiscount,
    required this.expiryDate,
    this.status = CouponStatus.available,
    this.category = 'all',
  });

  bool get isExpired => expiryDate.isBefore(DateTime.now());

  String get discountLabel {
    if (type == CouponType.percentage) {
      return '${discountValue.toInt()}%';
    }
    return '฿${discountValue.toInt()}';
  }

  Coupon copyWith({CouponStatus? status}) {
    return Coupon(
      id: id,
      code: code,
      title: title,
      description: description,
      type: type,
      discountValue: discountValue,
      minOrderAmount: minOrderAmount,
      maxDiscount: maxDiscount,
      expiryDate: expiryDate,
      status: status ?? this.status,
      category: category,
    );
  }

  @override
  List<Object?> get props => [id];
}
