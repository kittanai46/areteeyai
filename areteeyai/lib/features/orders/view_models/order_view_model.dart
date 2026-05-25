import 'package:flutter/foundation.dart';
import '../../../core/models/order.dart';
import '../../../core/services/order_service.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderService _orderService;

  OrderViewModel({OrderService? orderService})
      : _orderService = orderService ?? OrderService();

  final List<Order> _sessionOrders = [];
  List<Order> _serverOrders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Order> get orders => [..._sessionOrders, ..._serverOrders];
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _sessionOrders.isEmpty && _serverOrders.isEmpty;

  Future<void> loadOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _serverOrders = await _orderService.getOrderHistory();
    } catch (e) {
      _errorMessage = 'โหลดประวัติการสั่งซื้อไม่สำเร็จ';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addOrder(Order order) {
    _sessionOrders.insert(0, order);
    notifyListeners();
  }
}
