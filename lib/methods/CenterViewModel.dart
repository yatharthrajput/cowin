import 'dart:convert';

import 'package:cowin/Models/CenterModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CenterViewModel {
  static Future<CentresModel> getCentresByDistrict({@required String distId, @required String date}) async {
    String url = 'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict'
        '?district_id=${distId}&date=${date}';
    print(url);
    http.Response res = await http.get(url);
    switch (res.statusCode) {
      case 200:
        print(jsonDecode(res.body));

        CentresModel cm = CentresModel.fromJson(jsonDecode(res.body));

        print("length" + cm.centers.length.toString());
        return cm;
        // for (int i = 0; i < cm.centers.length; i++) centres.add(cm.centers[i]);
        break;
      case 401:
        print("Auth Error");
        break;
      case 500:
        print("Auth Error");
        break;
    }
  }

  static Future<CentresModel> getCentresByPin({@required String pin, @required String date}) async {
    String url =
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=${pin}&date=${date}';
    http.Response res = await http.get(url);
    switch (res.statusCode) {
      case 200:
        print(jsonDecode(res.body));

        CentresModel cm = CentresModel.fromJson(jsonDecode(res.body));

        print("length" + cm.centers.length.toString());
        return cm;
        // for (int i = 0; i < cm.centers.length; i++) centres.add(cm.centers[i]);
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
