import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/cart_item.dart';
import '../../../core/models/coupon.dart';
import '../../../l10n/app_localizations.dart';
import '../view_models/cart_view_model.dart';
import '../../coupons/view_models/coupon_view_model.dart';
import '../../orders/view_models/order_view_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Coupon? _selectedCoupon;

  double _calcDiscount(double subtotal) {
    final c = _selectedCoupon;
    if (c == null || subtotal < c.minOrderAmount) return 0;
    if (c.type == CouponType.percentage) {
      final d = subtotal * c.discountValue / 100;
      return c.maxDiscount != null ? d.clamp(0, c.maxDiscount!) : d;
    }
    return c.discountValue;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.cartTitle),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
      ),
      body: Consumer<CartViewModel>(
        builder: (_, vm, __) {
          if (vm.isEmpty) return _buildEmptyCart(context, l10n);
          final discount = _calcDiscount(vm.subtotal);
          final grandTotal =
              (vm.subtotal + vm.deliveryFee - discount).clamp(0, double.infinity).toDouble();
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ...vm.items.map((item) => _CartItemCard(item: item, vm: vm)),
                      const SizedBox(height: 12),
                      _buildCouponSection(context, vm),
                    ],
                  ),
                ),
              ),
              _buildSummary(context, l10n, vm, discount, grandTotal),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text(l10n.cartEmpty,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(l10n.cartEmptySubtitle, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(l10n.backToHome),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection(BuildContext context, CartViewModel vm) {
    final belowMin =
        _selectedCoupon != null && vm.subtotal < _selectedCoupon!.minOrderAmount;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.local_offer_outlined, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _selectedCoupon != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_selectedCoupon!.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(
                        belowMin
                            ? 'ต้องสั่งขั้นต่ำ ฿${_selectedCoupon!.minOrderAmount.toInt()}'
                            : 'ลด ${_selectedCoupon!.discountLabel}',
                        style: TextStyle(
                          fontSize: 12,
                          color: belowMin ? AppColors.error : AppColors.success,
                        ),
                      ),
                    ],
                  )
                : const Text('เลือกคูปองส่วนลด',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ),
          _selectedCoupon != null
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                  onPressed: () => setState(() => _selectedCoupon = null),
                )
              : TextButton(
                  onPressed: () => _showCouponPicker(context, vm),
                  child: const Text('เลือก',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
        ],
      ),
    );
  }

  void _showCouponPicker(BuildContext context, CartViewModel vm) {
    final collected = context.read<CouponViewModel>().collected;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: AppColors.textHint.withAlpha(80),
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              const Text('เลือกคูปอง',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              if (collected.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Icon(Icons.local_offer_outlined, size: 48, color: AppColors.textHint),
                      SizedBox(height: 8),
                      Text('ยังไม่มีคูปองที่เก็บไว้',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: collected.length,
                    itemBuilder: (_, idx) {
                      final c = collected[idx];
                      final canUse = vm.subtotal >= c.minOrderAmount;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(26),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(c.discountLabel,
                              style: const TextStyle(
                                  color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(c.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: canUse ? AppColors.textPrimary : AppColors.textHint)),
                        subtitle: Text(
                          canUse
                              ? 'ขั้นต่ำ ฿${c.minOrderAmount.toInt()}'
                              : 'ต้องสั่งขั้นต่ำ ฿${c.minOrderAmount.toInt()}',
                          style: TextStyle(
                              color: canUse ? AppColors.textSecondary : AppColors.error,
                              fontSize: 12),
                        ),
                        trailing: canUse
                            ? ElevatedButton(
                                onPressed: () {
                                  setState(() => _selectedCoupon = c);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('เลือก', style: TextStyle(fontSize: 13)),
                              )
                            : const Text('ไม่ผ่านเงื่อนไข',
                                style: TextStyle(color: AppColors.textHint, fontSize: 12)),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, AppLocalizations l10n,
      CartViewModel vm, double discount, double grandTotal) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: const Offset(0, -4))],
      ),
      child: Column(
        children: [
          _row(l10n.subtotal, '฿${vm.subtotal.toStringAsFixed(0)}'),
          if (_selectedCoupon != null && discount > 0) ...[
            const SizedBox(height: 6),
            _row('ส่วนลด (${_selectedCoupon!.code})', '-฿${discount.toStringAsFixed(0)}',
                valueColor: AppColors.success),
          ],
          const SizedBox(height: 6),
          _row(l10n.deliveryFee,
              vm.deliveryFee == 0 ? l10n.free : '฿${vm.deliveryFee.toStringAsFixed(0)}'),
          const Divider(height: 16),
          _row(l10n.total, '฿${grandTotal.toStringAsFixed(0)}', bold: true),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: vm.isCheckingOut
                  ? null
                  : () => _showCheckoutSheet(context, l10n, vm, discount, grandTotal),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: vm.isCheckingOut
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(l10n.checkout, style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false, Color? valueColor}) {
    final style = bold
        ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        : const TextStyle(color: AppColors.textSecondary);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value,
            style: style.copyWith(color: valueColor ?? (bold ? AppColors.primary : null))),
      ],
    );
  }

  void _showCheckoutSheet(BuildContext context, AppLocalizations l10n,
      CartViewModel vm, double discount, double grandTotal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 16,
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: AppColors.textHint.withAlpha(80),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('สรุปคำสั่งซื้อ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            // Item list
            ...vm.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('${item.product.name} x${item.quantity}',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            overflow: TextOverflow.ellipsis),
                      ),
                      Text('฿${(item.product.price * item.quantity).toStringAsFixed(0)}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                    ],
                  ),
                )),
            const Divider(height: 20),
            // Subtotal
            _sheetRow('ยอดรวมสินค้า', '฿${vm.subtotal.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            // Coupon
            if (_selectedCoupon != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_offer, size: 14, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text('คูปอง ${_selectedCoupon!.code}',
                          style: const TextStyle(color: AppColors.success, fontSize: 14)),
                    ],
                  ),
                  Text(
                    discount > 0 ? '-฿${discount.toStringAsFixed(0)}' : 'ไม่ผ่านขั้นต่ำ',
                    style: TextStyle(
                        color: discount > 0 ? AppColors.success : AppColors.error,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            // Delivery fee
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ค่าจัดส่ง',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                Text(
                  vm.deliveryFee == 0 ? l10n.free : '฿${vm.deliveryFee.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: vm.deliveryFee == 0 ? AppColors.success : AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: vm.deliveryFee == 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // Grand total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ยอดรวมทั้งหมด',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('฿${grandTotal.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(sheetCtx);
                  final success = await vm.checkout('บ้านเลขที่ 123 กรุงเทพฯ');
                  if (context.mounted) {
                    if (success && vm.lastOrder != null) {
                      context.read<OrderViewModel>().addOrder(vm.lastOrder!);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success
                            ? l10n.checkoutSuccess
                            : (vm.errorMessage ?? 'เกิดข้อผิดพลาด')),
                        backgroundColor: success ? AppColors.success : AppColors.error,
                      ),
                    );
                    if (success) context.go('/orders');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(l10n.confirm,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        Text(value, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
      ],
    );
  }
}

// ─── Cart item card ────────────────────────────────────────────────────────────

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final CartViewModel vm;

  const _CartItemCard({required this.item, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.product.imageUrl,
              width: 60, height: 60, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 60, height: 60,
                color: AppColors.surfaceVariant,
                child: const Icon(Icons.fastfood, color: AppColors.textHint),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('฿${item.product.price.toStringAsFixed(0)} / ชิ้น',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Row(
            children: [
              _QtyBtn(icon: Icons.remove, onTap: () => vm.decrementItem(item.product.id)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('${item.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              _QtyBtn(icon: Icons.add, onTap: () => vm.addItem(item.product), color: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _QtyBtn({required this.icon, required this.onTap, this.color = AppColors.textSecondary});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
