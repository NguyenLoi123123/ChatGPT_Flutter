import 'package:chatgpt/data/config_app/app.dart';
import 'package:chatgpt/data/config_app/config_audio.dart';
import 'package:chatgpt/model/models_model.dart';
import 'package:flutter/cupertino.dart';

class SettingPageController extends ChangeNotifier {
  final App _appData = App();

  final ConfigAudio _configAudio = ConfigAudio();

  List<ModelsModel> get listModelsModel => _appData.listModelsModel;

  List<String> get listLanguageVoice => _appData.listLanguageVoice;

  ModelsModel get currentModel => _appData.currentModel;

  String get currentLanguageVoice => _appData.currentLanguageVoice;

  set currentLanguageVoice(String newVoice) {
    _appData.currentLanguageVoice = newVoice;
    notifyListeners();
  }

  set currentModel(ModelsModel newModel) {
    _appData.currentModel = newModel;
    notifyListeners();
  }
}
