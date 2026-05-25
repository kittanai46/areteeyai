import 'package:flutter/foundation.dart';
import '../../../core/models/coupon.dart';

class CouponViewModel extends ChangeNotifier {
  final List<Coupon> _coupons = _mockCoupons();

  List<Coupon> get available {
    final list = _coupons
        .where((c) =>
            !c.isExpired &&
            (c.status == CouponStatus.available ||
                c.status == CouponStatus.collected))
        .toList();
    // available coupons first, collected ones at the end
    list.sort((a, b) {
      final aOrder = a.status == CouponStatus.collected ? 1 : 0;
      final bOrder = b.status == CouponStatus.collected ? 1 : 0;
      return aOrder.compareTo(bOrder);
    });
    return list;
  }

  List<Coupon> get collected =>
      _coupons.where((c) => c.status == CouponStatus.collected).toList();

  List<Coupon> get used =>
      _coupons.where((c) => c.status == CouponStatus.used).toList();

  int get collectedCount => collected.length;

  void collect(String couponId) {
    final i = _coupons.indexWhere((c) => c.id == couponId);
    if (i < 0) return;
    _coupons[i] = _coupons[i].copyWith(status: CouponStatus.collected);
    notifyListeners();
  }
}

List<Coupon> _mockCoupons() {
  final now = DateTime.now();
  return [
    Coupon(
      id: 'cp1',
      code: 'FREESHIP',
      title: 'ส่งฟรีทุกออเดอร์',
      description: 'รับส่วนลดค่าจัดส่งเต็มจำนวน สำหรับออเดอร์ขั้นต่ำ ฿150',
      type: CouponType.fixed,
      discountValue: 30,
      minOrderAmount: 150,
      expiryDate: now.add(const Duration(days: 7)),
      category: 'all',
    ),
    Coupon(
      id: 'cp2',
      code: 'FOOD15',
      title: 'ลด 15% อาหาร',
      description: 'ส่วนลด 15% สำหรับหมวดหมู่อาหาร สูงสุด ฿50',
      type: CouponType.percentage,
      discountValue: 15,
      minOrderAmount: 200,
      maxDiscount: 50,
      expiryDate: now.add(const Duration(days: 3)),
      category: 'food',
    ),
    Coupon(
      id: 'cp3',
      code: 'FRESH20',
      title: 'ลด 20% อาหารสด',
      description: 'ส่วนลด 20% สำหรับหมวดอาหารสด ไม่จำกัดจำนวน',
      type: CouponType.percentage,
      discountValue: 20,
      minOrderAmount: 100,
      expiryDate: now.add(const Duration(days: 14)),
      category: 'freshFood',
    ),
    Coupon(
      id: 'cp4',
      code: 'NEW50',
      title: 'ลด ฿50 สมาชิกใหม่',
      description: 'รับส่วนลด ฿50 สำหรับการสั่งซื้อครั้งแรก',
      type: CouponType.fixed,
      discountValue: 50,
      minOrderAmount: 250,
      expiryDate: now.add(const Duration(days: 30)),
      category: 'all',
    ),
    Coupon(
      id: 'cp5',
      code: 'WEEKEND30',
      title: 'Weekend Special ลด 30%',
      description: 'ส่วนลด 30% เฉพาะวันเสาร์-อาทิตย์ สูงสุด ฿80',
      type: CouponType.percentage,
      discountValue: 30,
      minOrderAmount: 300,
      maxDiscount: 80,
      expiryDate: now.add(const Duration(days: 5)),
      category: 'all',
    ),
    Coupon(
      id: 'cp6',
      code: 'DELIVERY10',
      title: 'ลด ฿10 ค่าส่ง',
      description: 'รับส่วนลดค่าจัดส่ง ฿10 สำหรับทุกออเดอร์',
      type: CouponType.fixed,
      discountValue: 10,
      minOrderAmount: 0,
      expiryDate: now.add(const Duration(days: 1)),
      category: 'delivery',
    ),
  ];
}
