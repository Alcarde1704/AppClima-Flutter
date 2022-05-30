import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'constant.dart';
import 'model.dart';

class ApiService {
 



  Future<List<ClimaModel>?> getClima(String localizacao) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + localizacao + '&aqi=no&lang=pt');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        ClimaModel clima = ClimaModel.fromJson(json.decode(response.body));

        var _model = [clima];
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
