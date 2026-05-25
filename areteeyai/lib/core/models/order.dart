import 'package:equatable/equatable.dart';
import 'cart_item.dart';

enum OrderStatus { pending, confirmed, preparing, onWay, delivered, cancelled }

class Order extends Equatable {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final OrderStatus status;
  final String deliveryAddress;
  final DateTime createdAt;
  final String? note;

  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.deliveryAddress,
    required this.createdAt,
    this.note,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'รอยืนยัน';
      case OrderStatus.confirmed:
        return 'ยืนยันแล้ว';
      case OrderStatus.preparing:
        return 'กำลังเตรียม';
      case OrderStatus.onWay:
        return 'กำลังจัดส่ง';
      case OrderStatus.delivered:
        return 'จัดส่งสำเร็จ';
      case OrderStatus.cancelled:
        return 'ยกเลิกแล้ว';
    }
  }

  @override
  List<Object?> get props => [id];
}
