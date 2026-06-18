class Client {
  final String id;
  final String clientName;
  final String contactPerson;
  final String email;
  final String phone;
  final String address;
  final DateTime createdAt;

  Client({
    required this.id,
    required this.clientName,
    required this.contactPerson,
    required this.email,
    required this.phone,
    required this.address,
    required this.createdAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as String,
      clientName: json['client_name'] as String,
      contactPerson: json['contact_person'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_name': clientName,
      'contact_person': contactPerson,
      'email': email,
      'phone': phone,
      'address': address,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
