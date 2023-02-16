import 'package:chatgpt/data/constant.dart';
import 'package:chatgpt/view/chat_view/controllers/chat_view_controller.dart';
import 'package:chatgpt/view/flash_view/controller/flash_view_controller.dart';
import 'package:chatgpt/view/flash_view/flash_view.dart';
import 'package:chatgpt/view/setting_page/controller/setting_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatViewController(),
        ),
        ChangeNotifierProvider(
          create: (_) => FlashViewController(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingPageController(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter ChatBOT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            appBarTheme: AppBarTheme(
              color: cardColor,
            )),
        home: const FlashView(),
      ),
    );
  }
}
