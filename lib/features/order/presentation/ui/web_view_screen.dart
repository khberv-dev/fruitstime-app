import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class WebViewScreen extends StatefulWidget {
  static const path = '/webview';

  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: SvgPicture.asset('assets/icons/arrow_left.svg'),
                  ),
                ],
              ),
            ),
            if (_progress < 1.0)
              LinearProgressIndicator(
                value: _progress,
                minHeight: 2,
                backgroundColor: Colors.transparent,
              ),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                initialSettings: InAppWebViewSettings(
                  useShouldOverrideUrlLoading: false,
                  mediaPlaybackRequiresUserGesture: false,
                ),
                onProgressChanged: (_, progress) {
                  setState(() => _progress = progress / 100);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
