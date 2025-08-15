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
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPatternPainter(),
              ),
            ),
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: AppConstants.spacingXl),
                child: Column(
                  children: [
                    // Header Section
                    HomeHeader(),
                    
                    // Content Section
                    Container(
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
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: _buildSettingsList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
                colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isActive ? null : AppColors.surface.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
        border: Border.all(
          color: isActive ? color.withValues(alpha: 0.4) : AppColors.surfaceLight.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive 
                ? color.withValues(alpha: 0.2)
                : AppColors.surface.withValues(alpha: 0.1),
            blurRadius: isActive ? 20 : 10,
            spreadRadius: isActive ? 2 : 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingSm),
                decoration: BoxDecoration(
                  gradient: isActive 
                      ? LinearGradient(
                          colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isActive ? null : AppColors.surfaceLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                  boxShadow: isActive ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ] : null,
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
                  gradient: isActive 
                      ? LinearGradient(
                          colors: [color, color.withValues(alpha: 0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isActive ? null : AppColors.surfaceLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusSm),
                  boxShadow: isActive ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ] : null,
                ),
                child: Text(
                  isActive ? 'ON' : 'OFF',
                  style: AppStyles.labelSmall.copyWith(
                    color: isActive ? AppColors.textPrimary : AppColors.textTertiary,
                    fontWeight: FontWeight.w700,
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
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXs),
          Text(
            value,
            style: AppStyles.titleMedium.copyWith(
              color: isActive ? color : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Text(
            'Debug Settings',
            style: AppStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.settings,
            color: AppColors.primary.withValues(alpha: 0.7),
            size: AppConstants.iconSizeMd,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    return Column(
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

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.surface.withValues(alpha: 0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw subtle grid pattern
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }
    
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }

    // Draw subtle circles
    final circlePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.02)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.2),
      60,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.8),
      80,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ShimmerEffect extends StatefulWidget {
  final Color color;
  
  const ShimmerEffect({super.key, required this.color});
  
  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: [
                widget.color.withValues(alpha: 0.0),
                widget.color.withValues(alpha: 0.1),
                widget.color.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
            ),
          ),
        );
      },
    );
  }
}
