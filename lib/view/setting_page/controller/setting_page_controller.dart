import 'package:chatgpt/data/config_app/setting_data.dart';
import 'package:chatgpt/data/config_app/config_audio.dart';
import 'package:chatgpt/data/prefs/data_local.dart';
import 'package:chatgpt/model/language_voice_model.dart';
import 'package:chatgpt/model/models_model.dart';
import 'package:flutter/cupertino.dart';

class SettingPageController extends ChangeNotifier {
  final SettingData _setting = SettingData();

  final ConfigAudio _configAudio = ConfigAudio();

  List<ModelsModel> get listModelsModel => _setting.listModelsModel;

  List<LanguageVoiceModel> get listLanguageVoice => _setting.listLanguageVoice;

  ModelsModel get currentModel => _setting.currentModel;

  LanguageVoiceModel get currentLanguageVoice => _setting.currentLanguageVoice;

  set currentLanguageVoice(LanguageVoiceModel newVoice) {
    _setting.currentLanguageVoice = newVoice;
  }

  set currentModel(ModelsModel newModel) {
    _setting.currentModel = newModel;
  }
  

  //----------------Setting audio-----------------//
  double get pitch => _configAudio.pitch;

  set pitch(double newValue) {
    _configAudio.pitch = newValue;
  }

  double get volumn => _configAudio.volumn;

  set volumn(double newValue) {
    _configAudio.volumn = newValue;
  }

  double get rate => _configAudio.rate;

  set rate(double newValue) {
    _configAudio.rate = newValue;
  }

  //-------Status autoReponse sound-----//
  bool get autoChatReponse => _setting.isAutoChatReponse;

  set autoChatReponse(bool newValue) {
    _setting.isAutoChatReponse = newValue;
  }

  ///Logout
  Future<void> logout()  {
    DataLocalIpml dataLocal = DataLocalIpml();
   return  dataLocal.clear();
  }


}
