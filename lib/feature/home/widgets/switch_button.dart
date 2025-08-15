import 'package:flutter/material.dart';
import 'package:debug_mate/constants/app_colors.dart';
import 'package:debug_mate/constants/app_constants.dart';

class SwitchButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  
  const SwitchButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: AppConstants.animationDurationNormal),
        width: 60,
        height: 32,
        decoration: BoxDecoration(
          gradient: value
              ? AppColors.primaryGradient
              : null,
                  color: value ? null : AppColors.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: value
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.background.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
        border: Border.all(
          color: value 
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.surfaceLight.withValues(alpha: 0.3),
          width: 1.5,
        ),
        ),
        child: AnimatedAlign(
          duration: Duration(milliseconds: AppConstants.animationDurationNormal),
          curve: Curves.easeInOutCubic,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                              gradient: value
                    ? null
                    : LinearGradient(
                        colors: [
                          AppColors.surface.withValues(alpha: 0.8),
                          AppColors.surfaceLight.withValues(alpha: 0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                color: value ? AppColors.textPrimary : null,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.background.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
            ),
            child: value
                ? Icon(
                    Icons.check,
                    color: AppColors.primary,
                    size: AppConstants.iconSizeSm,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
