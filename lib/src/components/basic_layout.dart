import 'package:flutter/material.dart';

class BasicLayout extends StatelessWidget {
  const BasicLayout({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
        surfaceTintColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            color: Theme.of(context).secondaryHeaderColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: child,
      ),
    );
  }
}
