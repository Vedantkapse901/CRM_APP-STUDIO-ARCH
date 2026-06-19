import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/constants.dart';
import '../../widgets/base_scaffold.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart' as models;

class ProjectDetailsScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailsScreen({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  bool _isEditMode = false;
  bool _isLoading = true;
  Map<String, dynamic>? _projectData;
  late final SupabaseClient _supabase;

  // Form controllers
  late TextEditingController _projectNameController;
  late TextEditingController _locationController;
  late TextEditingController _areaController;
  late TextEditingController _clientNameController;
  late TextEditingController _contactPersonController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  String? _selectedCategory;
  String? _selectedType;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _supabase = Supabase.instance.client;
    _initializeControllers();
    _loadProjectData();
  }

  void _initializeControllers() {
    _projectNameController = TextEditingController();
    _locationController = TextEditingController();
    _areaController = TextEditingController();
    _clientNameController = TextEditingController();
    _contactPersonController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  Future<void> _loadProjectData() async {
    try {
      final response = await _supabase
          .from('projects')
          .select()
          .eq('id', widget.projectId)
          .single();

      setState(() {
        _projectData = response;
        _projectNameController.text = response['project_name'] ?? '';
        _locationController.text = response['location'] ?? '';
        _areaController.text = response['area']?.toString() ?? '';
        _clientNameController.text = response['client_name'] ?? '';
        _selectedCategory = response['category'];
        _selectedType = response['type'];
        _selectedStatus = response['status'];
        _contactPersonController.text = '';
        _emailController.text = response['client_email'] ?? '';
        _phoneController.text = response['client_phone'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading project: $e')),
        );
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_projectNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project name is required')),
      );
      return;
    }

    try {
      await _supabase.from('projects').update({
        'project_name': _projectNameController.text,
        'location': _locationController.text,
        'area': double.tryParse(_areaController.text) ?? 0,
        'category': _selectedCategory,
        'type': _selectedType,
        'status': _selectedStatus,
        'client_name': _clientNameController.text,
      }).eq('id', widget.projectId);

      setState(() => _isEditMode = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project updated successfully')),
        );
      }
      await _loadProjectData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving project: $e')),
        );
      }
    }
  }

  bool _canEdit() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    return user != null &&
        (user.role == 'architect' || user.role == 'admin' || user.role == 'hr');
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _locationController.dispose();
    _areaController.dispose();
    _clientNameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Project Details',
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isEditMode
              ? _buildEditMode()
              : _buildViewMode(),
    );
  }

  Widget _buildViewMode() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _projectData?['project_name'] ?? 'Project Name',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_canEdit())
                ElevatedButton.icon(
                  onPressed: () => setState(() => _isEditMode = true),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(_projectData?['status']?.toUpperCase() ?? 'Active'),
                    backgroundColor: AppColors.success.withOpacity(0.2),
                    labelStyle: const TextStyle(color: AppColors.success),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Type',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(_projectData?['type']?.replaceAll('_', ' ').toUpperCase() ?? 'Commercial'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoSection(
            title: 'Project Information',
            items: [
              _buildInfoItem('Location', _projectData?['location'] ?? '-'),
              _buildInfoItem('Area', '${_projectData?['area'] ?? 0} sq.ft'),
              _buildInfoItem('Category', _projectData?['category']?.replaceAll('_', ' ').toUpperCase() ?? '-'),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoSection(
            title: 'Client Information',
            items: [
              _buildInfoItem('Client Name', _projectData?['client_name'] ?? '-'),
              _buildInfoItem('Contact Person', _projectData?['contact_person'] ?? '-'),
              _buildInfoItem('Email', _projectData?['client_email'] ?? '-'),
              _buildInfoItem('Phone', _projectData?['client_phone'] ?? '-'),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoSection(
            title: 'Consultant Information',
            items: [
              _buildInfoItem('Name', _projectData?['consultant_name'] ?? '-'),
              _buildInfoItem('Email', _projectData?['consultant_email'] ?? '-'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditMode() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Edit Project',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => setState(() => _isEditMode = false),
                    icon: const Icon(Icons.close),
                    label: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _saveChanges,
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Project Name *', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _projectNameController,
            decoration: InputDecoration(
              hintText: 'Enter project name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            items: const [
              DropdownMenuItem(value: 'architectural_design', child: Text('Architectural Design')),
              DropdownMenuItem(value: 'design_licensing', child: Text('Design + Licensing')),
              DropdownMenuItem(value: 'pmc', child: Text('PMC')),
            ],
            onChanged: (value) => setState(() => _selectedCategory = value),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedType,
            items: const [
              DropdownMenuItem(value: 'residential', child: Text('Residential')),
              DropdownMenuItem(value: 'commercial', child: Text('Commercial')),
              DropdownMenuItem(value: 'hospital', child: Text('Hospital')),
            ],
            onChanged: (value) => setState(() => _selectedType = value),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedStatus,
            items: const [
              DropdownMenuItem(value: 'active', child: Text('Active')),
              DropdownMenuItem(value: 'on_hold', child: Text('On Hold')),
              DropdownMenuItem(value: 'completed', child: Text('Completed')),
            ],
            onChanged: (value) => setState(() => _selectedStatus = value),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: 'Enter location',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Area (sq.ft)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _areaController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter area',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Client Name', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _clientNameController,
            decoration: InputDecoration(
              hintText: 'Enter client name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius:
                BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assigned Staff',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius:
                    BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Staff Member Name',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Role: Project Supervisor',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
