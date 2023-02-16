import 'package:chatgpt/data/config_app/app.dart';
import 'package:chatgpt/model/models_model.dart';
import 'package:chatgpt/view/chat_view/chat_view.dart';
import 'package:chatgpt/view/flash_view/controller/flash_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashView extends StatefulWidget {
  const FlashView({super.key});

  @override
  State<FlashView> createState() => _FlashViewState();
}

class _FlashViewState extends State<FlashView> {
  @override
  void initState() {
    super.initState();
  }

  void saveListVoiceOption(
      {required List list, required FlashViewController controller}) {
    List<String> newData = list.map((e) => e.toString()).toList();
    controller.dataLocalIpml.saveListVoice(newData);

    App data = App();
    controller.dataLocalIpml.listVoice
        .then((value) => data.listLanguageVoice = value);
  }

  void saveModelsModel({required List<ModelsModel> list}) {
    App data = App();
    data.listModelsModel = list;
  }

  void loadData(dynamic snapshot, {required FlashViewController controller}) {
    saveListVoiceOption(list: snapshot.data[0], controller: controller);
    saveModelsModel(list: snapshot.data[1]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const ChatView()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FlashViewController>(context);
    return Scaffold(
      body: FutureBuilder<dynamic>(
          future: Future.wait([
            controller.loadLanguages(),
            controller.loadModelsModel(),
          ]),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return baseLoading('Đang tải');
            } else if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              loadData(snapshot, controller: controller);
              return baseLoading('Tải hoàn tất');
            }
            return baseLoading('Có lỗi xãy ra');
          })),
    );
  }

  Widget baseLoading(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(text),
        ],
      ),
    );
  }
}
