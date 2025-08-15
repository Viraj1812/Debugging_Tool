import 'package:debug_mate/constants/app_strings.dart';
import 'package:debug_mate/constants/app_colors.dart';
import 'package:debug_mate/constants/app_styles.dart';
import 'package:debug_mate/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
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
                      gradient: LinearGradient(
                        colors: [
                          AppColors.success.withValues(alpha: 0.2),
                          AppColors.success.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                      border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withValues(alpha: 0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
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
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.success.withValues(alpha: 0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
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
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            AppStrings.homeTitleDesc,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.6,
              letterSpacing: 0.15,
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingXl),
          
                        // Quick Stats Bar
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.surface.withValues(alpha: 0.4),
                      AppColors.surface.withValues(alpha: 0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
                  border: Border.all(
                    color: AppColors.surfaceLight.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.surface.withValues(alpha: 0.1),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: const Offset(0, 5),
                    ),
                  ],
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.surfaceLight.withValues(alpha: 0.3),
                        AppColors.surfaceLight.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.surfaceLight.withValues(alpha: 0.3),
                        AppColors.surfaceLight.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
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
        ),
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
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingSm),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: AppConstants.iconSizeMd,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            label,
            style: AppStyles.caption.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingXs),
          Text(
            value,
            style: AppStyles.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
