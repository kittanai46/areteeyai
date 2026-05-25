import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../view_models/food_view_model.dart';
import '../../cart/view_models/cart_view_model.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodViewModel>().loadFoodItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.foodTitle),
        backgroundColor: AppColors.foodCategory,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () => context.go('/')),
      ),
      body: Consumer<FoodViewModel>(
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
                    onPressed: vm.loadFoodItems,
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              _buildSearchBar(vm, l10n),
              Expanded(child: _buildProductList(vm)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(FoodViewModel vm, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: vm.updateSearch,
        decoration: InputDecoration(
          hintText: l10n.foodSearchHint,
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(FoodViewModel vm) {
    final products = vm.filteredProducts;
    if (products.isEmpty) {
      return const Center(
        child: Text('ไม่พบรายการอาหาร',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: products.length,
      itemBuilder: (_, i) {
        final p = products[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                p.imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  color: AppColors.surfaceVariant,
                  child: const Icon(Icons.fastfood, color: AppColors.textHint),
                ),
              ),
            ),
            title: Text(p.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.restaurantName,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 13, color: AppColors.warning),
                    Text(' ${p.rating}',
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '฿${p.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 15),
                ),
                const SizedBox(height: 4),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '+ เพิ่ม',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
