import 'dart:convert';

IndStatesModel statesModelFromJson(String str) => IndStatesModel.fromJson(json.decode(str));

class IndStatesModel {
  IndStatesModel({
    this.states,
  });

  List<StatesModel> states;
  factory IndStatesModel.fromJson(Map<String, dynamic> json) => IndStatesModel(
        states: List<StatesModel>.from(json["states"].map((x) => StatesModel.fromJson(x))),
      );
}

class StatesModel {
  StatesModel({
    this.stateId,
    this.stateName,
  });

  int stateId;
  String stateName;

  factory StatesModel.fromJson(Map<String, dynamic> json) => StatesModel(
        stateId: json["state_id"],
        stateName: json["state_name"],
      );
}
