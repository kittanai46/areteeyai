import '../models/cart_item.dart';
import '../models/order.dart';
import 'package:uuid/uuid.dart';

class OrderService {
  final _uuid = const Uuid();

  Future<Order> placeOrder({
    required List<CartItem> items,
    required String deliveryAddress,
    String? note,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final subtotal = items.fold<double>(0, (sum, i) => sum + i.subtotal);
    const deliveryFee = 30.0;

    return Order(
      id: _uuid.v4(),
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: subtotal + deliveryFee,
      status: OrderStatus.confirmed,
      deliveryAddress: deliveryAddress,
      createdAt: DateTime.now(),
      note: note,
    );
  }

  Future<List<Order>> getOrderHistory() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Mock history — replace with real API
    return [];
  }
}
