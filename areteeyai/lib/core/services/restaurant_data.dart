import '../models/restaurant.dart';
import '../models/product.dart';
import '../models/category.dart';

/// Static mock data for restaurants.
class RestaurantData {
  RestaurantData._();

  static final List<Restaurant> all = [
    Restaurant(
      id: 'r1',
      name: 'ครัวคุณแม่',
      coverImageUrl:
          'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=600',
      rating: 4.8,
      reviewCount: 320,
      deliveryTime: '20–35 นาที',
      deliveryFee: 15,
      tags: ['อาหารไทย', 'ข้าวแกง'],
      isNearby: true,
      distanceKm: 0.8,
      menu: [
        Product(
          id: 'r1_p1',
          name: 'ข้าวผัดกระเพราหมูสับ',
          description: 'ข้าวผัดกระเพราพร้อมไข่ดาว',
          price: 65,
          imageUrl:
              'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r1',
          restaurantName: 'ครัวคุณแม่',
          rating: 4.9,
          reviewCount: 120,
        ),
        Product(
          id: 'r1_p2',
          name: 'ต้มยำกุ้งน้ำข้น',
          description: 'ต้มยำกุ้งสดรสจัดจ้าน',
          price: 120,
          imageUrl:
              'https://images.unsplash.com/photo-1559847844-5315695dadae?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r1',
          restaurantName: 'ครัวคุณแม่',
          rating: 4.7,
          reviewCount: 98,
        ),
        Product(
          id: 'r1_p3',
          name: 'ส้มตำไทย',
          description: 'ส้มตำสูตรต้นตำรับ',
          price: 55,
          imageUrl:
              'https://images.unsplash.com/photo-1562802378-063ec186a863?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r1',
          restaurantName: 'ครัวคุณแม่',
          rating: 4.8,
          reviewCount: 74,
        ),
        Product(
          id: 'r1_d1',
          name: 'น้ำมะพร้าวสด',
          description: 'มะพร้าวอ่อนสดเย็นชื่นใจ',
          price: 40,
          imageUrl:
              'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r1',
          restaurantName: 'ครัวคุณแม่',
          rating: 4.6,
          reviewCount: 55,
        ),
      ],
    ),
    Restaurant(
      id: 'r2',
      name: 'บะหมี่เจ้าดัง',
      coverImageUrl:
          'https://images.unsplash.com/photo-1555126634-323283e090fa?w=600',
      rating: 4.6,
      reviewCount: 215,
      deliveryTime: '25–40 นาที',
      deliveryFee: 20,
      tags: ['บะหมี่', 'ก๋วยเตี๋ยว'],
      isNearby: true,
      distanceKm: 1.2,
      menu: [
        Product(
          id: 'r2_p1',
          name: 'บะหมี่หมูแดงน้ำ',
          description: 'บะหมี่สดหมูแดงน้ำซุปกระดูก',
          price: 75,
          imageUrl:
              'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r2',
          restaurantName: 'บะหมี่เจ้าดัง',
          rating: 4.7,
          reviewCount: 88,
        ),
        Product(
          id: 'r2_p2',
          name: 'ก๋วยเตี๋ยวเนื้อตุ๋น',
          description: 'เนื้อตุ๋นนุ่มน้ำซุปเข้มข้น',
          price: 90,
          imageUrl:
              'https://images.unsplash.com/photo-1547592180-85f173990554?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r2',
          restaurantName: 'บะหมี่เจ้าดัง',
          rating: 4.5,
          reviewCount: 61,
        ),
        Product(
          id: 'r2_d1',
          name: 'น้ำส้มคั้น',
          description: 'น้ำส้มคั้นสดใหม่',
          price: 35,
          imageUrl:
              'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r2',
          restaurantName: 'บะหมี่เจ้าดัง',
          rating: 4.4,
          reviewCount: 33,
        ),
      ],
    ),
    Restaurant(
      id: 'r3',
      name: 'ซูชิ Hana',
      coverImageUrl:
          'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=600',
      rating: 4.9,
      reviewCount: 512,
      deliveryTime: '30–45 นาที',
      deliveryFee: 30,
      tags: ['ญี่ปุ่น', 'ซูชิ', 'ซาชิมิ'],
      isNearby: false,
      distanceKm: 3.5,
      menu: [
        Product(
          id: 'r3_p1',
          name: 'ซูชิรวม 12 ชิ้น',
          description: 'ซูชิหน้าปลาแซลมอน ทูน่า และกุ้ง',
          price: 280,
          imageUrl:
              'https://images.unsplash.com/photo-1563612116625-3012372fccce?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r3',
          restaurantName: 'ซูชิ Hana',
          rating: 4.9,
          reviewCount: 200,
        ),
        Product(
          id: 'r3_p2',
          name: 'ซาชิมิแซลมอน',
          description: 'แซลมอนสดหั่นหนา 8 ชิ้น',
          price: 220,
          imageUrl:
              'https://images.unsplash.com/photo-1580822184713-fc5400e7fe10?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r3',
          restaurantName: 'ซูชิ Hana',
          rating: 4.8,
          reviewCount: 145,
        ),
        Product(
          id: 'r3_d1',
          name: 'มัทฉะลาเต้',
          description: 'ชาเขียวมัทฉะผสมนมสด',
          price: 95,
          imageUrl:
              'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r3',
          restaurantName: 'ซูชิ Hana',
          rating: 4.7,
          reviewCount: 89,
        ),
      ],
    ),
    Restaurant(
      id: 'r4',
      name: 'พิซซ่า The Corner',
      coverImageUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600',
      rating: 4.5,
      reviewCount: 178,
      deliveryTime: '35–50 นาที',
      deliveryFee: 25,
      tags: ['พิซซ่า', 'อิตาเลี่ยน'],
      isNearby: false,
      distanceKm: 2.1,
      menu: [
        Product(
          id: 'r4_p1',
          name: 'พิซซ่ามาร์เกอริต้า',
          description: 'ซอสมะเขือเทศ โมซซาเรลลา สะเดาสด',
          price: 199,
          imageUrl:
              'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r4',
          restaurantName: 'พิซซ่า The Corner',
          rating: 4.6,
          reviewCount: 77,
        ),
        Product(
          id: 'r4_p2',
          name: 'พิซซ่า BBQ ไก่',
          description: 'ไก่ย่าง BBQ หอมควัน ชีสเยิ้ม',
          price: 229,
          imageUrl:
              'https://images.unsplash.com/photo-1528137871618-79d2761e3fd5?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r4',
          restaurantName: 'พิซซ่า The Corner',
          rating: 4.5,
          reviewCount: 55,
        ),
        Product(
          id: 'r4_d1',
          name: 'โคล่าเย็น',
          description: 'โคล่าเย็นจัด 500ml',
          price: 35,
          imageUrl:
              'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r4',
          restaurantName: 'พิซซ่า The Corner',
          rating: 4.0,
          reviewCount: 20,
        ),
      ],
    ),
    Restaurant(
      id: 'r5',
      name: 'คาเฟ่ Morning Dew',
      coverImageUrl:
          'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=600',
      rating: 4.7,
      reviewCount: 390,
      deliveryTime: '15–25 นาที',
      deliveryFee: 0,
      tags: ['คาเฟ่', 'กาแฟ', 'เค้ก'],
      isNearby: true,
      distanceKm: 0.5,
      menu: [
        Product(
          id: 'r5_d1',
          name: 'ลาเต้เย็น',
          description: 'เอสเพรสโซเข้มข้น + นมสดเย็น',
          price: 85,
          imageUrl:
              'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r5',
          restaurantName: 'คาเฟ่ Morning Dew',
          rating: 4.8,
          reviewCount: 150,
        ),
        Product(
          id: 'r5_d2',
          name: 'ช็อกโกแลตร้อน',
          description: 'ช็อกโกแลตเข้มข้นอุ่นๆ',
          price: 90,
          imageUrl:
              'https://images.unsplash.com/photo-1542990253-0d0f5be5f0ed?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r5',
          restaurantName: 'คาเฟ่ Morning Dew',
          rating: 4.7,
          reviewCount: 95,
        ),
        Product(
          id: 'r5_p1',
          name: 'ครัวซองต์เนยสด',
          description: 'ครัวซองต์อบใหม่เนยหอม',
          price: 65,
          imageUrl:
              'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r5',
          restaurantName: 'คาเฟ่ Morning Dew',
          rating: 4.6,
          reviewCount: 72,
        ),
        Product(
          id: 'r5_p2',
          name: 'เค้กช็อกโกแลต',
          description: 'เค้กช็อกโกแลตชุ่มฉ่ำ',
          price: 110,
          imageUrl:
              'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
          categoryType: CategoryType.food,
          restaurantId: 'r5',
          restaurantName: 'คาเฟ่ Morning Dew',
          rating: 4.9,
          reviewCount: 110,
        ),
      ],
    ),
  ];

  static Restaurant? findById(String id) {
    try {
      return all.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<Restaurant> get recommended =>
      all.where((r) => r.rating >= 4.7).toList();

  static List<Restaurant> get nearby =>
      all.where((r) => r.isNearby).toList();
}
