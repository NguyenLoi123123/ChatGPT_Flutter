import 'package:chatgpt/data/api_service.dart';
import 'package:chatgpt/model/chat_model.dart';
import 'package:chatgpt/model/models_model.dart';
import 'package:flutter/cupertino.dart';

ModelsModel defaultModelsModel = ModelsModel({
  'id': 'text-davinci-003',
  'created': 1669599635,
  'root': 'text-davinci-003',
});

class ChatViewController
    with ChangeNotifier, ChatViewControllerInput, ChatViewControllerOutput {
  final ApiServiceIpml _api = ApiServiceIpml();
  final List<ChatModel> _chatList = [];
  ModelsModel _currentModel = defaultModelsModel;
  List<ModelsModel> _modelsList = [];
  bool _isTyping = false;

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
  ModelsModel get currentModel => _currentModel;

  @override
  List<ChatModel> get chatList => _chatList;

  @override
  List<ModelsModel> get modelsList => _modelsList;

  @override
  set currentModel(ModelsModel newModel) {
    _currentModel = newModel;
  }

  @override
  Future<List<ModelsModel>> loadAllModels() async {
    _modelsList = await _api.getModels();
    return _modelsList;
  }

  @override
  bool get isTyping => _isTyping;

  @override
  set isTyping(bool statusTyping) {
    _isTyping = statusTyping;
    notifyListeners();
  }

  @override
  set modelsList(List<ModelsModel> list) {
    _modelsList = list;
  }
}

abstract class ChatViewControllerInput {
  void addMessage({required String msg});

  Future<List<ModelsModel>> loadAllModels();

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId});

  set currentModel(ModelsModel newModel);

  set modelsList(List<ModelsModel> list);

  set isTyping(bool statusTyping);
}

abstract class ChatViewControllerOutput {
  List<ChatModel> get chatList;
  ModelsModel get currentModel;

  List<ModelsModel> get modelsList;
  bool get isTyping;
}
