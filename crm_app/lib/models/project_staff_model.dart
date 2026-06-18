class ProjectStaff {
  final String id;
  final String projectId;
  final String staffId;
  final String staffName;
  final String role;
  final DateTime assignedDate;
  final String assignedBy;

  ProjectStaff({
    required this.id,
    required this.projectId,
    required this.staffId,
    required this.staffName,
    required this.role,
    required this.assignedDate,
    required this.assignedBy,
  });

  factory ProjectStaff.fromJson(Map<String, dynamic> json) {
    return ProjectStaff(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      staffId: json['staff_id'] as String,
      staffName: json['staff_name'] as String? ?? 'Unknown',
      role: json['role'] as String,
      assignedDate: DateTime.parse(json['assigned_date'] as String),
      assignedBy: json['assigned_by'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'staff_id': staffId,
      'staff_name': staffName,
      'role': role,
      'assigned_date': assignedDate.toIso8601String(),
      'assigned_by': assignedBy,
    };
  }
}
