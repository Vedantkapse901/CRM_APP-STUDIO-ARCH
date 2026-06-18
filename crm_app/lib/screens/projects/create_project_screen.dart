import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../widgets/base_scaffold.dart';

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

  String _selectedCategory = 'architectural_design';
  String _selectedType = 'residential';
  String _selectedStatus = 'active';

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

              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Save project to Supabase
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Create Project'),
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
    super.dispose();
  }
}
