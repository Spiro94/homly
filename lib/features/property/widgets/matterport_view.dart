// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MatterportViewWrapper extends StatelessWidget {
  const MatterportViewWrapper({required this.link, super.key});

  final String link;

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MatterPortViewWeb(link: link)
        : MatterPortViewMobile(link: link);
  }
}

class MatterPortViewWeb extends StatelessWidget {
  const MatterPortViewWeb({required this.link, super.key});
  final String link;

  @override
  Widget build(BuildContext context) {
    //ignore: undefined_prefixed_name, avoid_dynamic_calls
    ui.platformViewRegistry.registerViewFactory(
      link,
      (int viewId) => IFrameElement()
        ..style.height = '100%'
        ..style.width = '100%'
        ..src = link
        ..allowFullscreen = false
        ..id = link
        ..style.border = 'none',
    );
    return HtmlElementView(viewType: link);
  }
}

class MatterPortViewMobile extends StatefulWidget {
  const MatterPortViewMobile({required this.link, super.key});

  final String link;

  @override
  State<MatterPortViewMobile> createState() => _MatterPortViewMobileState();
}

class _MatterPortViewMobileState extends State<MatterPortViewMobile> {
  late final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(
      Uri.parse(
        '<html><body><iframe src="${widget.link}" frameborder="0" allowfullscreen allow="xr-spatial-tracking"></iframe></body></html>',
      ),
    );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.8,
      width: size.width,
      child: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
