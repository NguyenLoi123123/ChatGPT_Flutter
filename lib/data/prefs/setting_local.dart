import 'dart:convert';

import 'package:chatgpt/model/language_speak_model.dart';
import 'package:chatgpt/model/language_listen_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyPrefsVoiceListen = 'voiceListen';
const String _keyPrefsStatusReponse = 'statusReponse';
const String _keyPrefsVoiceSpeak = 'languageVoiceSpeak';

class SettingLocal implements _SettingLocal {
  @override
  Future<bool?> get isAutoChatReponse async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyPrefsStatusReponse);
  }

  @override
  Future<LanguageListenModel?> get languageListen async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_keyPrefsVoiceListen)) {
      String str = prefs.getString(_keyPrefsVoiceListen)!;
      Map<String, Object> data = jsonDecode(str);
      return LanguageListenModel(data);
    }
    return null;
  }

  @override
  Future<void> saveIsAutoChatReponse(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPrefsStatusReponse, value);
  }

  @override
  Future<void> saveLanguageListen(LanguageListenModel voice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String listObjectEncode = jsonEncode(voice.data);
    await prefs.setString(_keyPrefsVoiceListen, listObjectEncode);
  }

  @override
  Future<void> saveLanguageSpeak(LanguageSpeakModel voice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String listObjectEncode = jsonEncode(voice.data);
    await prefs.setString(_keyPrefsVoiceSpeak, listObjectEncode);
  }

  @override
  Future<LanguageSpeakModel?> get languageSpeak async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_keyPrefsVoiceSpeak)) {
      String str = prefs.getString(_keyPrefsVoiceSpeak)!;
      Map<String, Object> data = jsonDecode(str);
      return LanguageSpeakModel(data);
    }
    return null;
  }
}

abstract class _SettingLocal {
  ///L???y tr???ng th??i
  Future<bool?> get isAutoChatReponse;

  ///L??u tr???ng th??i ph???n h???i
  Future<void> saveIsAutoChatReponse(bool value);

  ///L???y trang Thai isGiongVN
  Future<LanguageSpeakModel?> get languageSpeak;

  ///L??u tr???ng th??i ph???n h???i
  Future<void> saveLanguageSpeak(LanguageSpeakModel voice);

  ///L???y ng??n ng???
  Future<LanguageListenModel?> get languageListen;

  ///L??u ng??n ng???
  Future<void> saveLanguageListen(LanguageListenModel voice);
}
