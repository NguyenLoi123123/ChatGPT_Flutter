import 'dart:developer';

import 'package:chatgpt/data/constant.dart';
import 'package:chatgpt/model/chat_model.dart';
import 'package:chatgpt/view/chat_view/controllers/chat_view_controller.dart';
import 'package:chatgpt/view/resources/assets_manager.dart';
import 'package:chatgpt/view/resources/widget/chat_row.dart';
import 'package:chatgpt/view/resources/widget/text_widget.dart';
import 'package:chatgpt/view/setting_page/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatViewController>(context, listen: false).initAudio();
    });
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ChatViewController>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        title: const Text("ChatGPT"),
        actions: [
          IconButton(
              onPressed: (){
                 Navigator.of(context).push(SettingPage()).whenComplete(() {
                  controller.setting();
                  });
              },
                 
              icon: const Icon(
                Icons.settings,
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  controller: _listScrollController,
                  itemCount: controller.chatList.length, //chatList.length,
                  itemBuilder: (context, index) {
                    List<ChatModel> chatList = controller.chatList;
                    return ChatRow(
                      chatModel: chatList[index],
                      onPressed: () {
                        controller.speak(chatList[index].msg);
                      },
                    );
                  }),
            ),
            if (controller.isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageFCT(controller: controller);
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: "How can I help you",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await sendMessageFCT(controller: controller);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEND() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _listScrollController
          .jumpTo(_listScrollController.position.maxScrollExtent);
    });
  }

  Future<void> sendMessageFCT({
    required ChatViewController controller,
  }) async {
    if (textEditingController.text.isEmpty) {
      showSnackBarError('Please type a message');
      return;
    }
    try {
      scrollListToEND();
      String currentQuestion = textEditingController.text;
      textEditingController.clear();
      focusNode.unfocus();
      controller.addMessage(msg: currentQuestion);

      await controller
          .sendMessageAndGetAnswers(
              msg: currentQuestion, chosenModelId: controller.currentModel.id)
          .whenComplete(() {
        scrollListToEND();
        controller.isTyping = false;
      });
    } catch (error) {
      log("error $error");
      showSnackBarError('An error has occurred: $error');
    }
  }

  void showSnackBarError(String textError) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: TextWidget(
        label: textError.toString(),
      ),
      backgroundColor: Colors.red,
    ));
  }
}
