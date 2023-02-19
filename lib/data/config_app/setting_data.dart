import 'package:chatgpt/model/language_voice_model.dart';
import 'package:chatgpt/model/models_model.dart';

class SettingData {
  static final SettingData _instance = SettingData._internal();

  factory SettingData() {
    return _instance;
  }

  SettingData._internal() {
    listModelsModel = [];
    listLanguageVoice = _defaultListLanguageVoice;
    currentModel = _defaultModelsModel;
    currentLanguageVoice = _defaultListLanguageVoice.last;
    isAutoChatReponse = false;
  }

  late List<ModelsModel> listModelsModel;
  late List<LanguageVoiceModel> listLanguageVoice;
  late ModelsModel currentModel;
  late LanguageVoiceModel currentLanguageVoice;
  late bool isAutoChatReponse;

}

ModelsModel _defaultModelsModel = ModelsModel({
  'id': 'text-davinci-003',
  'created': 1669599635,
  'root': 'text-davinci-003',
});

List<LanguageVoiceModel> _defaultListLanguageVoice = [
  {'name': 'vi-VN-language', 'locale': 'vi-VN','displayName': 'Tiếng Việt'},
  {'name': 'en-us-x-tpf-local', 'locale': 'en-US', 'displayName': 'Tiếng Mỹ 1'},
  {'name': 'en-us-x-sfg-network', 'locale': 'en-US', 'displayName': 'Tiếng Mỹ 2'},
  {'name': 'en-us-x-tpd-network', 'locale': 'en-US', 'displayName': 'Tiếng Mỹ 3'},
  {'name': 'en-us-x-tpc-network', 'locale': 'en-US', 'displayName': 'Tiếng Mỹ 4'},
  {'name': 'en-gb-x-gba-local','locale': 'en-GB', 'displayName': 'Tiếng Anh 1'},
  {'name': 'en-gb-x-gbb-network', 'locale': 'en-GB', 'displayName': 'Tiếng Anh 2'}, 
  {'name': 'en-gb-x-rjs-local', 'locale': 'en-GB', 'displayName': 'Tiếng Anh 3'}, 
  {'name': 'en-gb-x-gbg-local', 'locale': 'en-GB', 'displayName': 'Tiếng Anh 4'}, 

].map((e) => LanguageVoiceModel(e)).toList();
