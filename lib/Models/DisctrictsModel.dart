import 'dart:convert';

StateDistModel disctrictsModelFromJson(String str) => StateDistModel.fromJson(json.decode(str));

class StateDistModel {
  StateDistModel({
    this.districts,
    this.ttl,
  });

  List<DistrictBlockModel> districts;
  int ttl;

  factory StateDistModel.fromJson(Map<String, dynamic> json) => StateDistModel(
        districts: List<DistrictBlockModel>.from(json["districts"].map((x) => DistrictBlockModel.fromJson(x))),
        ttl: json["ttl"],
      );
}

class DistrictBlockModel {
  DistrictBlockModel({
    this.districtId,
    this.districtName,
  });

  int districtId;
  String districtName;

  factory DistrictBlockModel.fromJson(Map<String, dynamic> json) => DistrictBlockModel(
        districtId: json["district_id"],
        districtName: json["district_name"],
      );
}
