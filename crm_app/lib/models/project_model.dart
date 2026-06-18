class Project {
  final String id;
  final String projectName;
  final String category; // architectural_design, design_licensing, pmc
  final String type; // residential, commercial, hospital
  final String location;
  final double area;
  final String consultantId;
  final String consultantName; // for display
  final String clientId;
  final String clientName; // for display
  final String status; // active, on_hold, completed
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String>? staffIds; // IDs of assigned staff
  final int staffCount;

  Project({
    required this.id,
    required this.projectName,
    required this.category,
    required this.type,
    required this.location,
    required this.area,
    required this.consultantId,
    required this.consultantName,
    required this.clientId,
    required this.clientName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.staffIds,
    this.staffCount = 0,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      projectName: json['project_name'] as String,
      category: json['category'] as String,
      type: json['type'] as String,
      location: json['location'] as String,
      area: (json['area'] as num).toDouble(),
      consultantId: json['consultant_id'] as String,
      consultantName: json['consultant_name'] as String? ?? '',
      clientId: json['client_id'] as String,
      clientName: json['client_name'] as String? ?? '',
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      staffIds: json['staff_ids'] != null
          ? List<String>.from(json['staff_ids'] as List)
          : null,
      staffCount: json['staff_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_name': projectName,
      'category': category,
      'type': type,
      'location': location,
      'area': area,
      'consultant_id': consultantId,
      'consultant_name': consultantName,
      'client_id': clientId,
      'client_name': clientName,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'staff_ids': staffIds,
      'staff_count': staffCount,
    };
  }

  bool get isActive => status == 'active';
  bool get isOnHold => status == 'on_hold';
  bool get isCompleted => status == 'completed';

  String get categoryDisplay {
    switch (category) {
      case 'architectural_design':
        return 'Architectural Design';
      case 'design_licensing':
        return 'Design + Licensing';
      case 'pmc':
        return 'PMC';
      default:
        return category;
    }
  }

  String get typeDisplay {
    return type[0].toUpperCase() + type.substring(1);
  }
}
