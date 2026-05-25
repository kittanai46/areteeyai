import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../view_models/delivery_view_model.dart';

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.deliveryTitle),
        backgroundColor: AppColors.deliveryCategory,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () => context.go('/')),
      ),
      body: Consumer<DeliveryViewModel>(
        builder: (_, vm, __) {
          if (vm.activeRequest != null) {
            return _buildTrackingView(context, vm);
          }
          return _buildRequestForm(context, vm);
        },
      ),
    );
  }

  Widget _buildRequestForm(BuildContext context, DeliveryViewModel vm) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.deliverySubtitle,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          _buildAddressField(
            context,
            label: AppStrings.pickupAddress,
            icon: Icons.circle_outlined,
            iconColor: AppColors.primary,
            onChanged: vm.updatePickupAddress,
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              width: 2,
              height: 20,
              color: AppColors.divider,
            ),
          ),
          const SizedBox(height: 6),
          _buildAddressField(
            context,
            label: AppStrings.dropoffAddress,
            icon: Icons.location_on,
            iconColor: AppColors.deliveryCategory,
            onChanged: vm.updateDropoffAddress,
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 6,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ค่าบริการโดยประมาณ',
                    style: TextStyle(color: AppColors.textSecondary)),
                const Text('฿50 – ฿120',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: vm.canRequest && !vm.isLoading
                  ? () => vm.requestDelivery()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deliveryCategory,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: vm.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text(AppStrings.sendPackage,
                      style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressField(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color iconColor,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: iconColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.surface,
        ),
      ),
    );
  }

  Widget _buildTrackingView(BuildContext context, DeliveryViewModel vm) {
    final req = vm.activeRequest!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.local_shipping,
                    size: 56, color: AppColors.deliveryCategory),
                const SizedBox(height: 12),
                Text(
                  req.statusLabel,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
                _buildTrackRow(Icons.circle_outlined, req.pickupAddress,
                    AppColors.primary),
                const Divider(),
                _buildTrackRow(Icons.location_on, req.dropoffAddress,
                    AppColors.deliveryCategory),
                const Divider(),
                _buildTrackRow(Icons.attach_money,
                    '฿${req.estimatedFee.toStringAsFixed(0)}', AppColors.success),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: vm.cancelRequest,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(AppStrings.cancel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
              child: Text(text,
                  style: const TextStyle(color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}
