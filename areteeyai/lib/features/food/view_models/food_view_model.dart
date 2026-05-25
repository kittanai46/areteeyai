import 'package:flutter/foundation.dart';
import '../../../core/models/product.dart';
import '../../../core/models/category.dart';
import '../../../core/services/product_service.dart';

class FoodViewModel extends ChangeNotifier {
  final ProductService _productService;

  FoodViewModel({ProductService? productService})
      : _productService = productService ?? ProductService();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<Product> get filteredProducts {
    if (_searchQuery.isEmpty) return _products;
    return _products
        .where((p) =>
            p.name.contains(_searchQuery) ||
            p.restaurantName.contains(_searchQuery))
        .toList();
  }

  Future<void> loadFoodItems() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products =
          await _productService.getProductsByCategory(CategoryType.food);
    } catch (e) {
      _errorMessage = 'โหลดข้อมูลอาหารไม่สำเร็จ';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
