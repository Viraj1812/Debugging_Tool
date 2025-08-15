import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:debug_mate/constants/app_constants.dart';
import 'package:debug_mate/constants/app_strings.dart';
import 'package:debug_mate/constants/app_colors.dart';
import 'package:debug_mate/constants/app_styles.dart';
import 'package:debug_mate/feature/home/widgets/switch_button.dart';
import 'package:flutter/material.dart';
import 'package:master_utility/master_utility.dart';

class SettingItem extends StatelessWidget {
  final IconData icon;
  final LinearGradient iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final int delay;
  final bool showSettingsIcon;

  const SettingItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.delay = 100,
    this.showSettingsIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, animationValue, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animationValue)),
          child: Opacity(opacity: animationValue.clamp(0, 1), child: child),
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: AppConstants.animationDurationNormal),
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.background.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: value 
                ? iconColor.colors.first.withValues(alpha: 0.3)
                : AppColors.surfaceLight.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Icon Container
                Container(
                  width: AppConstants.iconSizeXl,
                  height: AppConstants.iconSizeXl,
                  decoration: BoxDecoration(
                    gradient: iconColor,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.colors.first.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.textPrimary,
                    size: AppConstants.iconSizeMd,
                  ),
                ),
                
                const SizedBox(width: AppConstants.spacingMd),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppStyles.titleLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingXs),
                      Text(
                        subtitle,
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: AppConstants.spacingMd),
                
                // Switch Button
                SwitchButton(value: value, onChanged: onChanged),
              ],
            ),
            
            // Settings Icon Section - Only show when both showSettingsIcon is true AND switch is enabled
            // Debug: print('showSettingsIcon: $showSettingsIcon, value: $value');
            if (showSettingsIcon && value) ...[
              const SizedBox(height: AppConstants.spacingMd),
              GestureDetector(
                onTap: _openWirelessDebuggingSettings,
                child: AnimatedSize(
                  duration: Duration(milliseconds: AppConstants.animationDurationNormal),
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.surface.withValues(alpha: 0.5),
                          AppColors.surfaceLight.withValues(alpha: 0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                      border: Border.all(
                        color: AppColors.surfaceLight.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppConstants.spacingSm),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSm),
                          ),
                          child: Icon(
                            Icons.qr_code_scanner_outlined,
                            color: AppColors.accent,
                            size: AppConstants.iconSizeMd,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMd),
                        Text(
                          AppStrings.openScanner,
                          style: AppStyles.labelLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingSm),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.textTertiary,
                          size: AppConstants.iconSizeSm,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openWirelessDebuggingSettings() async {
    try {
      final intent = AndroidIntent(
        action: AppConstants.wirelessDebuggingScreen,
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
    } catch (e) {
      LogHelper.logError(e.toString());
      try {
        final intent = AndroidIntent(
          action: AppConstants.developerOptionsScreen,
          flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        await intent.launch();
      } catch (e) {
        LogHelper.logError(e.toString());
        ToastHelper.showToast(message: AppStrings.failedToOpenSettings);
      }
    }
  }
}
