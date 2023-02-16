import 'dart:developer';

import 'package:chatgpt/data/api_service.dart';
import 'package:chatgpt/data/config_app/app.dart';
import 'package:chatgpt/data/config_app/config_audio.dart';
import 'package:chatgpt/data/config_app/info_device.dart';
import 'package:chatgpt/model/chat_model.dart';
import 'package:chatgpt/model/models_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatViewController
    with ChangeNotifier, ChatViewControllerInput, ChatViewControllerOutput {
  final ApiServiceIpml _api = ApiServiceIpml();
  final List<ChatModel> _chatList = [];
  bool _isTyping = false;

  final App _appData = App();

  final ConfigAudio _configAudio = ConfigAudio();

  final InfoDevice _infoDevice = InfoDevice();

  @override
  void addMessage({required String msg}) {
    _chatList.add(ChatModel({'msg': msg, 'chatIndex': 0}));
    _isTyping = true;
    notifyListeners();
  }

  @override
  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    _chatList.addAll(await _api.sendMessage(
      message: msg,
      modelId: chosenModelId,
    ));

    notifyListeners();
  }

  @override
  ModelsModel get currentModel => _appData.currentModel;

  @override
  List<ChatModel> get chatList => _chatList;

  @override
  List<ModelsModel> get modelsList => _appData.listModelsModel;

  @override
  bool get isTyping => _isTyping;

  @override
  set isTyping(bool statusTyping) {
    _isTyping = statusTyping;
    notifyListeners();
  }

  ///Handle Audio
  final FlutterTts _flutterTts = FlutterTts();

  StatusAudio _statusAudio = StatusAudio.stopped;

  StatusAudio get statusAudio => _statusAudio;

  void initAudio() async {
    _setAwaitOptions();
    if (_infoDevice.isAndroid) {
      setting();
    }
  }

  void setting() async {
    await _flutterTts.setVolume(_configAudio.volumn);
    await _flutterTts.setSpeechRate(_configAudio.rate);
    await _flutterTts.setPitch(_configAudio.pitch);
    await _flutterTts.setLanguage(_appData.currentLanguageVoice);
  }

  Future<void> speak(String voiceText) async {
    log('Ngôn ngữ nói: ${_appData.currentLanguageVoice}');
    await _flutterTts.speak(voiceText);
  }

  Future<void> stop() async {
    var result = await _flutterTts.stop();
    if (result == 1) {
      _statusAudio = StatusAudio.stopped;
      notifyListeners();
    }
  }

  Future<void> pause() async {
    var result = await _flutterTts.pause();
    if (result == 1) {
      _statusAudio = StatusAudio.paused;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }

  Future<void> _setAwaitOptions() async {
    return await _flutterTts.awaitSpeakCompletion(true);
  }
}

abstract class ChatViewControllerInput {
  void addMessage({required String msg});

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId});

  set isTyping(bool statusTyping);
}

abstract class ChatViewControllerOutput {
  List<ChatModel> get chatList;
  ModelsModel get currentModel;

  List<ModelsModel> get modelsList;
  bool get isTyping;
}
