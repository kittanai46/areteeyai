import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/category.dart';
import '../../../l10n/app_localizations.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  Color get _cardColor {
    switch (category.type) {
      case CategoryType.food:
        return AppColors.foodCategory;
      case CategoryType.delivery:
        return AppColors.deliveryCategory;
      case CategoryType.freshFood:
        return AppColors.freshFoodCategory;
      case CategoryType.coupons:
        return const Color(0xFFE91E8C);
    }
  }

  String _localizedName(AppLocalizations l10n) {
    switch (category.type) {
      case CategoryType.food:
        return l10n.categoryFood;
      case CategoryType.delivery:
        return l10n.categoryDelivery;
      case CategoryType.freshFood:
        return l10n.categoryFreshFood;
      case CategoryType.coupons:
        return l10n.categoryCoupons;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: _cardColor.withAlpha(26),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardColor.withAlpha(77), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(category.iconPath, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 6),
            Text(
              _localizedName(l10n),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _cardColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
