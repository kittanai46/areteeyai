import 'package:flutter/foundation.dart';
import '../../../core/models/product.dart';
import '../../../core/models/category.dart';
import '../../../core/services/product_service.dart';

class FreshFoodViewModel extends ChangeNotifier {
  final ProductService _productService;

  FreshFoodViewModel({ProductService? productService})
      : _productService = productService ?? ProductService();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedSubCategory = 'ทั้งหมด';

  final List<String> subCategories = [
    'ทั้งหมด',
    'ผักสด',
    'ผลไม้',
    'เนื้อสัตว์',
    'อาหารทะเล',
  ];

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedSubCategory => _selectedSubCategory;

  List<Product> get filteredProducts {
    if (_selectedSubCategory == 'ทั้งหมด') return _products;
    return _products
        .where((p) => p.tags.contains(_selectedSubCategory))
        .toList();
  }

  Future<void> loadFreshFood() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products =
          await _productService.getProductsByCategory(CategoryType.freshFood);
    } catch (e) {
      _errorMessage = 'โหลดข้อมูลอาหารสดไม่สำเร็จ';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectSubCategory(String category) {
    _selectedSubCategory = category;
    notifyListeners();
  }
}
