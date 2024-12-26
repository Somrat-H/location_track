import 'check_in_model.dart';

class AttedenceCheckOutModel {
  final String? title;
  final List<DailyCheckOutUpdate> dailyUpdate;

  AttedenceCheckOutModel({
    this.title,
    required this.dailyUpdate,
  });



  factory AttedenceCheckOutModel.fromMap(Map<String, dynamic> json) => AttedenceCheckOutModel(
    title: json["title"] as String,
        dailyUpdate: json["dailyUpdate"] == null
            ? []
            : List<DailyCheckOutUpdate>.from(
                json["dailyUpdate"]!.map((x) => DailyCheckOutUpdate.fromMap(x))),
      );
  // Map<String, dynamic> toMap() => {
  //       "title": title,
  //       "dailyUpdate": List<dynamic>.from(dailyUpdate!.map((x) => x.toMap())),
  //     };
}

class DailyCheckOutUpdate {
  final String? employeeId;
  final String? name;


  final Check? checkOut;

  DailyCheckOutUpdate({
    this.employeeId,
    this.name,
    this.checkOut,
  });

  factory DailyCheckOutUpdate.fromMap(Map<String, dynamic> json) => DailyCheckOutUpdate(
        employeeId: json["employeeId"],
        name: json["name"],

        checkOut:
            json["checkOut"] == null ? null : Check.fromMap(json["checkOut"]),
      );

}

