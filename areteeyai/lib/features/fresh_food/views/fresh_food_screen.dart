import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../view_models/fresh_food_view_model.dart';
import '../../cart/view_models/cart_view_model.dart';

class FreshFoodScreen extends StatefulWidget {
  const FreshFoodScreen({super.key});

  @override
  State<FreshFoodScreen> createState() => _FreshFoodScreenState();
}

class _FreshFoodScreenState extends State<FreshFoodScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FreshFoodViewModel>().loadFreshFood();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.freshFoodTitle),
        backgroundColor: AppColors.freshFoodCategory,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () => context.go('/')),
      ),
      body: Consumer<FreshFoodViewModel>(
        builder: (_, vm, __) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(vm.errorMessage!,
                      style: const TextStyle(color: AppColors.error)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: vm.loadFreshFood,
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              _buildSubCategoryChips(vm),
              Expanded(child: _buildProductGrid(vm)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubCategoryChips(FreshFoodViewModel vm) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: vm.subCategories.length,
        itemBuilder: (_, i) {
          final cat = vm.subCategories[i];
          final selected = vm.selectedSubCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(cat),
              selected: selected,
              onSelected: (_) => vm.selectSubCategory(cat),
              selectedColor: AppColors.freshFoodCategory,
              labelStyle: TextStyle(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontWeight:
                    selected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: AppColors.surface,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(FreshFoodViewModel vm) {
    final products = vm.filteredProducts;
    if (products.isEmpty) {
      return const Center(
        child: Text('ไม่พบสินค้า',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.78,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) {
        final p = products[i];
        return Container(
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
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    p.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.eco,
                          size: 40, color: AppColors.textHint),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '฿${p.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: AppColors.freshFoodCategory,
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<CartViewModel>().addItem(p);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('เพิ่ม ${p.name} แล้ว'),
                                backgroundColor: AppColors.success,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.freshFoodCategory,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
