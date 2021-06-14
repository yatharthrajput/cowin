import 'dart:convert';

import 'package:cowin/Models/DisctrictsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DistrictViewModel {
  static List<DistrictBlockModel> districts = [];

  static Future getDistricts({@required String id}) async {
    districts = [];
    String url =
        'https://cdn-api.co-vin.in/api/v2/admin/location/districts/${id}}';
    http.Response res = await http.get(url);
    print(res.body);
    switch (res.statusCode) {
      case 200:
        StateDistModel sdm = StateDistModel.fromJson(jsonDecode(res.body));
        for (int i = 0; i < sdm.districts.length; i++)
          districts.add(sdm.districts[i]);
        return;
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
