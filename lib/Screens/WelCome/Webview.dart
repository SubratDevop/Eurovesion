import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class WebviewPage extends StatefulWidget {
  const WebviewPage({ Key? key }) : super(key: key);

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: "https://eurovesionsystems.com/",
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}