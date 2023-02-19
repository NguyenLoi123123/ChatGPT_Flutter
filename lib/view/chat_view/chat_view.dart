import 'dart:developer';

import 'package:chatgpt/data/constant.dart';
import 'package:chatgpt/model/chat_model.dart';
import 'package:chatgpt/view/chat_view/components/chat_view_loading.dart';
import 'package:chatgpt/view/chat_view/controllers/chat_view_controller.dart';
import 'package:chatgpt/view/resources/assets_manager.dart';
import 'package:chatgpt/view/resources/widget/chat_row.dart';
import 'package:chatgpt/view/resources/widget/snack_bar_error.dart';
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
      context.read<ChatViewController>().initAudio();
    });

    Future.delayed(const Duration(seconds: 5), () {
      _listScrollController
          .jumpTo(_listScrollController.position.maxScrollExtent);
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

  AppBar appBar() {
    return AppBar(
      elevation: 2,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(AssetsManager.openaiLogo),
      ),
      title: const Text("ChatGPT"),
      actions: [
        IconButton(
            onPressed: () async {
              Navigator.of(context).push(SettingPage()).whenComplete(() async {
                context.read<ChatViewController>().setting();
              });
            },
            icon: const Icon(
              Icons.settings,
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: ChatViewLoading(
            child: Column(
          children: [
            listChat(),
            if (context.read<ChatViewController>().isTyping) ...[
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
                          await sendMessageFCT();
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: "How can I help you",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await sendMessageFCT();
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
        )),
      ),
    );
  }

  Widget listChat() {
    List<ChatModel> list = context.watch<ChatViewController>().chatList;
    return Flexible(
      child: ListView.builder(
          addAutomaticKeepAlives: true,
          controller: _listScrollController,
          itemCount: list.length, //chatList.length,
          itemBuilder: (context, index) {
            List<ChatModel> chatList = list;
            return ChatRow(
              chatModel: chatList[index],
              onPressed: () {
                context.read<ChatViewController>().speak(chatList[index].msg);
              },
            );
          }),
    );
  }

  void scrollListToEND() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_listScrollController.hasClients) {
        _listScrollController
            .jumpTo(_listScrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> sendMessageFCT() async {
    final controller = context.read<ChatViewController>();
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
          .sendMessageAndGetAnswers(msg: currentQuestion)
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBarError(content: textError));
  }
}
