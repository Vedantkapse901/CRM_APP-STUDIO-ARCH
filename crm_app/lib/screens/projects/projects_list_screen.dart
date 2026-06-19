import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/constants.dart';
import '../../widgets/base_scaffold.dart';
import '../../providers/auth_provider.dart';

class ProjectsListScreen extends StatefulWidget {
  const ProjectsListScreen({Key? key}) : super(key: key);

  @override
  State<ProjectsListScreen> createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends State<ProjectsListScreen> {
  String _selectedFilter = 'all'; // all, active, on_hold, completed
  late final SupabaseClient _supabase;
  List<Map<String, dynamic>> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _supabase = Supabase.instance.client;
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    try {
      setState(() => _isLoading = true);

      final authProvider = context.read<AuthProvider>();
      final user = authProvider.currentUser;

      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      List<dynamic> response;

      // Filter projects based on user role
      if (user.role == 'staff') {
        // Staff can only see projects they're assigned to
        final staffAssignments = await _supabase
            .from('project_staff')
            .select('project_id')
            .eq('staff_id', user.id);

        final projectIds = staffAssignments.map((p) => p['project_id']).toList();

        if (projectIds.isEmpty) {
          response = [];
        } else {
          // Fetch projects for this staff member
          response = await _supabase
              .from('projects')
              .select()
              .order('created_at', ascending: false);

          // Filter locally
          response = response.where((p) => projectIds.contains(p['id'])).toList();
        }
      } else {
        // Architect, Admin, HR can see all projects
        response = await _supabase
            .from('projects')
            .select()
            .order('created_at', ascending: false);
      }

      setState(() {
        _projects = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading projects: $e')),
        );
      }
    }
  }

  List<Map<String, dynamic>> _getFilteredProjects() {
    if (_selectedFilter == 'all') {
      return _projects;
    }
    return _projects.where((p) => p['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Projects',
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/projects/create').then((_) => _loadProjects()),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Active', 'active'),
                const SizedBox(width: 8),
                _buildFilterChip('On Hold', 'on_hold'),
                const SizedBox(width: 8),
                _buildFilterChip('Completed', 'completed'),
              ],
            ),
          ),
          // Projects List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _getFilteredProjects().isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open_outlined,
                              size: 64,
                              color: AppColors.textLighter,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No projects found',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  context.push('/projects/create').then((_) => _loadProjects()),
                              icon: const Icon(Icons.add),
                              label: const Text('Create Project'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadProjects,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(AppConstants.defaultPadding),
                          itemCount: _getFilteredProjects().length,
                          itemBuilder: (context, index) {
                            final project = _getFilteredProjects()[index];
                            return _buildProjectCard(project);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return GestureDetector(
      onTap: () => context.push('/projects/${project['id']}').then((_) => _loadProjects()),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      project['project_name'] ?? 'Unnamed Project',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Chip(
                    label: Text(
                      project['status']?.toUpperCase() ?? 'ACTIVE',
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: _getStatusColor(project['status']).withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: _getStatusColor(project['status']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category: ${project['category']?.replaceAll('_', ' ').toUpperCase() ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    'Type: ${project['type']?.toUpperCase() ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Location: ${project['location'] ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Client: ${project['client_name'] ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'active':
        return AppColors.success;
      case 'on_hold':
        return AppColors.warning;
      case 'completed':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: isSelected ? AppColors.primary : AppColors.background,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.text,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
