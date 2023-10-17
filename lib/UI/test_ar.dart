import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    // Enable webview_flutter by enabling JavaScript
    WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web View Example'),
      ),
      body: const Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 32, 0),
        child: WebView(
          initialUrl: 'https://app.vectary.com/p/2LlilRiWoEYFHIpq6Qpxp5',
          javascriptMode: JavascriptMode.unrestricted, // Enable JavaScript
          gestureNavigationEnabled: true, // Enable navigation gestures
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WebViewScreen(),
  ));
}
