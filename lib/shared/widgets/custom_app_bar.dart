import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final Widget? bottom;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.bottom,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppTextStyles.appBarTitle.copyWith(
          color: foregroundColor ?? AppColors.textPrimary,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.surface,
      foregroundColor: foregroundColor ?? AppColors.textPrimary,
      elevation: elevation ?? AppDimensions.appBarElevation,
      leading: leading ?? (showBackButton ? _buildBackButton(context) : null),
      actions: actions,
      bottom: bottom as PreferredSizeWidget?,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back_ios),
      iconSize: AppDimensions.iconL,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    AppDimensions.appBarHeight + (bottom?.preferredSize.height ?? 0),
  );
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final List<Widget>? actions;

  const SearchAppBar({
    Key? key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onSearchPressed,
    this.onBackPressed,
    this.showBackButton = true,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: AppDimensions.appBarElevation,
      leading: showBackButton
          ? IconButton(
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: AppDimensions.iconL,
            )
          : null,
      title: Container(
        height: AppDimensions.searchBarHeight,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.searchBarRadius),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.inputHint,
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: AppDimensions.iconM,
            ),
            suffixIcon: controller?.text.isNotEmpty == true
                ? IconButton(
                    onPressed: () {
                      controller?.clear();
                      onChanged?.call('');
                    },
                    icon: Icon(
                      Icons.clear,
                      color: AppColors.textSecondary,
                      size: AppDimensions.iconM,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL,
              vertical: AppDimensions.paddingM,
            ),
          ),
          style: AppTextStyles.inputText,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => onSearchPressed?.call(),
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);
}