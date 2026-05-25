import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:areteeyai/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/locale_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildProfileHeader(l10n),
          const SizedBox(height: 8),
          _buildMenuSection(context, [
            _MenuItem(Icons.location_on_outlined, l10n.addressSection, () {}),
            _MenuItem(Icons.payment_outlined, l10n.paymentSection, () {}),
            _MenuItem(Icons.notifications_outlined, l10n.notificationsSection, () {}),
          ], l10n.accountSection),
          _buildMenuSection(context, [
            _MenuItem(Icons.help_outline, l10n.helpSection, () {}),
            _MenuItem(Icons.info_outline, l10n.aboutSection, () {}),
            _MenuItem(Icons.logout, l10n.logoutSection, () {}, color: AppColors.error),
          ], l10n.generalSection),
          _buildLanguageSection(context, l10n),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(AppLocalizations l10n) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.primary.withAlpha(26),
            child: const Text('A',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.profileUser,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              const Text('user@aretee.app',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, List<_MenuItem> items, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary)),
        ),
        Container(
          color: AppColors.surface,
          child: Column(
            children: items
                .map((item) => ListTile(
                      leading: Icon(item.icon,
                          color: item.color ?? AppColors.textPrimary),
                      title: Text(item.label,
                          style: TextStyle(color: item.color)),
                      trailing: item.color != null
                          ? null
                          : const Icon(Icons.chevron_right,
                              color: AppColors.textHint),
                      onTap: item.onTap,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSection(BuildContext context, AppLocalizations l10n) {
    final localeProvider = context.watch<LocaleProvider>();
    final isThai = localeProvider.locale.languageCode == 'th';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(
            l10n.languageSection,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary),
          ),
        ),
        Container(
          color: AppColors.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.language, color: AppColors.textPrimary),
                const SizedBox(width: 16),
                Text(l10n.languageLabel,
                    style: const TextStyle(
                        fontSize: 16, color: AppColors.textPrimary)),
                const Spacer(),
                _LanguageToggle(
                  isThai: isThai,
                  thaiLabel: l10n.languageThai,
                  englishLabel: l10n.languageEnglish,
                  onChanged: (locale) =>
                      context.read<LocaleProvider>().setLocale(locale),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  final bool isThai;
  final String thaiLabel;
  final String englishLabel;
  final ValueChanged<Locale> onChanged;

  const _LanguageToggle({
    required this.isThai,
    required this.thaiLabel,
    required this.englishLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleButton(
            label: thaiLabel,
            isSelected: isThai,
            onTap: () => onChanged(const Locale('th')),
          ),
          _ToggleButton(
            label: englishLabel,
            isSelected: !isThai,
            onTap: () => onChanged(const Locale('en')),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  _MenuItem(this.icon, this.label, this.onTap, {this.color});
}

