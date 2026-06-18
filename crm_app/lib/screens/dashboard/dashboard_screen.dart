import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/constants.dart';
import '../../widgets/base_scaffold.dart';
import '../../models/project_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Project> projects = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() => isLoading = true);
    // TODO: Load projects from Supabase
    // This will be implemented in the Supabase integration section
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;

    return BaseScaffold(
      title: 'Dashboard',
      body: RefreshIndicator(
        onRefresh: _loadProjects,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    _buildWelcomeCard(user?.fullName ?? 'User'),
                    const SizedBox(height: 24),

                    // Quick Stats
                    _buildQuickStats(),
                    const SizedBox(height: 24),

                    // Projects Section
                    _buildProjectsSection(user?.role ?? ''),
                    const SizedBox(height: 24),

                    // Quick Actions (for admin users)
                    if (user?.isAdminLevel ?? false)
                      _buildQuickActions(context),
                  ],
                ),
              ),
      ),
      floatingActionButton: (user?.isAdminLevel ?? false)
          ? FloatingActionButton(
              onPressed: () => context.push('/projects/create'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildWelcomeCard(String userName) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
            BorderRadius.circular(AppConstants.defaultBorderRadius * 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome Back!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hello, $userName',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.folder_outlined,
            label: 'Active Projects',
            value: '${projects.where((p) => p.isActive).length}',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.hourglass_bottom_outlined,
            label: 'On Hold',
            value: '${projects.where((p) => p.isOnHold).length}',
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle_outlined,
            label: 'Completed',
            value: '${projects.where((p) => p.isCompleted).length}',
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius:
            BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection(String userRole) {
    final displayProjects = userRole == 'staff'
        ? projects // In real app, filter by assigned projects
        : projects.where((p) => p.isActive).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Projects',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (displayProjects.isNotEmpty)
              TextButton(
                onPressed: () => context.push('/projects'),
                child: const Text('View All'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (displayProjects.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius:
                  BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.folder_open_outlined,
                  size: 48,
                  color: AppColors.textLighter,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No projects yet',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayProjects.take(3).length,
            itemBuilder: (context, index) {
              final project = displayProjects[index];
              return _buildProjectCard(project, context);
            },
          ),
      ],
    );
  }

  Widget _buildProjectCard(Project project, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        child: ListTile(
          title: Text(project.projectName),
          subtitle: Text('${project.typeDisplay} • ${project.location}'),
          trailing: Chip(
            label: Text(project.status),
            backgroundColor: project.isActive
                ? AppColors.success.withOpacity(0.2)
                : AppColors.warning.withOpacity(0.2),
            labelStyle: TextStyle(
              color: project.isActive ? AppColors.success : AppColors.warning,
              fontSize: 12,
            ),
          ),
          onTap: () => context.push('/projects/${project.id}'),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppConstants.defaultBorderRadius),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => context.push('/projects/create'),
                icon: const Icon(Icons.add),
                label: const Text('New Project'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => context.push('/clients'),
                icon: const Icon(Icons.people),
                label: const Text('Clients'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
