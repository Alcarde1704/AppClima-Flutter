

class ClimaModel {
  var cidade;
  var regiao;
  var temp_c_atual;
  var condicao;
  var url_image;

  ClimaModel({
    required this.cidade,
    required this.regiao,
    required this.temp_c_atual,
    required this.condicao,
    required this.url_image
    
  });

  factory ClimaModel.fromJson(Map<String, dynamic> json) => ClimaModel(
        cidade: json["location"]["name"],
        regiao: json["location"]["region"],
        temp_c_atual: json["current"]["temp_c"],
        condicao: json["current"]["condition"]["text"],
        url_image: json["current"]["condition"]["icon"]
        
      );
}
