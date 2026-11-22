import 'package:flutter/material.dart';

import '../../data/app_state.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'user_info_sheet.dart';
import 'notifications_sheet.dart';
import '../../widgets/confirm_dialog.dart';
import '../../l10n/app_strings.dart';

/// Bottom navigation tab: Profile.
/// Shown inside MainShell, so it has no back arrow.
///
/// Appearance changes the app theme right away. Language is saved in app_state.dart and will be connected in the Turkish step.
class PreferencesScreen extends StatefulWidget {
 /// Tells MainShell that Light / Dark / System 
final VoidCallback onAppearanceChanged;

const PreferencesScreen({super.key, required this.onAppearanceChanged});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  /// Saves the appearance choice and asks MainShell to apply it.
  void _setAppearance(String value) {
    setState(() {
      appAppearance = value;
    });
    widget.onAppearanceChanged();
  }
  /// open the user information sheet
  Future<void> _openUserInfo() async {
    await showUserInfoSheet(context);
    if (!mounted) return;
    setState(() {});
  }

  /// Opens the notifications sheet 
  Future<void> _openNotifications() async {
    await showNotificationsSheet(context);
    if (!mounted) return;
    setState(() {});
  }

/// Asks for confirmation then goes back to Welcome and clears navigation history so the back button cannot return
Future<void> _signOut() async {
  final ok = await showConfirmDialog(
    context: context,
    title: AppStrings.get('signOutTitle'),
    message: AppStrings.get('signOutMessage'),
    confirmText: AppStrings.get('signOut'),
    icon: Icons.logout,
  );

  if (!ok || !mounted) return;

  Navigator.pushNamedAndRemoveUntil(
    context,
    AppRoutes.welcome,
    (route) => false,
  );
}

  /// Small grey title like "APP" or "ACCOUNT".
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: AppSpacing.sm),
      child: Text(
        text,
        style:  TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: AppColors.secondaryText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        foregroundColor: AppColors.darkGreen,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        shape:  Border(
          bottom: BorderSide(color: AppColors.cardBorder),
        ),
        title:  Text(
          AppStrings.get('preferences'),
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGreen,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md + AppSpacing.xs, // 20
          AppSpacing.md,
          AppSpacing.md + AppSpacing.xs,
          AppSpacing.lg,
        ),
        children: [
          _UserCard(
            name: userName,
            email: userEmail,
            onTap: _openUserInfo,
          ),
          const SizedBox(height: AppSpacing.lg),

          // APP settings
          _sectionTitle(AppStrings.get('appSection')),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                // Language
                _SettingRow(
                  icon: Icons.menu,
                  title: AppStrings.get('language'),
                  subtitle: AppStrings.get('languageSubtitle'),
                  child: Row(
                    children: [
                      _OptionButton(
                        text: 'English',
                        selected: appLanguage == 'en',
                        onTap: () {
                          setState(() {
                            appLanguage = 'en';
                          });
                          widget.onAppearanceChanged();
                        },
                      ),
                      const SizedBox(width: 8),
                      _OptionButton(
                        text: 'Türkçe',
                        selected: appLanguage == 'tr',
                        onTap: () {
                          setState(() {
                            appLanguage = 'tr';
                          });
                          widget.onAppearanceChanged();
                        },
                      ),
                    ],
                  ),
                ),
                 Divider(height: 1, color: AppColors.cardBorder),

                // Appearance
                _SettingRow(
                  icon: Icons.visibility_outlined,
                  title: AppStrings.get('appearance'),
                  subtitle: AppStrings.get('appearanceSubtitle'),
                  child: Row(
                    children: [
                      _OptionButton(
                        text: AppStrings.get('light'),
                        selected: appAppearance == 'light',
                        onTap: () => _setAppearance('light'),
                      ),
                      const SizedBox(width: 8),
                      _OptionButton(
                        text: AppStrings.get('dark'),
                        selected: appAppearance == 'dark',
                        onTap: () => _setAppearance('dark'),
                      ),
                      const SizedBox(width: 8),
                      _OptionButton(
                        text: AppStrings.get('system'),
                        selected: appAppearance == 'system',
                        onTap: () => _setAppearance('system'),
                      ),
                    ],
                  ),
                ),
                 Divider(height: 1, color: AppColors.cardBorder),

                // Notifications
                GestureDetector(
                  onTap: _openNotifications,
                  child: Container(
                    color: Colors.transparent, // whole row is tappable
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                         Icon(
                          Icons.notifications_none,
                          size: 22,
                          color: AppColors.darkGreen,
                        ),
                        const SizedBox(width: 14),
                         Expanded(
                          child: Text(
                            AppStrings.get('notifications'),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkGreen,
                            ),
                          ),
                        ),
                        Text(
                          notificationsEnabled
                            ? AppStrings.get('on')
                            : AppStrings.get('off'),
                          style:  TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(width: 4),
                         Icon(
                          Icons.chevron_right,
                          color: AppColors.darkGreen,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ACCOUNT
          _sectionTitle(AppStrings.get('accountSection')),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            onPressed: _signOut,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              backgroundColor: AppColors.white,
              minimumSize: const Size(double.infinity, 46),
              side:  BorderSide(color: AppColors.dangerLight, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: Text(AppStrings.get('signOut')),
          ),
          const SizedBox(height: AppSpacing.md),

           Text(
            AppStrings.get('versionNote'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

/// card with the user's initial, name and e-mail
/// Tapping it opens the user information sheet
class _UserCard extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onTap;

  const _UserCard({
    required this.name,
    required this.email,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // First letter of the name 
    String initial = '?';
    if (name.trim().isNotEmpty) {
      initial = name.trim()[0].toUpperCase();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primary,
              child: Text(
                initial,
                style:  TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGreen,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style:  TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    overflow: TextOverflow.ellipsis,
                    style:  TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
             Icon(Icons.chevron_right, color: AppColors.darkGreen),
          ],
        ),
      ),
    );
  }
}

/// One setting inside the APP box: icon, title, subtitle and the choice buttons under them.
class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  const _SettingRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.darkGreen),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:  TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style:  TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 10),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One choice button, e.g. "English" or "Dark"
class _OptionButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _OptionButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.lightMint : AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.cardBorder,
              width: selected ? 2 : 1.5,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.darkGreen : AppColors.secondaryText,
            ),
          ),
        ),
      ),
    );
  }
}