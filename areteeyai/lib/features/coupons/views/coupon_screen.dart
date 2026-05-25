import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/coupon.dart';
import '../view_models/coupon_view_model.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('คูปองของฉัน'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'คูปองที่มี'),
            Tab(text: 'คูปองของฉัน'),
          ],
        ),
      ),
      body: Consumer<CouponViewModel>(
        builder: (_, vm, __) => TabBarView(
          controller: _tabController,
          children: [
            _buildAvailableTab(vm),
            _buildCollectedTab(vm),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableTab(CouponViewModel vm) {
    if (vm.available.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_offer_outlined, size: 72, color: AppColors.textHint),
            SizedBox(height: 16),
            Text('ไม่มีคูปองในขณะนี้',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            SizedBox(height: 8),
            Text('กลับมาใหม่เร็วๆ นี้นะครับ',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vm.available.length,
      itemBuilder: (_, i) {
        final coupon = vm.available[i];
        final isCollected = coupon.status == CouponStatus.collected;
        return _CouponCard(
          coupon: coupon,
          isCollected: isCollected,
          onCollect: isCollected ? null : () => vm.collect(coupon.id),
        );
      },
    );
  }

  Widget _buildCollectedTab(CouponViewModel vm) {
    if (vm.collected.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.card_giftcard_outlined,
                size: 72, color: AppColors.textHint),
            SizedBox(height: 16),
            Text('ยังไม่มีคูปองที่เก็บไว้',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            SizedBox(height: 8),
            Text('กดเก็บคูปองจากแท็บ "คูปองที่มี" ได้เลยครับ',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vm.collected.length,
      itemBuilder: (_, i) => _CouponCard(
        coupon: vm.collected[i],
        isCollected: true,
      ),
    );
  }
}

// ─── Coupon Card ─────────────────────────────────────────────────────────────

class _CouponCard extends StatelessWidget {
  final Coupon coupon;
  final bool isCollected;
  final VoidCallback? onCollect;

  const _CouponCard({
    required this.coupon,
    this.isCollected = false,
    this.onCollect,
  });

  Color get _categoryColor {
    switch (coupon.category) {
      case 'food':
        return AppColors.foodCategory;
      case 'freshFood':
        return const Color(0xFF2ECC71);
      case 'delivery':
        return const Color(0xFF4361EE);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = coupon.expiryDate.difference(DateTime.now()).inDays;
    final isUrgent = daysLeft <= 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left accent strip + discount badge
              Container(
                width: 80,
                color: _categoryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      coupon.discountLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    if (coupon.type == CouponType.percentage)
                      const Text(
                        'OFF',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                      ),
                  ],
                ),
              ),
              // Dashed separator
              CustomPaint(
                painter: _DashedLinePainter(color: AppColors.divider),
                size: const Size(1, double.infinity),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              coupon.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.textPrimary),
                            ),
                          ),
                          // Code chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _categoryColor.withAlpha(26),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: _categoryColor.withAlpha(80)),
                            ),
                            child: Text(
                              coupon.code,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _categoryColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        coupon.description,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (coupon.minOrderAmount > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'ขั้นต่ำ ฿${coupon.minOrderAmount.toInt()}',
                            style: const TextStyle(
                                color: AppColors.textHint, fontSize: 11),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 13,
                                color: isUrgent
                                    ? AppColors.error
                                    : AppColors.textHint,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                daysLeft == 0
                                    ? 'หมดเขตวันนี้!'
                                    : 'เหลือ $daysLeft วัน',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isUrgent
                                      ? AppColors.error
                                      : AppColors.textHint,
                                  fontWeight: isUrgent
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          if (!isCollected)
                            SizedBox(
                              height: 32,
                              child: ElevatedButton(
                                onPressed: onCollect,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _categoryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  elevation: 0,
                                ),
                                child: const Text('เก็บ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.success.withAlpha(26),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      size: 14, color: AppColors.success),
                                  SizedBox(width: 4),
                                  Text('เก็บแล้ว',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.success,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Dashed separator painter ────────────────────────────────────────────────

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dashHeight = 5.0;
    const dashSpace = 4.0;
    final paint = Paint()..color = color..strokeWidth = 1;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
