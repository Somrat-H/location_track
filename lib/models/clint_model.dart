class ClintModel {
  final String employeeId;
  final String clintName;
  final String employeName;
  final String note;
  final String time;
  final String imageUrl;
  final List<double> latLong;

  ClintModel({
    required this.clintName,
    required this.employeName,
    required this.employeeId,
    required this.imageUrl,
    required this.latLong,
    required this.note,
    required this.time,
  });

  // fromJson: Creates a ClintModel instance from a Map
  factory ClintModel.fromJson(Map<String, dynamic> json) {
    return ClintModel(
      clintName: json['clintName'] as String,
      employeName: json['employeName'] as String,
      employeeId: json['employeeId'],
      imageUrl: json['imageUrl'],
      note: json['note'],
      time: json['time'],
      latLong: json['latLong'],
    );
  }

  // toJson: Converts the ClintModel instance to a Map
  // Map<String, dynamic> toJson() {
  //   return {
  //     'uid': uid,
  //     'name': name,
  //     'imageUrl': imageUrl,
  //     'department': department,
  //   };
  // }
}
