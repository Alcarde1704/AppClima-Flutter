import 'package:app_clima/model.dart';

class ClimaModels {
  static  ClimaModels _singleton = ClimaModels._internal();
  static List<ClimaModel> _clima = [];

  factory ClimaModels() {
    return _singleton;
  }

  static List<ClimaModel>? get clima  => _clima;
  
  ClimaModels._internal();
}