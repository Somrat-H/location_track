class AttedenceCheckInModel {
  final String? title;
  final List<DailyCheckInUpdate> dailyUpdate;

  AttedenceCheckInModel({
    this.title,
    required this.dailyUpdate,
  });

  factory AttedenceCheckInModel.fromMap(Map<String, dynamic> json) =>
      AttedenceCheckInModel(
        title: json["title"] as String,
        dailyUpdate: json["dailyUpdate"] == null
            ? []
            : List<DailyCheckInUpdate>.from(
                json["dailyUpdate"]!.map((x) => DailyCheckInUpdate.fromMap(x))),
      );
  // Map<String, dynamic> toMap() => {
  //       "title": title,
  //       "dailyUpdate": List<dynamic>.from(dailyUpdate!.map((x) => x.toMap())),
  //     };
}

class DailyCheckInUpdate {
  final String? employeeId;
  final String? name;

  final Check? checkIn;

  DailyCheckInUpdate({
    this.employeeId,
    this.name,
    this.checkIn,
  });

  factory DailyCheckInUpdate.fromMap(Map<String, dynamic> json) =>
      DailyCheckInUpdate(
        employeeId: json["employeeId"],
        name: json["name"],
        checkIn:
            json["checkIn"] == null ? null : Check.fromMap(json["checkIn"]),
      );
}

class Check {
  final String? imageUrl;
  final String? time;
  final List<double>? latlong;

  Check({
    this.imageUrl,
    this.time,
    this.latlong,
  });

  factory Check.fromMap(Map<String, dynamic> json) => Check(
      imageUrl: json["imageUrl"],
      time: json["time"],
      latlong: json["latlong"] == null
          ? []
          : [json["latlong"][0], json["latlong"][1]]
      // : List<double>.from(json["latlong"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toMap() => {
        "imageUrl": imageUrl,
        "time": time,
        "latlong":
            latlong == null ? [] : List<dynamic>.from(latlong!.map((x) => x)),
      };
}
