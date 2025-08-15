import 'package:flutter/material.dart';
import 'package:debug_mate/constants/app_colors.dart';
import 'package:debug_mate/constants/app_constants.dart';
import 'package:debug_mate/constants/app_strings.dart';
import 'package:debug_mate/feature/home/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;
  
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<Offset> _textSlide;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToHome();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );
    
    _logoRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeInOut,
      ),
    );

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Fade animation for smooth transition
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 800), () {
      _textController.forward();
    });
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 3500));
    if (mounted) {
      _fadeController.forward();
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Section
                Expanded(
                  flex: 3,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScale.value,
                          child: Transform.rotate(
                            angle: _logoRotation.value * 0.1,
                            child: Container(
                              width: AppConstants.iconSizeXl * 3,
                              height: AppConstants.iconSizeXl * 3,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusXl,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.bug_report,
                                size: AppConstants.iconSizeXl * 1.5,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Text Section
                Expanded(
                  flex: 2,
                  child: SlideTransition(
                    position: _textSlide,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.appName,
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingLg,
                            vertical: AppConstants.spacingSm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLg,
                            ),
                            border: Border.all(
                              color: AppColors.surfaceLight.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                                                     child: Text(
                             'Advanced debugging tools for developers',
                             style: GoogleFonts.inter(
                               fontSize: 16,
                               color: AppColors.textSecondary,
                               fontWeight: FontWeight.w500,
                               height: 1.4,
                             ),
                             textAlign: TextAlign.center,
                           ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Loading indicator
                Expanded(
                  flex: 1,
                  child: Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        backgroundColor: AppColors.surface.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
