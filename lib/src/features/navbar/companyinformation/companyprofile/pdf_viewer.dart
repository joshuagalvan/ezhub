import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PDFViewerScreen extends StatefulWidget {
  const PDFViewerScreen({super.key, required this.pdfUrl});

  final String pdfUrl;
  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  bool _isLoading = true;
  String title = '';
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    final url = Uri.parse(widget.pdfUrl);
    title = url.pathSegments.last.split('.').first;
    document = await PDFDocument.fromURL(widget.pdfUrl);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        surfaceTintColor: Colors.white,
        title: Text(
          title,
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : PDFViewer(
              document: document,
              lazyLoad: false,
              zoomSteps: 1,
              numberPickerConfirmWidget: const Text(
                "Confirm",
              ),
            ),
    );
  }
}
