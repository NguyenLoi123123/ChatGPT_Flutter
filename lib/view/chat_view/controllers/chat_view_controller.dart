import 'dart:math';

import 'package:chatgpt/data/api_service.dart';
import 'package:chatgpt/data/config_app/setting_data.dart';
import 'package:chatgpt/data/config_app/config_audio.dart';
import 'package:chatgpt/data/config_app/info_device.dart';
import 'package:chatgpt/data/prefs/data_local.dart';
import 'package:chatgpt/model/chat_model.dart';
import 'package:chatgpt/model/models_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatViewController
    with ChangeNotifier, ChatViewControllerInput, ChatViewControllerOutput {
  final List<ChatModel> _chatList = [];
  bool _isTyping = false;

  final SettingData _setting = SettingData();

  final ConfigAudio _configAudio = ConfigAudio();

  final InfoDevice _infoDevice = InfoDevice();

  final ApiServiceIpml _api = ApiServiceIpml();

  final DataLocalIpml _localPrefs = DataLocalIpml();

  @override
  void addMessage({required String msg}) {
    _chatList.add(ChatModel({'msg': msg, 'chatIndex': 0}));
    _isTyping = true;
    notifyListeners();
  }

  set chatList(List<ChatModel> list) {
    _chatList.addAll(list);
    notifyListeners();
  }

  @override
  Future<List<ModelsModel>> loadModelsModel() async => await _api.getModels();

  set listModelsModel(List<ModelsModel> list) {
    _setting.listModelsModel = list;
  }

  @override
  Future<void> sendMessageAndGetAnswers({required String msg}) async {
    ChatModel gptReponse = await _api.sendMessage(
      message: msg,
    );
    _chatList.add(gptReponse);

    await _localPrefs.saveChat(_chatList);
    List<ChatModel>? li = await _localPrefs.listChat();
    debugPrint(li.toString());
    //In the case, auto turn on audio
    if (_setting.isAutoChatReponse) {
      speak(gptReponse.msg);
    }
    notifyListeners();
  }

  @override
  Future<List<ChatModel>> loadLocalChat() {
    return _localPrefs.listChat();
  }

  @override
  List<ChatModel> get chatList => _chatList;

  @override
  List<ModelsModel> get modelsList => _setting.listModelsModel;

  @override
  bool get isTyping => _isTyping;

  @override
  set isTyping(bool statusTyping) {
    _isTyping = statusTyping;
    notifyListeners();
  }

  ///Handle Audio
  final FlutterTts _flutterTts = FlutterTts();

  StatusAudio _statusAudio = StatusAudio.continued;

  // StatusAudio get statusAudio => _statusAudio;

  void initAudio() async {
    _setAwaitOptions();
    if (_infoDevice.isAndroid) {
      setting();
    }
  }

  void setting() async {
    await _flutterTts.setVolume(_configAudio.volumn);
    await _flutterTts.setSpeechRate(_configAudio.rate);
    double convertPitch = max(0.5, _configAudio.pitch / 2);
    await _flutterTts.setPitch(convertPitch);
    await _flutterTts
        .setVoice(_setting.currentLanguageVoice.data as Map<String, String>);
  }

  Future<void> speak(String voiceText) async {
    if (_statusAudio != StatusAudio.stopped) {
      await stop();
    } else {
      _statusAudio = StatusAudio.playing;
      await _flutterTts.speak(voiceText);
    }
  }

  Future<void> stop() async {
    _statusAudio = StatusAudio.stopped;
    await _flutterTts.stop();
  }

  Future<void> pause() async {
    _statusAudio = StatusAudio.paused;
    await _flutterTts.pause();
  }

  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }

  Future<void> _setAwaitOptions() async {
    return await _flutterTts.awaitSpeakCompletion(true);
  }

  @override
  Future<void> clearChat() async {
    _localPrefs.clearDataChat();
    _chatList.clear();
    notifyListeners();
  }
}

abstract class ChatViewControllerInput {
  void addMessage({required String msg});

  Future<void> sendMessageAndGetAnswers({required String msg});

  set isTyping(bool statusTyping);

  Future<List<ModelsModel>> loadModelsModel();

  Future<List<ChatModel>> loadLocalChat();

  Future<void> clearChat();
}

abstract class ChatViewControllerOutput {
  List<ChatModel> get chatList;

  List<ModelsModel> get modelsList;
  bool get isTyping;
}
