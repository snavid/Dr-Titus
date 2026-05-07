class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role; // student, staff, admin
  final String? studentId;
  final double walletBalance;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.studentId,
    this.walletBalance = 0.0,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String? ?? 'student',
      studentId: json['studentId'] as String?,
      walletBalance: (json['walletBalance'] ?? 0.0).toDouble(),
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'studentId': studentId,
        'walletBalance': walletBalance,
        'profileImage': profileImage,
      };

  User copyWith({
    String? name,
    String? email,
    String? phone,
    double? walletBalance,
    String? profileImage,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role,
      studentId: studentId,
      walletBalance: walletBalance ?? this.walletBalance,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}


