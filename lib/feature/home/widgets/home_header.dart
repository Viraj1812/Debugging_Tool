import 'package:debug_mate/constants/app_strings.dart';
import 'package:debug_mate/constants/app_colors.dart';
import 'package:debug_mate/constants/app_styles.dart';
import 'package:debug_mate/constants/app_constants.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingLg,
        AppConstants.spacingXl,
        AppConstants.spacingLg,
        AppConstants.spacingXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Icon and Title Row
          Row(
            children: [
              Container(
                width: AppConstants.iconSizeXl,
                height: AppConstants.iconSizeXl,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bug_report,
                  color: AppColors.textPrimary,
                  size: AppConstants.iconSizeLg,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.appName,
                      style: AppStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingXs),
                    Text(
                      'v1.0.0',
                      style: AppStyles.overline.copyWith(
                        color: AppColors.textTertiary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                  vertical: AppConstants.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Text(
                      'Active',
                      style: AppStyles.labelSmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingXl),
          
          // Main Title and Description
          Text(
            AppStrings.homeTitle,
            style: AppStyles.displaySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            AppStrings.homeTitleDesc,
            style: AppStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingXl),
          
          // Quick Stats Bar
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
              border: Border.all(
                color: AppColors.surfaceLight.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildQuickStat(
                  icon: Icons.settings,
                  label: 'Settings',
                  value: '3',
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppConstants.spacingLg),
                Container(
                  width: 1,
                  height: 32,
                  color: AppColors.surfaceLight.withValues(alpha: 0.3),
                ),
                const SizedBox(width: AppConstants.spacingLg),
                _buildQuickStat(
                  icon: Icons.security,
                  label: 'Security',
                  value: 'High',
                  color: AppColors.success,
                ),
                const SizedBox(width: AppConstants.spacingLg),
                Container(
                  width: 1,
                  height: 32,
                  color: AppColors.surfaceLight.withValues(alpha: 0.3),
                ),
                const SizedBox(width: AppConstants.spacingLg),
                _buildQuickStat(
                  icon: Icons.speed,
                  label: 'Performance',
                  value: 'Optimal',
                  color: AppColors.accent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: AppConstants.iconSizeMd,
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            label,
            style: AppStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingXs),
          Text(
            value,
            style: AppStyles.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
