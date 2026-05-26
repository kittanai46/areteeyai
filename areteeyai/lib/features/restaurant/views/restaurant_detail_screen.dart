import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/restaurant.dart';
import '../../../core/models/product.dart';
import '../../cart/view_models/cart_view_model.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(child: _buildInfoBar()),
          SliverToBoxAdapter(child: _buildTagRow()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                'เมนู',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _MenuItemTile(
                  product: restaurant.menu[i],
                  onAddToCart: () {
                    context
                        .read<CartViewModel>()
                        .addItem(restaurant.menu[i]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'เพิ่ม ${restaurant.menu[i].name} ในตะกร้าแล้ว'),
                        backgroundColor: AppColors.success,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                childCount: restaurant.menu.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.surface,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: Colors.white.withAlpha(220),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                size: 18, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          restaurant.coverImageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.surfaceVariant,
            child: const Icon(Icons.restaurant,
                size: 64, color: AppColors.textHint),
          ),
        ),
        title: Text(
          restaurant.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            shadows: [
              Shadow(color: Colors.black54, blurRadius: 8),
            ],
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
      ),
    );
  }

  Widget _buildInfoBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          _InfoChip(
            icon: Icons.star,
            iconColor: AppColors.warning,
            label:
                '${restaurant.rating.toStringAsFixed(1)} (${restaurant.reviewCount})',
          ),
          const SizedBox(width: 16),
          _InfoChip(
            icon: Icons.access_time_outlined,
            iconColor: AppColors.primary,
            label: restaurant.deliveryTime,
          ),
          const SizedBox(width: 16),
          _InfoChip(
            icon: Icons.delivery_dining_outlined,
            iconColor: AppColors.secondary,
            label: restaurant.deliveryFee == 0
                ? 'ส่งฟรี'
                : '฿${restaurant.deliveryFee}',
          ),
          if (restaurant.isNearby) ...[
            const SizedBox(width: 16),
            _InfoChip(
              icon: Icons.location_on_outlined,
              iconColor: AppColors.success,
              label: '${restaurant.distanceKm} กม.',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTagRow() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 14),
      child: Wrap(
        spacing: 8,
        children: restaurant.tags
            .map(
              (t) => Chip(
                label: Text(t,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                backgroundColor: AppColors.surfaceVariant,
                side: BorderSide.none,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: iconColor),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _MenuItemTile extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const _MenuItemTile({required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(14)),
            child: Image.network(
              product.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 100,
                height: 100,
                color: AppColors.surfaceVariant,
                child: const Icon(Icons.fastfood,
                    size: 36, color: AppColors.textHint),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.description,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 13, color: AppColors.warning),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '฿${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: onAddToCart,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add,
                    color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
