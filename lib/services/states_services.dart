import 'dart:convert';

import 'package:covid_app_flutter/model/WorldStateModel.dart';
import 'package:covid_app_flutter/utils/app_urls.dart';
import 'package:http/http.dart' as http;

class StatesServices {

  Future<WorldStateModel> getWorldStates() async {
    final response = await http.get(Uri.parse(AppUrl.worldStateAPI));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return WorldStateModel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  Future<List<dynamic>> getCountries() async {
    var data;
    final response = await http.get(Uri.parse(AppUrl.countriesList));

    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());
      return data;
    } else {
      throw Exception('Error');
    }
  }
}
