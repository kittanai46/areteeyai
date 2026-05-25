import '../models/category.dart';
import '../models/product.dart';

class ProductService {
  // Mock data — replace with real API calls
  List<Category> getCategories() {
    return const [
      Category(
        id: 'cat_food',
        name: 'อาหาร',
        iconPath: '🍔',
        type: CategoryType.food,
        description: 'อาหารอร่อยส่งถึงบ้าน',
      ),
      Category(
        id: 'cat_delivery',
        name: 'บริการรับส่ง',
        iconPath: '🛵',
        type: CategoryType.delivery,
        description: 'รับส่งพัสดุ เร็ว ปลอดภัย',
      ),
      Category(
        id: 'cat_fresh',
        name: 'อาหารสด',
        iconPath: '🥦',
        type: CategoryType.freshFood,
        description: 'วัตถุดิบสด คัดสรรทุกวัน',
      ),
      Category(
        id: 'cat_coupons',
        name: 'คูปอง',
        iconPath: '🎟️',
        type: CategoryType.coupons,
        description: 'รวมคูปองส่วนลดสุดคุ้ม',
      ),
    ];
  }

  Future<List<Product>> getPopularProducts() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      const Product(
        id: 'p001',
        name: 'ข้าวผัดกุ้ง',
        description: 'ข้าวผัดกุ้งสูตรเด็ด หอมกลิ่นน้ำมันหอยและกุ้งสด',
        price: 85,
        imageUrl: 'https://picsum.photos/seed/food1/400/300',
        categoryType: CategoryType.food,
        restaurantName: 'ร้านอาหารตำรับไทย',
        rating: 4.8,
        reviewCount: 320,
        tags: ['ข้าว', 'กุ้ง', 'ยอดนิยม'],
      ),
      const Product(
        id: 'p002',
        name: 'ต้มยำกุ้ง',
        description: 'ต้มยำกุ้งน้ำข้น รสชาติเข้มข้น เผ็ดอร่อย',
        price: 120,
        imageUrl: 'https://picsum.photos/seed/food2/400/300',
        categoryType: CategoryType.food,
        restaurantName: 'ร้านอาหารตำรับไทย',
        rating: 4.9,
        reviewCount: 512,
        tags: ['ต้มยำ', 'กุ้ง', 'เผ็ด'],
      ),
      const Product(
        id: 'p003',
        name: 'ผักโขมสด',
        description: 'ผักโขมสด ออร์แกนิค จากไร่โดยตรง',
        price: 35,
        imageUrl: 'https://picsum.photos/seed/fresh1/400/300',
        categoryType: CategoryType.freshFood,
        restaurantName: 'ไร่ผักสด',
        rating: 4.7,
        reviewCount: 180,
        tags: ['ผัก', 'ออร์แกนิค', 'สด'],
      ),
      const Product(
        id: 'p004',
        name: 'มะม่วงน้ำดอกไม้',
        description: 'มะม่วงน้ำดอกไม้สุก หวานหอม คัดเกรด A',
        price: 60,
        imageUrl: 'https://picsum.photos/seed/fresh2/400/300',
        categoryType: CategoryType.freshFood,
        restaurantName: 'สวนผลไม้',
        rating: 4.6,
        reviewCount: 95,
        tags: ['ผลไม้', 'มะม่วง', 'สด'],
      ),
    ];
  }

  Future<List<Product>> getProductsByCategory(CategoryType type) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final all = await getPopularProducts();
    return all.where((p) => p.categoryType == type).toList();
  }
}
