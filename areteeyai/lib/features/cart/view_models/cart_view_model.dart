import 'package:flutter/foundation.dart';
import '../../../core/models/cart_item.dart';
import '../../../core/models/product.dart';
import '../../../core/models/order.dart';
import '../../../core/services/order_service.dart';

class CartViewModel extends ChangeNotifier {
  final OrderService _orderService;

  CartViewModel({OrderService? orderService})
      : _orderService = orderService ?? OrderService();

  final List<CartItem> _items = [];
  bool _isCheckingOut = false;
  Order? _lastOrder;
  String? _errorMessage;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isCheckingOut => _isCheckingOut;
  Order? get lastOrder => _lastOrder;
  String? get errorMessage => _errorMessage;

  int get totalItems => _items.fold(0, (sum, i) => sum + i.quantity);
  double get subtotal => _items.fold(0.0, (sum, i) => sum + i.subtotal);
  double get deliveryFee => _items.isEmpty ? 0.0 : 30.0;
  double get total => subtotal + deliveryFee;
  bool get isEmpty => _items.isEmpty;

  void addItem(Product product) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  void decrementItem(String productId) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index < 0) return;
    if (_items[index].quantity <= 1) {
      _items.removeAt(index);
    } else {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity - 1);
    }
    notifyListeners();
  }

  void updateNote(String productId, String note) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index < 0) return;
    _items[index] = _items[index].copyWith(note: note);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  Future<bool> checkout(String deliveryAddress) async {
    if (_items.isEmpty) return false;

    _isCheckingOut = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lastOrder = await _orderService.placeOrder(
        items: List.from(_items),
        deliveryAddress: deliveryAddress,
      );
      clearCart();
      return true;
    } catch (e) {
      _errorMessage = 'สั่งซื้อไม่สำเร็จ กรุณาลองใหม่';
      return false;
    } finally {
      _isCheckingOut = false;
      notifyListeners();
    }
  }
}
