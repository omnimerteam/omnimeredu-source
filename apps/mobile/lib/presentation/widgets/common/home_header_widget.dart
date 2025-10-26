import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_event.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/display_mapper.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/dialog/logout_dialog_widget.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is! AuthenticationAuthenticated) {
          return const SizedBox.shrink();
        }

        final user = state.user;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left Side - User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Xin chào, ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: user.fullName,
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'PlayfairDisplay',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${DisplayMapper.roleName(user.roleName)}'
                        '${user.position != null ? ' - ${user.position!.displayName}' : ''}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (user.schoolName?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.school,
                            size: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              user.schoolName!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (user.className?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.class_,
                            size: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Lớp ${user.className!}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Right Side - Avatar with Dropdown
              _buildAvatarWithDropdown(
                context,
                user.avatarUrl,
                user.isVerified,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarWithDropdown(
    BuildContext context,
    String? avatarUrl,
    bool? isVerified,
  ) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleMenuSelection(context, value),
      itemBuilder: (BuildContext context) => [
        // const PopupMenuItem<String>(
        //   value: 'account',
        //   child: Row(
        //     children: [
        //       Icon(Icons.account_circle, size: 20),
        //       SizedBox(width: 12),
        //       Text('Tài khoản'),
        //     ],
        //   ),
        // ),
        const PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, size: 20),
              SizedBox(width: 12),
              Text('Thông tin cá nhân'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 20, color: Colors.red),
              SizedBox(width: 12),
              Text('Đăng xuất', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      offset: const Offset(0, 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                  ? NetworkImage(avatarUrl)
                  : const AssetImage("assets/images/default/default_avatar.png")
                        as ImageProvider,
            ),
          ),
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _getStatusColor(isVerified),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(bool? isVerified) {
    if (isVerified == null) return Colors.grey;
    return isVerified ? Colors.green : Colors.red;
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'account':
        break;
      case 'profile':
        Navigator.pushNamed(context, '/profile');
        break;
      case 'logout':
        _showLogoutDialog(context);
        break;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => LogoutDialogWidget(
        onConfirm: () {
          Navigator.of(context).pop();
          context.read<AuthenticationBloc>().add(AuthenticationLoggedOut());
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}
