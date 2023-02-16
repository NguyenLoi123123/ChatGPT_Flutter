import 'package:chatgpt/model/models_model.dart';

class App {
  static final App _instance = App._internal();

  factory App() {
    return _instance;
  }

  App._internal() {
    listModelsModel = [];
    listLanguageVoice = [];
    currentModel = _defaultModelsModel;
    currentLanguageVoice = 'en-US';
  }

  late List<ModelsModel> listModelsModel;
  late List<String> listLanguageVoice;
  late ModelsModel currentModel;
  late String currentLanguageVoice;
}

ModelsModel _defaultModelsModel = ModelsModel({
  'id': 'text-davinci-003',
  'created': 1669599635,
  'root': 'text-davinci-003',
});
