import 'package:shared_preferences/shared_preferences.dart';

const String keyPrefsListVoiceStr = 'listVoiceStr';
const String keyPrefsListModelsModelStr = 'listModelsModel';

class DataLocalIpml implements _DataLocal {
  @override
  Future<List<String>> get listVoice async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyPrefsListVoiceStr) ?? [];
  }

  @override
  Future<void> saveListVoice(List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(keyPrefsListVoiceStr, list);
  }
}

abstract class _DataLocal {
  Future<List<String>> get listVoice;
  Future<void> saveListVoice(List<String> list);
}
