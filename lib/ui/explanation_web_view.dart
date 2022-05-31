import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExplanationWebView extends StatelessWidget {
  final String url;
  final String title;

  const ExplanationWebView({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explanation of $title',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: url,
      ),
    );
  }
}
