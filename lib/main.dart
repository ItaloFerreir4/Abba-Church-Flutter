import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abba Church Marlboro',
      theme: ThemeData(
        primaryColor: const Color(0xFF4D37),
      ),
      home: WebViewPage(),
    );
  }
}

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            Uri url = Uri.parse(request.url);

            // Verifica se o link não pertence ao site principal
            if (!url.host.contains('newabba.us')) {
              // Verifica se pode abrir o link no navegador externo
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.platformDefault);
              } else {
                print('Não foi possível abrir o link: ${url.toString()}');
              }
              return NavigationDecision.prevent; // Impede a WebView de carregar o link externo
            }

            return NavigationDecision.navigate; // Permite que a WebView continue a navegação interna
          },
        ),
      )
      ..loadRequest(Uri.parse('https://newabba.us/app/home'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}