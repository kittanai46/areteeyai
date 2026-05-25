import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/category.dart';
import '../../../l10n/app_localizations.dart';
import '../view_models/home_view_model.dart';
import '../../cart/view_models/cart_view_model.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: const _EventBanner()),
                  SliverToBoxAdapter(child: _buildCategorySection()),
                  SliverToBoxAdapter(child: _buildPopularSection()),
                  const SliverToBoxAdapter(child: _MarqueeTicker(
                    text: 'สวัสดีครับ จ้างผมได้ครับ ผมกำลังหาเงินซื้อเวย์โปรตีน',
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.greeting} 👋',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.appName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Consumer<CartViewModel>(
            builder: (_, cart, __) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined,
                      color: AppColors.textPrimary, size: 28),
                  onPressed: () => context.go('/cart'),
                ),
                if (cart.totalItems > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cart.totalItems}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            const Icon(Icons.search, color: AppColors.textHint),
            const SizedBox(width: 10),
            Text(
              l10n.searchHint,
              style: const TextStyle(color: AppColors.textHint, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<HomeViewModel>(
      builder: (_, vm, __) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  l10n.categories,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 100,
                child: vm.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: vm.categories.length,
                        itemBuilder: (_, i) => CategoryCard(
                          category: vm.categories[i],
                          onTap: () => _navigateToCategory(vm.categories[i].type),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToCategory(CategoryType type) {
    switch (type) {
      case CategoryType.food:
        context.go('/food');
      case CategoryType.delivery:
        context.go('/delivery');
      case CategoryType.freshFood:
        context.go('/fresh-food');
      case CategoryType.coupons:
        context.go('/coupons');
    }
  }

  Widget _buildPopularSection() {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<HomeViewModel>(
      builder: (_, vm, __) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 0, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.popularItems,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(l10n.seeAll,
                          style: const TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (vm.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (vm.popularProducts.isEmpty)
                Center(
                    child: Text(l10n.retry,
                        style: const TextStyle(color: AppColors.textSecondary)))
              else
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: vm.popularProducts.length,
                    itemBuilder: (_, i) {
                      final product = vm.popularProducts[i];
                      return ProductCard(
                        product: product,
                        onAddToCart: () {
                          context.read<CartViewModel>().addItem(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('เพิ่ม ${product.name} ในตะกร้าแล้ว'),
                              backgroundColor: AppColors.success,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Marquee Ticker ──────────────────────────────────────────────────────────

class _MarqueeTicker extends StatefulWidget {
  final String text;
  const _MarqueeTicker({required this.text});

  @override
  State<_MarqueeTicker> createState() => _MarqueeTickerState();
}

class _MarqueeTickerState extends State<_MarqueeTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Estimated width of full text strip; tune if needed
  static const double _textWidth = 520.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(18),
        border: Border.symmetric(
          horizontal: BorderSide(
              color: AppColors.primary.withAlpha(50), width: 0.5),
        ),
      ),
      child: ClipRect(
        child: LayoutBuilder(
          builder: (_, constraints) {
            final screenW = constraints.maxWidth;
            final totalTravel = screenW + _textWidth;
            return AnimatedBuilder(
              animation: _controller,
              builder: (_, child) => Transform.translate(
                offset: Offset(screenW - _controller.value * totalTravel, 0),
                child: child,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.fiber_manual_record,
                      size: 7, color: AppColors.primary.withAlpha(180)),
                  const SizedBox(width: 10),
                  Text(
                    widget.text,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    softWrap: false,
                  ),
                  const SizedBox(width: 40),
                  Icon(Icons.fiber_manual_record,
                      size: 7, color: AppColors.primary.withAlpha(180)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Auto-sliding Event Banner ───────────────────────────────────────────────

class _BannerItem {
  final String title;
  final String subtitle;
  final Color startColor;
  final Color endColor;
  final IconData icon;

  const _BannerItem({
    required this.title,
    required this.subtitle,
    required this.startColor,
    required this.endColor,
    required this.icon,
  });
}

const _banners = [
  _BannerItem(
    title: 'ส่งฟรี ทุกวันศุกร์!',
    subtitle: 'สั่งอาหารครบ ฿200 รับสิทธิ์ทันที',
    startColor: Color(0xFFFF6B35),
    endColor: Color(0xFFFF9A3C),
    icon: Icons.local_shipping_outlined,
  ),
  _BannerItem(
    title: 'อาหารสดคัดพิเศษ',
    subtitle: 'ผักและผลไม้สดใหม่ทุกเช้า ลด 15%',
    startColor: Color(0xFF2ECC71),
    endColor: Color(0xFF27AE60),
    icon: Icons.eco_outlined,
  ),
  _BannerItem(
    title: 'โปรโมชั่น Flash Sale',
    subtitle: 'ลดสูงสุด 50% เฉพาะวันนี้เท่านั้น',
    startColor: Color(0xFF9B59B6),
    endColor: Color(0xFF8E44AD),
    icon: Icons.flash_on_outlined,
  ),
  _BannerItem(
    title: 'บริการรับส่งด่วน',
    subtitle: 'รับพัสดุถึงบ้านภายใน 30 นาที',
    startColor: Color(0xFF3498DB),
    endColor: Color(0xFF2980B9),
    icon: Icons.delivery_dining_outlined,
  ),
];

class _EventBanner extends StatefulWidget {
  const _EventBanner();

  @override
  State<_EventBanner> createState() => _EventBannerState();
}

class _EventBannerState extends State<_EventBanner> {
  late final PageController _pageController;
  Timer? _timer;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    // Wait one frame so the PageView is laid out before starting the timer
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTimer());
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final next = (_current + 1) % _banners.length;
      setState(() => _current = next);
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Column(
        children: [
          SizedBox(
            height: 140,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _banners.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (_, i) => _BannerCard(banner: _banners[i]),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _banners.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _current == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _current == i
                      ? _banners[i].startColor
                      : AppColors.textHint.withAlpha(80),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  final _BannerItem banner;

  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [banner.startColor, banner.endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: banner.startColor.withAlpha(80),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  banner.subtitle,
                  style: TextStyle(
                    color: Colors.white.withAlpha(220),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            banner.icon,
            size: 64,
            color: Colors.white.withAlpha(60),
          ),
        ],
      ),
    );
  }
}
