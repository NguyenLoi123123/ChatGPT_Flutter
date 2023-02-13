import 'package:chatgpt/data/constant.dart';
import 'package:chatgpt/model/chat_model.dart';
import 'package:chatgpt/view/resources/assets_manager.dart';
import 'package:flutter/material.dart';

import 'text_widget.dart';

class ChatRow extends StatelessWidget {
  const ChatRow({super.key, required this.chatModel});

  final ChatModel chatModel;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: chatModel.isUserChat ? scaffoldBackgroundColor : cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              chatModel.isUserChat
                  ? AssetsManager.userImage
                  : AssetsManager.botImage,
              height: 30,
              width: 30,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: TextWidget(
              label: chatModel.msg,
            )),
            chatModel.isUserChat
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(
                        Icons.thumb_up_alt_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.thumb_down_alt_outlined,
                        color: Colors.white,
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
