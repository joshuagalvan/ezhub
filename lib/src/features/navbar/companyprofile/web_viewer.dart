import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:simone/src/features/navbar/companyinformation/companyprofile/pdf_viewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewer extends StatefulWidget {
  const WebViewer({
    super.key,
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  @override
  State<WebViewer> createState() => _WebViewerState();
}

class _WebViewerState extends State<WebViewer> {
  late final WebViewController controllerWeb;
  double loading = 0;

  String? pdfFlePath;

  // Future<String> downloadAndSavePdf(String url) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final file = File('${directory.path}/sample.pdf');
  //   if (await file.exists()) {
  //     return file.path;
  //   }
  //   final response = await http.get(Uri.parse(sampleUrl));
  //   await file.writeAsBytes(response.bodyBytes);
  //   return file.path;
  // }

  // void loadPdf() async {
  //   pdfFlePath = await downloadAndSavePdf();
  //   setState(() {});
  // }

  void init() {
    controllerWeb = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                loading = progress / 100;
              });
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            if (request.url.endsWith('.pdf')) {
              pushScreen(
                context,
                screen: PDFViewerScreen(pdfUrl: request.url),
              );

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        surfaceTintColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            LinearProgressIndicator(
              value: loading.toDouble(),
            ),
            WebViewWidget(
              controller: controllerWeb,
            ),
          ],
        ),
      ),
    );
  }
}
