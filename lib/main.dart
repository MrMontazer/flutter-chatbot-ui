import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:chatbot_ui/chat/view/chat_page.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const StartApp());
}

class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isSystemDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ThemeProvider(
      initTheme: isSystemDarkMode
        ? ThemeData.dark()
        : ThemeData.light(),
      child: const MaterialApp(
        title: "ChatBot Ui",
        home: ChatPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
