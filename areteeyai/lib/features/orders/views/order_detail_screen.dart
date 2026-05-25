import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/order.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _riderCtrl;
  late final AnimationController _pulseCtrl;
  late final CurvedAnimation _riderCurve;
  late final Animation<double> _pulseAnim;

  // Rider position tracking per segment
  double _riderFrom = 0.0;
  double _riderTo = 0.0;
  int _displayStep = 0;
  Timer? _autoTimer;

  static const _stepIcons = [
    Icons.two_wheeler_rounded,
    Icons.storefront_rounded,
    Icons.delivery_dining,
    Icons.home_rounded,
  ];

  static const _stepLabels = [
    'กำลังไป',
    'ถึงร้าน\nรอของ',
    'กำลัง\nจัดส่ง',
    'จัดส่ง\nเรียบร้อย',
  ];

  int get _initialStep => switch (widget.order.status) {
        OrderStatus.pending || OrderStatus.confirmed => 0,
        OrderStatus.preparing => 1,
        OrderStatus.onWay => 2,
        OrderStatus.delivered => 3,
        OrderStatus.cancelled => -1,
      };

  bool get _isCancelled => widget.order.status == OrderStatus.cancelled;

  // Interpolated rider position (0.0 – 1.0 across full track)
  double get _riderPos =>
      _riderFrom + (_riderTo - _riderFrom) * _riderCurve.value;

  @override
  void initState() {
    super.initState();

    _displayStep = _isCancelled ? 0 : _initialStep;
    _riderFrom = 0.0;
    _riderTo = _displayStep / 3.0;

    _riderCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _riderCurve =
        CurvedAnimation(parent: _riderCtrl, curve: Curves.elasticOut);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Play initial animation then start auto-advance
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      _riderCtrl.forward().then((_) {
        if (!mounted || _isCancelled || _displayStep >= 3) return;
        _startAutoTimer();
      });
    });
  }

  void _startAutoTimer() {
    _autoTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) {
        _autoTimer?.cancel();
        return;
      }
      if (_displayStep >= 3) {
        _autoTimer?.cancel();
        return;
      }
      _advanceStep();
    });
  }

  void _advanceStep() {
    final from = _displayStep / 3.0;
    setState(() => _displayStep++);
    _riderFrom = from;
    _riderTo = _displayStep / 3.0;
    _riderCtrl
      ..duration = const Duration(milliseconds: 900)
      ..reset()
      ..forward();
    if (_displayStep >= 3) _autoTimer?.cancel();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _riderCtrl.dispose();
    _pulseCtrl.dispose();
    _riderCurve.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'คำสั่งซื้อ #${widget.order.id.substring(0, 8).toUpperCase()}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 16),
            if (!_isCancelled) ...[
              _buildTrackerCard(),
              const SizedBox(height: 16),
            ],
            if (_isCancelled) ...[
              _buildCancelledCard(),
              const SizedBox(height: 16),
            ],
            _buildItemsCard(),
            const SizedBox(height: 16),
            _buildPriceCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ─── Status header ───────────────────────────────────────────────────────────

  Widget _buildStatusCard() {
    Color statusColor;
    IconData statusIcon;

    if (_isCancelled) {
      statusColor = AppColors.error;
      statusIcon = Icons.cancel_outlined;
    } else if (widget.order.status == OrderStatus.delivered) {
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle_outline;
    } else {
      statusColor = AppColors.primary;
      statusIcon = Icons.delivery_dining;
    }

    final dt = widget.order.createdAt;
    final dateStr =
        '${dt.day}/${dt.month}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} น.';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: statusColor.withAlpha(26),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(statusIcon, color: statusColor, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.order.statusLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  dateStr,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Cancelled card ───────────────────────────────────────────────────────────

  Widget _buildCancelledCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha(13),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withAlpha(60)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.error),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'คำสั่งซื้อนี้ถูกยกเลิกแล้ว',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Delivery tracker ────────────────────────────────────────────────────────

  Widget _buildTrackerCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ติดตามการจัดส่ง',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 24),
          _buildTrackWidget(),
          const SizedBox(height: 14),
          _buildStepLabels(),
        ],
      ),
    );
  }

  Widget _buildTrackWidget() {
    const nodeR = 15.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        // Center X of each node
        final xs = List.generate(
            4, (i) => nodeR + (w - nodeR * 2) * (i / 3.0));

        return SizedBox(
          height: 90,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Gray background track ──────────────────────────────────────
              Positioned(
                left: nodeR,
                right: nodeR,
                top: 58,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ── Animated orange fill ───────────────────────────────────────
              AnimatedBuilder(
                animation: _riderCtrl,
                builder: (_, __) => Positioned(
                  left: nodeR,
                  top: 58,
                  child: Container(
                    height: 4,
                    width: (w - nodeR * 2) * _riderPos,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),

              // ── Step nodes ────────────────────────────────────────────────
              ...List.generate(4, (i) {
                final isDone = i < _displayStep;
                final isCurrent = i == _displayStep;
                return Positioned(
                  left: xs[i] - nodeR,
                  top: 58 - nodeR,
                  child: _buildNode(i, isDone, isCurrent, nodeR),
                );
              }),

              // ── Rider 🛵 floating above track ─────────────────────────────
              AnimatedBuilder(
                animation: _riderCtrl,
                builder: (_, __) {
                  final x = nodeR + (w - nodeR * 2) * _riderPos;
                  return Positioned(
                    left: x - 18,
                    top: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🛵',
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center),
                        Container(
                          width: 2,
                          height: 14,
                          color: AppColors.primary.withAlpha(130),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNode(int index, bool isDone, bool isCurrent, double radius) {
    if (isCurrent) {
      return AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, __) {
          return Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color:
                      AppColors.primary.withAlpha((140 * _pulseAnim.value).round()),
                  blurRadius: 12 * _pulseAnim.value,
                  spreadRadius: 3 * _pulseAnim.value,
                ),
              ],
            ),
            child: Icon(_stepIcons[index],
                color: Colors.white, size: radius * 1.1),
          );
        },
      );
    }

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone ? AppColors.success : AppColors.surfaceVariant,
        border: isDone
            ? null
            : Border.all(color: AppColors.textHint, width: 1.5),
      ),
      child: Icon(
        isDone ? Icons.check_rounded : _stepIcons[index],
        color: isDone ? Colors.white : AppColors.textHint,
        size: radius * 1.1,
      ),
    );
  }

  Widget _buildStepLabels() {
    return Row(
      children: List.generate(4, (i) {
        final isActive = i <= _displayStep;
        final isCurrent = i == _displayStep;
        return Expanded(
          child: Text(
            _stepLabels[i],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              height: 1.4,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              color: isCurrent
                  ? AppColors.primary
                  : isActive
                      ? AppColors.success
                      : AppColors.textHint,
            ),
          ),
        );
      }),
    );
  }

  // ─── Items list ──────────────────────────────────────────────────────────────

  Widget _buildItemsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'รายการอาหาร',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          ...widget.order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.fastfood_rounded,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.product.name,
                        style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 14),
                      ),
                    ),
                    Text(
                      'x${item.quantity}',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '฿${(item.product.price * item.quantity).toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textPrimary),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ─── Price breakdown ─────────────────────────────────────────────────────────

  Widget _buildPriceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _priceRow('ยอดรวม',
              '฿${widget.order.subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _priceRow(
            'ค่าจัดส่ง',
            widget.order.deliveryFee == 0
                ? 'ฟรี'
                : '฿${widget.order.deliveryFee.toStringAsFixed(0)}',
            valueColor:
                widget.order.deliveryFee == 0 ? AppColors.success : null,
          ),
          const Divider(height: 24),
          _priceRow(
            'ยอดรวมทั้งหมด',
            '฿${widget.order.total.toStringAsFixed(0)}',
            bold: true,
            valueColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value,
      {bool bold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: bold ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: bold ? 15 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
            fontSize: bold ? 17 : 14,
          ),
        ),
      ],
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: Offset(0, 2)),
      ],
    );
  }
}
