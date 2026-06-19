import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/constants.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final FloatingActionButton? floatingActionButton;
  final int unreadMessagesCount;

  const BaseScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.unreadMessagesCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            accountName: Text(
              user?.fullName ?? 'User',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: Text(
                (user?.fullName ?? 'U')[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            onTap: () {
              Navigator.pop(context);
              context.go('/dashboard');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.folder_outlined,
            label: 'Projects',
            onTap: () {
              Navigator.pop(context);
              context.go('/projects');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.people_outline,
            label: 'Clients',
            onTap: () {
              Navigator.pop(context);
              context.go('/clients');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.message_outlined,
            label: 'Messages',
            badge: unreadMessagesCount > 0 ? unreadMessagesCount.toString() : null,
            onTap: () {
              Navigator.pop(context);
              context.go('/messages');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.person_outline,
            label: 'My Profile',
            onTap: () {
              Navigator.pop(context);
              context.go('/profile');
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.logout_outlined,
            label: 'Logout',
            isDestructive: true,
            onTap: () async {
              Navigator.pop(context);
              await authProvider.logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    String? badge,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.primaryLight,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDestructive ? AppColors.error : Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
