class UserModel {
  final String name;
  final String uid;
  final String? imageUrl;
  final String? role;
  final String? department;

  UserModel({
    required this.uid,
    required this.name,
    this.imageUrl,
    this.department,
    this.role,
  });

  // fromJson: Creates a UserModel instance from a Map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      role: json['role'] as String?,
      department: json['department'] as String?,
    );
  }

  // toJson: Converts the UserModel instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'imageUrl': imageUrl,
      'department': department,
    };
  }
}
