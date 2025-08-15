import 'package:debug_mate/constants/app_strings.dart';
import 'package:debug_mate/constants/app_colors.dart';
import 'package:debug_mate/constants/app_styles.dart';
import 'package:debug_mate/constants/app_constants.dart';
import 'package:debug_mate/feature/home/widgets/home_header.dart';
import 'package:debug_mate/feature/home/widgets/setting_item.dart';
import 'package:debug_mate/models/settings_model.dart';
import 'package:debug_mate/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _settingsService = SettingsService();
  SettingsModel _settings = SettingsModel();

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
    _initializeAnimations();
    _getSettings();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              HomeHeader(),
              
              // Content Section
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingLg,
                  ),
                  child: Column(
                    children: [
                      // Stats Cards Row
                      _buildStatsRow(),
                      
                      const SizedBox(height: AppConstants.spacingXl),
                      
                      // Settings Section Title
                      _buildSectionTitle(),
                      
                      const SizedBox(height: AppConstants.spacingLg),
                      
                      // Settings Items
                      Expanded(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: _buildSettingsList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Developer Mode',
            value: _settings.devModeEnabled ? 'Enabled' : 'Disabled',
            icon: Icons.code,
            color: AppColors.primary,
            isActive: _settings.devModeEnabled,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: _buildStatCard(
            title: 'USB Debugging',
            value: _settings.adbEnabled ? 'Active' : 'Inactive',
            icon: Icons.usb,
            color: AppColors.secondary,
            isActive: _settings.adbEnabled,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isActive,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: AppConstants.animationDurationNormal),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        gradient: isActive 
            ? LinearGradient(
                colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isActive ? null : AppColors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
        border: Border.all(
          color: isActive ? color.withValues(alpha: 0.3) : AppColors.surfaceLight.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
                              Container(
                  padding: const EdgeInsets.all(AppConstants.spacingSm),
                  decoration: BoxDecoration(
                    color: isActive ? color.withValues(alpha: 0.2) : AppColors.surfaceLight.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                  ),
                  child: Icon(
                    icon,
                    color: isActive ? color : AppColors.textTertiary,
                    size: AppConstants.iconSizeMd,
                  ),
                ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingSm,
                  vertical: AppConstants.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: isActive ? color : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusSm),
                ),
                child: Text(
                  isActive ? 'ON' : 'OFF',
                  style: AppStyles.labelSmall.copyWith(
                    color: isActive ? AppColors.textPrimary : AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            title,
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXs),
          Text(
            value,
            style: AppStyles.titleMedium.copyWith(
              color: isActive ? color : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Text(
          'Debug Settings',
          style: AppStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsList() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SettingItem(
          icon: Icons.code,
          iconColor: AppColors.primaryGradient,
          title: AppStrings.developerOptions,
          subtitle: AppStrings.developerOptionsDesc,
          value: _settings.devModeEnabled,
          onChanged: (value) {
            _updateSettings(
              _settings.copyWith(
                devModeEnabled: !_settings.devModeEnabled,
              ),
            );
          },
          delay: 100,
        ),
        const SizedBox(height: AppConstants.spacingMd),
        SettingItem(
          icon: Icons.usb,
          iconColor: AppColors.secondaryGradient,
          title: AppStrings.usbDebugging,
          subtitle: AppStrings.usbDebuggingDesc,
          value: _settings.adbEnabled,
          onChanged: (value) {
            _updateSettings(
              _settings.copyWith(
                adbEnabled: !_settings.adbEnabled,
              ),
            );
          },
          delay: 200,
        ),
        const SizedBox(height: AppConstants.spacingMd),
        SettingItem(
          icon: Icons.wifi,
          iconColor: AppColors.accentGradient,
          title: AppStrings.wirelessDebugging,
          subtitle: AppStrings.wirelessDebuggingDesc,
          value: _settings.wifiAdbEnabled,
          showSettingsIcon: true,
          onChanged: (value) {
            _updateSettings(
              _settings.copyWith(
                wifiAdbEnabled: !_settings.wifiAdbEnabled,
              ),
            );
          },
          delay: 300,
        ),
      ],
    );
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: AppConstants.animationDurationSlower),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: AppConstants.animationDurationSlower + 200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  _getSettings() async {
    _settings = await _settingsService.getSettigs();
    setState(() {});
  }

  _updateSettings(SettingsModel settings) async {
    _settings = await _settingsService.updateSettings(settings);
    setState(() {});
  }
}
