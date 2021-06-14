import 'dart:convert';

import 'package:cowin/Models/IndStateModel.dart';
import 'package:http/http.dart' as http;

class StateViewModel {
  static List<StatesModel> statesModel = [];
 
  static Future getStates() async {
    statesModel=[];
    http.Response res = await http.get('https://cdn-api.co-vin.in/api/v2/admin/location/states');
    print(res.body);
    switch (res.statusCode) {
      case 200:
        IndStatesModel isk = IndStatesModel.fromJson(jsonDecode(res.body));
        for (int i = 0; i < isk.states.length; i++) statesModel.add(isk.states[i]);
        break;
      case 401:
        print("Auth Error");
        break;
      case 500:
        print("Auth Error");
        break;
    }
  }
}
