import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/order.dart';
import '../../../l10n/app_localizations.dart';
import '../view_models/order_view_model.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderViewModel>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.orderTitle),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Consumer<OrderViewModel>(
        builder: (_, vm, __) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.receipt_long_outlined,
                      size: 80, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  Text(l10n.orderEmpty,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(l10n.orderEmptySubtitle,
                      style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vm.orders.length,
            itemBuilder: (_, i) => _buildOrderCard(vm.orders[i], l10n),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OrderDetailScreen(order: order),
        ),
      ),
      child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${order.id.substring(0, 8).toUpperCase()}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15),
              ),
              _buildStatusChip(order.status, l10n),
            ],
          ),
          const SizedBox(height: 10),
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '${item.product.name} x${item.quantity}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              )),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.orderCardTotal,
                  style: const TextStyle(color: AppColors.textSecondary)),
              Text(
                '฿${order.total.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('ดูรายละเอียด',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 2),
              const Icon(Icons.chevron_right,
                  color: AppColors.primary, size: 16),
            ],
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildStatusChip(OrderStatus status, AppLocalizations l10n) {
    Color color;
    switch (status) {
      case OrderStatus.pending:
        color = AppColors.warning;
      case OrderStatus.confirmed:
      case OrderStatus.preparing:
        color = AppColors.info;
      case OrderStatus.onWay:
        color = AppColors.secondary;
      case OrderStatus.delivered:
        color = AppColors.success;
      case OrderStatus.cancelled:
        color = AppColors.error;
    }
    final label = switch (status) {
      OrderStatus.pending   => l10n.orderPending,
      OrderStatus.confirmed => l10n.orderConfirmed,
      OrderStatus.preparing => l10n.orderPreparing,
      OrderStatus.onWay     => l10n.orderOnWay,
      OrderStatus.delivered => l10n.orderDelivered,
      OrderStatus.cancelled => l10n.orderCancelled,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(102)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
