import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';
import 'theme_data.dart' as app_theme_data;

class AppTheme {
  static ThemeData get lightTheme {
    final fontScale = app_theme_data.ThemeData.fontScaleFactor;
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.primaryLight,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        background: AppColors.background,
        onBackground: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: AppDimensions.appBarElevation,
        centerTitle: true,
        titleTextStyle: AppTextStyles.appBarTitle.copyWith(
          fontSize: AppTextStyles.appBarTitle.fontSize! * fontScale,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      
      // Bottom Navigation Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTextStyles.navigationLabel.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: AppTextStyles.navigationLabel.fontSize! * fontScale,
        ),
        unselectedLabelStyle: AppTextStyles.navigationLabel.copyWith(
          fontSize: AppTextStyles.navigationLabel.fontSize! * fontScale,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingS,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.inputPaddingH,
          vertical: AppDimensions.inputPaddingV,
        ),
        hintStyle: AppTextStyles.inputHint.copyWith(
          fontSize: AppTextStyles.inputHint.fontSize! * fontScale,
        ),
        labelStyle: AppTextStyles.inputLabel.copyWith(
          fontSize: AppTextStyles.inputLabel.fontSize! * fontScale,
        ),
        errorStyle: AppTextStyles.errorText.copyWith(
          fontSize: AppTextStyles.errorText.fontSize! * fontScale,
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppColors.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.buttonPaddingH,
            vertical: AppDimensions.buttonPaddingV,
          ),
          textStyle: AppTextStyles.buttonLarge.copyWith(
            fontSize: AppTextStyles.buttonLarge.fontSize! * fontScale,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.buttonMedium.copyWith(
            color: AppColors.primary,
            fontSize: AppTextStyles.buttonMedium.fontSize! * fontScale,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.buttonPaddingH,
            vertical: AppDimensions.buttonPaddingV,
          ),
          textStyle: AppTextStyles.buttonLarge.copyWith(
            color: AppColors.primary,
            fontSize: AppTextStyles.buttonLarge.fontSize! * fontScale,
          ),
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: AppDimensions.dividerThickness,
        indent: AppDimensions.dividerIndent,
        endIndent: AppDimensions.dividerIndent,
      ),
      
      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.listItemPadding,
          vertical: AppDimensions.paddingS,
        ),
        titleTextStyle: AppTextStyles.bodyLarge.copyWith(
          fontSize: AppTextStyles.bodyLarge.fontSize! * fontScale,
        ),
        subtitleTextStyle: AppTextStyles.bodySmall.copyWith(
          fontSize: AppTextStyles.bodySmall.fontSize! * fontScale,
        ),
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.dialogRadius),
        ),
        titleTextStyle: AppTextStyles.h5.copyWith(
          fontSize: AppTextStyles.h5.fontSize! * fontScale,
        ),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          fontSize: AppTextStyles.bodyMedium.fontSize! * fontScale,
        ),
      ),
      
      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
          fontSize: AppTextStyles.bodyMedium.fontSize! * fontScale,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.snackbarRadius),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.labelLarge.copyWith(
          fontSize: AppTextStyles.labelLarge.fontSize! * fontScale,
        ),
        unselectedLabelStyle: AppTextStyles.labelLarge.copyWith(
          fontSize: AppTextStyles.labelLarge.fontSize! * fontScale,
        ),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: AppDimensions.tabIndicatorHeight,
          ),
        ),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.cardBackground,
        selectedColor: AppColors.primary,
        labelStyle: AppTextStyles.labelSmall.copyWith(
          fontSize: AppTextStyles.labelSmall.fontSize! * fontScale,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.chipPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.chipRadius),
        ),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.cardBackground,
        circularTrackColor: AppColors.cardBackground,
      ),
      
      // Text Theme with font scaling
      textTheme: TextTheme(
        displayLarge: AppTextStyles.h1.copyWith(
          fontSize: AppTextStyles.h1.fontSize! * fontScale,
        ),
        displayMedium: AppTextStyles.h2.copyWith(
          fontSize: AppTextStyles.h2.fontSize! * fontScale,
        ),
        displaySmall: AppTextStyles.h3.copyWith(
          fontSize: AppTextStyles.h3.fontSize! * fontScale,
        ),
        headlineLarge: AppTextStyles.h3.copyWith(
          fontSize: AppTextStyles.h3.fontSize! * fontScale,
        ),
        headlineMedium: AppTextStyles.h4.copyWith(
          fontSize: AppTextStyles.h4.fontSize! * fontScale,
        ),
        headlineSmall: AppTextStyles.h5.copyWith(
          fontSize: AppTextStyles.h5.fontSize! * fontScale,
        ),
        titleLarge: AppTextStyles.h5.copyWith(
          fontSize: AppTextStyles.h5.fontSize! * fontScale,
        ),
        titleMedium: AppTextStyles.h6.copyWith(
          fontSize: AppTextStyles.h6.fontSize! * fontScale,
        ),
        titleSmall: AppTextStyles.labelLarge.copyWith(
          fontSize: AppTextStyles.labelLarge.fontSize! * fontScale,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          fontSize: AppTextStyles.bodyLarge.fontSize! * fontScale,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          fontSize: AppTextStyles.bodyMedium.fontSize! * fontScale,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          fontSize: AppTextStyles.bodySmall.fontSize! * fontScale,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          fontSize: AppTextStyles.labelLarge.fontSize! * fontScale,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          fontSize: AppTextStyles.labelMedium.fontSize! * fontScale,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          fontSize: AppTextStyles.labelSmall.fontSize! * fontScale,
        ),
      ),
    );
  }
  
  static ThemeData get darkTheme {
    final fontScale = app_theme_data.ThemeData.fontScaleFactor;
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.primaryLight,
        onSecondary: Colors.white,
        surface: Color(0xFF1E1E1E),
        onSurface: Colors.white,
        background: Color(0xFF121212),
        onBackground: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
      ),
      
      // App Bar Theme (Dark)
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: AppDimensions.appBarElevation,
        centerTitle: true,
        titleTextStyle: AppTextStyles.appBarTitle.copyWith(
          color: Colors.white,
          fontSize: AppTextStyles.appBarTitle.fontSize! * fontScale,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      
      // Card Theme (Dark)
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingS,
        ),
      ),
      
      // Input Decoration Theme (Dark)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.inputPaddingH,
          vertical: AppDimensions.inputPaddingV,
        ),
        hintStyle: AppTextStyles.inputHint.copyWith(
          color: Colors.white54,
          fontSize: AppTextStyles.inputHint.fontSize! * fontScale,
        ),
        labelStyle: AppTextStyles.inputLabel.copyWith(
          color: Colors.white,
          fontSize: AppTextStyles.inputLabel.fontSize! * fontScale,
        ),
        errorStyle: AppTextStyles.errorText.copyWith(
          fontSize: AppTextStyles.errorText.fontSize! * fontScale,
        ),
      ),
      
      // Text Theme (Dark) with font scaling
      textTheme: TextTheme(
        displayLarge: AppTextStyles.h1.copyWith(
          color: Colors.white,
          fontSize: AppTextStyles.h1.fontSize! * fontScale,
        ),
        displayMedium: AppTextStyles.h2.copyWith(
          color: Colors.white,
          fontSize: AppTextStyles.h2.fontSize! * fontScale,
        ),
        displaySmall: AppTextStyles.h3.copyWith(
          color: Colors.white,
          fontSize: AppTextStyles.h3.fontSize! * fontScale,
        ),
        headlineLarge: AppTextStyles.h3.copyWith(
          color: Colors.white,
          fontSize: AppTextStyles.h3.fontSize! * fontScale,
        ),
        headlineMedium: AppTextStyles.h4.copyWith(
          color: Colors.white,
          fontSize: AppTextStyles.h4.fontSize! * fontScale,
        ),
        headlineSmall: AppTextStyles.h5.copyWith(
          color: Colors.white,
          fontSize: AppTextStyles.h5.fontSize! * fontScale,
        ),
        titleLarge: AppTextStyles.h5.copyWith(
          color: Colors.white,
          fontSize: AppTextStyles.h5.fontSize! * fontScale,
        ),
        titleMedium: AppTextStyles.h6.copyWith(
          color: Colors.white,
          fontSize: AppTextStyles.h6.fontSize! * fontScale,
        ),
        titleSmall: AppTextStyles.labelLarge.copyWith(
          color: Colors.white,
          fontSize: AppTextStyles.labelLarge.fontSize! * fontScale,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: Colors.white,
          fontSize: AppTextStyles.bodyLarge.fontSize! * fontScale,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
          fontSize: AppTextStyles.bodyMedium.fontSize! * fontScale,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: Colors.white70,
          fontSize: AppTextStyles.bodySmall.fontSize! * fontScale,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: Colors.white,
          fontSize: AppTextStyles.labelLarge.fontSize! * fontScale,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: Colors.white70,
          fontSize: AppTextStyles.labelMedium.fontSize! * fontScale,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: Colors.white54,
          fontSize: AppTextStyles.labelSmall.fontSize! * fontScale,
        ),
      ),
    );
  }
}