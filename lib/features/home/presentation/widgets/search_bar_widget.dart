import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearchPressed;
  final String? hintText;
  final bool autofocus;

  const SearchBarWidget({
    Key? key,
    this.controller,
    this.onChanged,
    this.onSearchPressed,
    this.hintText,
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus && 
                        (widget.controller?.text.isNotEmpty ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search input field
        Container(
          height: AppDimensions.inputHeight,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.searchBarRadius),
            border: Border.all(
              color: _focusNode.hasFocus 
                  ? AppColors.primary 
                  : AppColors.border,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
            boxShadow: _focusNode.hasFocus
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            style: AppTextStyles.inputText,
            textInputAction: TextInputAction.search,
            onChanged: (value) {
              widget.onChanged?.call(value);
              setState(() {
                _showSuggestions = _focusNode.hasFocus && value.isNotEmpty;
              });
            },
            onSubmitted: (_) => widget.onSearchPressed?.call(),
            decoration: InputDecoration(
              hintText: widget.hintText ?? AppStrings.searchPlaceholder,
              hintStyle: AppTextStyles.inputHint,
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.textSecondary,
                size: AppDimensions.iconM,
              ),
              suffixIcon: widget.controller?.text.isNotEmpty == true
                  ? IconButton(
                      onPressed: () {
                        widget.controller?.clear();
                        widget.onChanged?.call('');
                        setState(() {
                          _showSuggestions = false;
                        });
                      },
                      icon: Icon(
                        Icons.clear,
                        color: AppColors.textSecondary,
                        size: AppDimensions.iconM,
                      ),
                    )
                  : Icon(
                      Icons.tune,
                      color: AppColors.textSecondary,
                      size: AppDimensions.iconM,
                    ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
                vertical: AppDimensions.paddingM,
              ),
            ),
          ),
        ),
        
        // Search suggestions (simplified - no BlocBuilder)
        if (_showSuggestions)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No suggestions available'),
            ),
          ),
      ],
    );
  }

  Widget _buildSuggestions(List<String> suggestions) {
    return Container(
      margin: const EdgeInsets.only(top: AppDimensions.paddingS),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          indent: AppDimensions.paddingL,
          endIndent: AppDimensions.paddingL,
        ),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            leading: Icon(
              Icons.search,
              color: AppColors.textTertiary,
              size: AppDimensions.iconM,
            ),
            title: Text(
              suggestion,
              style: AppTextStyles.bodyMedium,
            ),
            trailing: Icon(
              Icons.arrow_outward,
              color: AppColors.textTertiary,
              size: AppDimensions.iconS,
            ),
            onTap: () {
              widget.controller?.text = suggestion;
              widget.onChanged?.call(suggestion);
              widget.onSearchPressed?.call();
              _focusNode.unfocus();
            },
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL,
              vertical: AppDimensions.paddingS,
            ),
          );
        },
      ),
    );
  }
}

// Compact search bar for use in app bars
class CompactSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final String? hintText;

  const CompactSearchBar({
    Key? key,
    this.onTap,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: AppDimensions.iconM,
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: Text(
                hintText ?? AppStrings.searchPlaceholder,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}