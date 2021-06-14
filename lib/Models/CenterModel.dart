// To parse this JSON data, do
//
//     final centresModel = centresModelFromJson(jsonString);

import 'dart:convert';

CentresModel centresModelFromJson(String str) => CentresModel.fromJson(json.decode(str));

class CentresModel {
  CentresModel({
    this.centers,
  });

  List<CenterBlockModel> centers;

  factory CentresModel.fromJson(Map<String, dynamic> json) => CentresModel(
        centers: List<CenterBlockModel>.from(json["centers"].map((x) => CenterBlockModel.fromJson(x))),
      );
}

class CenterBlockModel {
  CenterBlockModel({
    this.centerId,
    this.name,
    this.address,
    // this.stateName,
    // this.districtName,
    // this.blockName,
    // this.pincode,
    // this.lat,
    // this.long,
    // this.from,
    // this.to,
    // this.feeType,
    this.sessions,
  });

  dynamic centerId;
  String name;
  String address;
  // String stateName;
  // String districtName;
  // String blockName;
  // int pincode;
  // int lat;
  // int long;
  // String from;
  // String to;
  // String feeType;
  List<Session> sessions;

  factory CenterBlockModel.fromJson(Map<String, dynamic> json) => CenterBlockModel(
        centerId: json["center_id"],
        name: json["name"],
        address: json["address"],
        // stateName: json["state_name"],
        // districtName: json["district_name"],
        // blockName: json["block_name"],
        // pincode: json["pincode"],
        // lat: json["lat"],
        // long: json["long"],
        // from: json["from"],
        // to: json["to"],
        // feeType: json["fee_type"],
        sessions: List<Session>.from(json["sessions"].map((x) => Session.fromJson(x))),
      );
}

class Session {
  Session({
    this.sessionId,
    // this.date,
    this.availableCapacity,
    this.minAgeLimit,
    this.vaccine,
    this.slots,
  });

  String sessionId;
  // String date;
  dynamic availableCapacity;
  dynamic minAgeLimit;
  String vaccine;
  List<String> slots;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        sessionId: json["session_id"],
        // date: json["date"],
        availableCapacity: json["available_capacity"],
        minAgeLimit: json["min_age_limit"],
        vaccine: json["vaccine"],
        slots: List<String>.from(json["slots"].map((x) => x)),
      );
}
