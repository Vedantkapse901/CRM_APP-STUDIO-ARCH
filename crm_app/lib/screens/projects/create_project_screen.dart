import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../config/constants.dart';
import '../../widgets/base_scaffold.dart';
import '../../providers/auth_provider.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({Key? key}) : super(key: key);

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _areaController = TextEditingController();
  final _clientNameController = TextEditingController();

  String _selectedCategory = 'architectural_design';
  String _selectedType = 'residential';
  String _selectedStatus = 'active';
  bool _isLoading = false;
  late final SupabaseClient _supabase;

  @override
  void initState() {
    super.initState();
    _supabase = Supabase.instance.client;
  }

  Future<void> _createProject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.currentUser;

      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Get or create default client
      String clientId;
      String clientName = _clientNameController.text.isEmpty ? 'Default Client' : _clientNameController.text;

      try {
        // First, try to get the default client
        final clients = await _supabase
            .from('clients')
            .select('id')
            .eq('client_name', 'Default Client')
            .limit(1);

        if (clients.isNotEmpty) {
          clientId = clients[0]['id'];
        } else {
          // If default client doesn't exist, create it
          final newClient = await _supabase.from('clients').insert({
            'client_name': 'Default Client',
            'contact_person': 'Default Contact',
            'email': 'default@client.com',
            'phone': '+1-555-0000',
            'address': 'Default Address',
          }).select();

          if (newClient.isEmpty) {
            throw Exception('Failed to create default client');
          }
          clientId = newClient[0]['id'];
        }
      } catch (clientError) {
        // Last resort: try to get any client
        try {
          final anyClients = await _supabase
              .from('clients')
              .select('id')
              .limit(1);

          if (anyClients.isNotEmpty) {
            clientId = anyClients[0]['id'];
          } else {
            rethrow;
          }
        } catch (e) {
          throw Exception('Error with clients: $e');
        }
      }

      // Insert project
      await _supabase.from('projects').insert({
        'project_name': _projectNameController.text,
        'category': _selectedCategory,
        'type': _selectedType,
        'location': _locationController.text,
        'area': double.parse(_areaController.text),
        'consultant_id': user.id,
        'consultant_name': user.fullName,
        'client_id': clientId,
        'client_name': clientName,
        'status': _selectedStatus,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project created successfully!')),
        );
        context.go('/projects');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating project: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Create Project',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Project Name
              TextFormField(
                controller: _projectNameController,
                decoration: InputDecoration(
                  labelText: 'Project Name',
                  hintText: 'Enter project name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultBorderRadius),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter project name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Selection
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultBorderRadius),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'architectural_design',
                    child: Text('Architectural Design'),
                  ),
                  DropdownMenuItem(
                    value: 'design_licensing',
                    child: Text('Design + Licensing'),
                  ),
                  DropdownMenuItem(
                    value: 'pmc',
                    child: Text('PMC'),
                  ),
                ].toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Project Type
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Project Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultBorderRadius),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: 'residential', child: Text('Residential')),
                  DropdownMenuItem(value: 'commercial', child: Text('Commercial')),
                  DropdownMenuItem(value: 'hospital', child: Text('Hospital')),
                ].toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedType = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  hintText: 'Enter project location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultBorderRadius),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Area
              TextFormField(
                controller: _areaController,
                decoration: InputDecoration(
                  labelText: 'Area (sq.ft)',
                  hintText: 'Enter project area',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultBorderRadius),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter area';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Status
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultBorderRadius),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'on_hold', child: Text('On Hold')),
                  DropdownMenuItem(value: 'completed', child: Text('Completed')),
                ].toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedStatus = value);
                  }
                },
              ),
              const SizedBox(height: 32),

              // Client Name
              TextFormField(
                controller: _clientNameController,
                decoration: InputDecoration(
                  labelText: 'Client Name (Optional)',
                  hintText: 'Enter client name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultBorderRadius),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createProject,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Create Project'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _locationController.dispose();
    _areaController.dispose();
    _clientNameController.dispose();
    super.dispose();
  }
}
