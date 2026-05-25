import 'package:flutter/foundation.dart' hide Category;
import '../../../core/models/category.dart';
import '../../../core/models/product.dart';
import '../../../core/services/product_service.dart';

class HomeViewModel extends ChangeNotifier {
  final ProductService _productService;

  HomeViewModel({ProductService? productService})
      : _productService = productService ?? ProductService();

  List<Category> _categories = [];
  List<Product> _popularProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Category> get categories => _categories;
  List<Product> get popularProducts => _popularProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadHome() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = _productService.getCategories();
      _popularProducts = await _productService.getPopularProducts();
    } catch (e) {
      _errorMessage = 'โหลดข้อมูลไม่สำเร็จ กรุณาลองใหม่';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
