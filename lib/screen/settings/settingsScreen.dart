import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;

import '../../constants/app_strings.dart';
import '../../services/controllers/settingController.dart';

/// ============================================================
/// Settings Screen — clean, modern, accessible
/// ============================================================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SettingsController());
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        leading: IconButton(onPressed: ()=> Get.back(), icon: Icon(IconlyLight.arrow_left_2)),
        elevation: 0,
      ),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final version = snapshot.hasData
              ? "v${snapshot.data!.version}+${snapshot.data!.buildNumber}"
              : "Loading...";

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _ProfileCard(controller: c),
              const SizedBox(height: 16),

              // Preferences
              Text('Preferences',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: cs.primary)),
              const SizedBox(height: 8),
              _ProCard(
                children: [
                  Obx(() => _ProTile(
                    leading: const Icon(Icons.language),
                    title: AppStrings.languageTitle,
                    subtitle: c.languageLabel.value,
                    onTap: c.openLanguageDialog,
                  )),
                ],
              ),

              const SizedBox(height: 24),

              // Account
              Text('Account',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: cs.primary)),
              const SizedBox(height: 8),
              _ProCard(
                children: [
                  _ProTile(
                    leading: Icon(IconlyLight.logout, color: Colors.red.shade400),
                    title: 'Logout',
                    titleStyle: TextStyle(
                      color: Colors.red.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                    showChevron: false,
                    onTap: () => c.confirmLogout(),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 👇 Version text at bottom
              Center(
                child: Text(
                  version,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        },
      ),

    );
  }
}

/// ============================================================
/// Widgets — polished building blocks
/// ============================================================
class _ProfileCard extends StatelessWidget {
  final SettingsController controller;
  const _ProfileCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final user = controller.customer.value;

      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Circular profile image with icon inside (as per requirement)
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey,
              child: const Icon(IconlyLight.profile, size: 36, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (user?.name?.isNotEmpty ?? false) ? user!.name : 'Your Name',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (user?.phone?.isNotEmpty ?? false)
                        ? user!.phone
                        : 'Phone number',
                    style: textTheme.bodyMedium?.copyWith(
                      color: textTheme.bodyMedium?.color?.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _ProCard extends StatelessWidget {
  final List<Widget> children;
  const _ProCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.4),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i != 0) Divider(height: 0, color: Theme.of(context).dividerColor.withOpacity(0.2)),
            children[i],
          ]
        ],
      ),
    );
  }
}

class _ProTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final bool showChevron;
  final VoidCallback? onTap;
  const _ProTile({
    required this.leading,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.showChevron = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              SizedBox(width: 28, child: Center(child: leading)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: (titleStyle ?? textTheme.bodyLarge)?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              if (showChevron) const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class LangTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const LangTile({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? cs.primary : Theme.of(context).dividerColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? cs.primary : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
