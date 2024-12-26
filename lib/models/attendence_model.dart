class AttedenceModel {
  final String? title;
  final List<DailyUpdate> dailyUpdate;

  AttedenceModel({
    this.title,
    required this.dailyUpdate,
  });

  // factory AttedenceModel.fromMap(Map<String, dynamic> json) {
  //   json["dailyUpdate"];
  //   print(json["dailyUpdate"]);
  //   return AttedenceModel(
  //     title: json["title"],
  //     dailyUpdate: json["dailyUpdate"] == null
  //         ? []
  //         : List<DailyUpdate>.from(json["dailyUpdate"].map((x) {
  //             print(x);
  //             return DailyUpdate.fromMap(x);
  //           })),
  //   );
  // }


  factory AttedenceModel.fromMap(Map<String, dynamic> json) => AttedenceModel(
    title: json["title"] as String,
        dailyUpdate: json["dailyUpdate"] == null
            ? []
            : List<DailyUpdate>.from(
                json["dailyUpdate"]!.map((x) => DailyUpdate.fromMap(x))),
      );
  Map<String, dynamic> toMap() => {
        "title": title,
        "dailyUpdate": List<dynamic>.from(dailyUpdate!.map((x) => x.toMap())),
      };
}

class DailyUpdate {
  final String? employeeId;
  final String? name;
  final List<double>? currentLocation;
  final Check? checkIn;
  final Check? checkOut;

  DailyUpdate({
    this.employeeId,
    this.name,
    this.currentLocation,
    this.checkIn,
    this.checkOut,
  });

  factory DailyUpdate.fromMap(Map<String, dynamic> json) => DailyUpdate(
        employeeId: json["employeeId"],
        name: json["name"],
        currentLocation: json["currentLocation"] == null
            ? []
            : List<double>.from(
                json["currentLocation"]!.map((x) => x?.toDouble())),
        checkIn:
            json["checkIn"] == null ? null : Check.fromMap(json["checkIn"]),
        checkOut:
            json["checkOut"] == null ? null : Check.fromMap(json["checkOut"]),
      );

  Map<String, dynamic> toMap() => {
        "employeeId": employeeId,
        "name": name,
        "currentLocation": currentLocation == null
            ? []
            : List<dynamic>.from(currentLocation!.map((x) => x)),
        "checkIn": checkIn?.toMap(),
        "checkOut": checkOut?.toMap(),
      };
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
            : List<double>.from(json["latlong"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toMap() => {
        "imageUrl": imageUrl,
        "time": time,
        "latlong":
            latlong == null ? [] : List<dynamic>.from(latlong!.map((x) => x)),
      };
}
