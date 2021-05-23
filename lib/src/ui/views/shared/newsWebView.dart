import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kisan_app/src/ui/widgets/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebViewScreen extends StatelessWidget {
  final String url;
  NewsWebViewScreen({this.url});
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, "News Web View"),
      backgroundColor: Colors.greenAccent[100],
      body: Container(
        child: WebView(
          initialUrl: url,
          onWebViewCreated: ((WebViewController webViewController) {
            _completer.complete(webViewController);
          }),
        ),
      ),
    );
  }
}
