import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgpt/data/api_consts.dart';
import 'package:chatgpt/data/methods.dart';
import 'package:chatgpt/model/chat_model.dart';
import 'package:chatgpt/model/models_model.dart';
import 'package:http/http.dart' as http;

abstract class ApiService {
  Future<List<ModelsModel>> getModels();
  Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId});
}

class ApiServiceIpml extends ApiService {
  @override
  Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/models"),
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']["message"]);
      }

      List<Map<String, Object?>> data = Methods.getList(jsonResponse, 'data');

      return data.map((e) => ModelsModel(e)).toList();
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  @override
  Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      log("modelId $modelId");
      var response = await http.post(
        Uri.parse('$baseUrl/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": message,
            "max_tokens": 150,
          },
        ),
      );

      Map json = jsonDecode(response.body);
      if (json['error'] != null) {
        throw HttpException(json['error']["message"]);
      }

      List<ChatModel> chatList = [];

      Map<String, Object?> data = Methods.getList(json, 'choices').first;
      String msg = Methods.getString(data, 'text');
      //Biên dịch để có thể đọc bằng tiếng việt
      String msgUTF8 = utf8.decode(msg.runes.toList()).toString().trim();

      chatList.add(ChatModel({'msg': msgUTF8, 'chatIndex': 1}));

      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
