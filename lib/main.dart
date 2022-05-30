import 'dart:convert';

import 'package:app_clima/model.dart';
import 'package:flutter/material.dart';
import 'package:app_clima/model_singleton.dart';

import 'api_service.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
   return _MyHomePageState();
  }
}



class _MyHomePageState extends State<MyHomePage> {
  final TextStyle style_title = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, fontWeight: FontWeight.bold);
  final TextStyle style_subtitle = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0, fontWeight: FontWeight.w300);
  final TextStyle style_graus = TextStyle(fontFamily: 'Montserrat', fontSize: 24.0, fontWeight: FontWeight.bold);
  final TextStyle style_condicao = TextStyle(fontFamily: 'Montserrat', fontSize: 12.0, fontWeight: FontWeight.w300);


  late List<ClimaModel>? _clima = [];

  @override
  void initState() {
    
    _clima = ClimaModels.clima;
    
    super.initState();
  }

  Future<void> _realoadList() async {
    List<ClimaModel>? _clima_subs = await Future.delayed(Duration(seconds: 1), () => ClimaModels.clima);

    setState(() {
      _clima = _clima_subs;
    });
  }

  Widget showList(){
    return ListView.builder(
                    itemCount: _clima!.length,
                    itemBuilder: (BuildContext context,int index) {
                      return rowIten(context, index);
                    });
  }

  Widget rowIten(context, index){
     return Card(
                        elevation: 5.0,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          child: Row(
                            
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                
                                children: <Widget>[
                                  Text(_clima![index].cidade, style: style_title),
                                  Text(_clima![index].regiao, style: style_subtitle)
                              ]
                              ),

                              Column(
                                children: <Widget>[
                                  Text(_clima![index].temp_c_atual.toString()+'ºC', style: style_graus, ),
                                  SizedBox(height: 40, child: Image.network('http:'+_clima![index].url_image),),
                                  Text(_clima![index].condicao, style: style_condicao,)
                              ]
                              )
                            ],
                          )

                        )
                          
                      );
  }
 

  @override
  Widget build(BuildContext context) {
    var src = '';
     
    
   
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima Hoje'),
        actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () async {
                await Navigator.of(context).push(
                     MaterialPageRoute(builder: (context) => Cadastro()));

                
              },
            )
          ],
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Center(
        
          child: Column(
         
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              
              
              
              Expanded(

                child:  RefreshIndicator(
                  onRefresh: _realoadList,
                  child:   showList()
                  
                  )
                 
                
              ),

              
                 
                
              
            
            ],
          ),
        ),
      )
      
    );
  }

}

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  



  @override
  State<Cadastro> createState() => CadastroHomePage();
}

class CadastroHomePage extends State<Cadastro> {
  TextEditingController location_controller = TextEditingController();

  
   

  

  @override
  Widget build(BuildContext context){

    late List<ClimaModel>? _climaModel = [];

    void _getData() async {
    _climaModel = (await ApiService().getClima(location_controller.text));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
      
      location_controller.text = '';
      ClimaModels.clima.add(_climaModel![0]);
      Navigator.of(context).pop();
      // Navigator.of(context).push(
      //                MaterialPageRoute(builder: (context) => MyHomePage(title: 'Clima Hoje',)));
    }
    )
    
    );
    
  }
    

    final location_field = TextField(
      controller: location_controller,
      maxLength: 30,
      decoration: InputDecoration(
          icon: Icon(Icons.location_city),
          contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          hintText: 'Local',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)), fillColor: Colors.white),
    );

     final adicionaClima = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.black26,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: (){
          
          
            _getData();
          
          
        },
        child: Text("Adicionar"),
      ),
     );


    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Novo Local"),
        
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Center(
        
          child: Column(
         
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: <Widget>[
              SizedBox(height: 90,child: location_field,),
              SizedBox(child: adicionaClima,)
            
            ],
          ),
        ),
      )
      
    );
  }
}

class ClimaModels {
  static  ClimaModels _singleton = ClimaModels._internal();
  static List<ClimaModel> _clima = [];

  factory ClimaModels() {
    return _singleton;
  }

  static List<ClimaModel> get clima  => _clima;
  
  ClimaModels._internal();
}

// ********
