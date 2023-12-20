import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

 @override

 State<ChatbotPage> createState() => _ChatbotPageState();

}


class _ChatbotPageState extends State<ChatbotPage> {
  late final WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://mediafiles.botpress.cloud/59493a47-de28-4d01-b89c-a9afa8f9871f/webchat/bot.html'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flexy'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}