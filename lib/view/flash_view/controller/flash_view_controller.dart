import 'package:chatgpt/data/api_service.dart';
import 'package:chatgpt/data/data_local.dart';
import 'package:chatgpt/model/models_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FlashViewController extends ChangeNotifier {
  late String _text;

  String get text => _text;

  DataLocalIpml dataLocalIpml = DataLocalIpml();

  final FlutterTts _flutterTts = FlutterTts();

  final ApiServiceIpml _api = ApiServiceIpml();

  set text(String newText) {
    _text = newText;
    notifyListeners();
  }



  Future<List<Object?>> loadLanguages() async => await _flutterTts.getLanguages;

   Future<List<ModelsModel?>> loadModelsModel() async => await _api.getModels();

}
