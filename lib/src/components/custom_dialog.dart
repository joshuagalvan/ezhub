import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simone/src/utils/colorpalette.dart';

class CustomLoadingDialog extends StatelessWidget {
  const CustomLoadingDialog({super.key, this.loadingText});

  final String? loadingText;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 110,
          width: 110,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SpinKitChasingDots(
                color: ColorPalette.primaryColor,
              ),
              if (loadingText != null) ...[
                const SizedBox(height: 10),
                Text(
                  loadingText ?? 'Loading...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
