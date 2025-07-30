import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: AppDimensions.paddingM,
        ),
        child: Row(
          children: [
            // App title and location
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.h5.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: AppDimensions.iconS,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppDimensions.paddingXS),
                      Text(
                        'Kigali, Rwanda',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Notification and profile actions
            Row(
              children: [
                // Notifications button
                IconButton(
                  onPressed: () => _navigateToNotifications(context),
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        size: AppDimensions.iconL,
                        color: AppColors.textSecondary,
                      ),
                      // Notification badge (example)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: AppDimensions.paddingS),
                
                // Profile button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () => _navigateToProfile(context),
                      child: Container(
                        width: AppDimensions.avatarM,
                        height: AppDimensions.avatarM,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: state is AuthAuthenticated && 
                               state.user.profileImageUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  state.user.profileImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildDefaultAvatar(state.user.initials),
                                ),
                              )
                            : _buildDefaultAvatar(
                                state is AuthAuthenticated 
                                    ? state.user.initials 
                                    : 'U',
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(String initials) {
    return Center(
      child: Text(
        initials,
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.pushNamed(context, '/notifications');
  }

  void _navigateToProfile(BuildContext context) {
    // Navigate to profile tab in bottom navigation
    // This would typically be handled by the parent navigation controller
    Navigator.pushNamed(context, '/profile');
  }
}