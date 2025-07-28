import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Base text style using Google Fonts
  static TextStyle get _baseTextStyle => GoogleFonts.roboto(
        color: AppColors.textPrimary,
      );

  // Display styles
  static TextStyle get displayLarge => _baseTextStyle.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
      );

  static TextStyle get displayMedium => _baseTextStyle.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get displaySmall => _baseTextStyle.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w400,
      );

  // Headline styles
  static TextStyle get headlineLarge => _baseTextStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get headlineMedium => _baseTextStyle.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get headlineSmall => _baseTextStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w400,
      );

  // Title styles
  static TextStyle get titleLarge => _baseTextStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get titleMedium => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      );

  static TextStyle get titleSmall => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      );

  // Label styles
  static TextStyle get labelLarge => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => _baseTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => _baseTextStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  // Body styles
  static TextStyle get bodyLarge => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      );

  static TextStyle get bodyMedium => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      );

  static TextStyle get bodySmall => _baseTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      );

  // Custom app-specific styles
  static TextStyle get priceText => _baseTextStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      );

  static TextStyle get priceLarge => _baseTextStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      );

  static TextStyle get priceSmall => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      );

  static TextStyle get storeName => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get productName => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get buttonText => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  static TextStyle get buttonTextSmall => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  static TextStyle get chipText => _baseTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get hintText => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textHint,
      );

  static TextStyle get errorText => _baseTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.error,
      );

  static TextStyle get successText => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.success,
      );

  static TextStyle get warningText => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.warning,
      );

  static TextStyle get priceUpText => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.priceUp,
      );

  static TextStyle get priceDownText => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.priceDown,
      );

  static TextStyle get appBarTitle => _baseTextStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.surface,
      );

  static TextStyle get tabBarText => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get cardTitle => _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get cardSubtitle => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );
}
