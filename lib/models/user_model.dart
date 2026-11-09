class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isAdmin;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.isAdmin = false,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? isAdmin,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      isAdmin: map['isAdmin'] as bool? ?? false,
    );
  }
}
