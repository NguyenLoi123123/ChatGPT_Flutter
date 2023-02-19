import 'dart:convert';

import 'package:chatgpt/model/chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String keyPrefsApiKey = 'ApiKey';
const String keyPrefsListVoice = 'listVoice';
const String keyPrefsChat = 'chat';

class DataLocalIpml implements _DataLocal {
  @override
  Future<List<String>> get listVoice async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyPrefsListVoice) ?? [];
  }

  @override
  Future<void> saveListVoice(List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(keyPrefsListVoice, list);
  }

  @override
  Future<String?> get apiKey async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyPrefsApiKey);
  }

  @override
  Future<void> saveApiKey(String apiKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyPrefsApiKey, apiKey);
  }

  @override
  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Future<List<ChatModel>> listChat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(keyPrefsChat) != null) {
      List<dynamic> list = jsonDecode(prefs.getString(keyPrefsChat)!);
      return list.map((e) => ChatModel(e)).toList();
    }
    return [];
  }



  @override
  Future<void> saveChat(List<ChatModel> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, Object?>> listObject = list.map((e) => e.data).toList();
    String listObjectEncode = jsonEncode(listObject);
    await prefs.setString(keyPrefsChat, listObjectEncode);
  }
  
  @override
  Future<void> clearDataChat() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(keyPrefsChat);
  }
}

abstract class _DataLocal {
  Future<List<String>> get listVoice;
  Future<void> saveListVoice(List<String> list);
  Future<String?> get apiKey;
  Future<void> saveApiKey(String apiKey);
  Future<void> clear();
  Future<List<ChatModel>?> listChat();
  Future<void> saveChat(List<ChatModel> list);
  Future<void> clearDataChat();
}
