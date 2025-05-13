import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simone/src/models/ctpl_policy.dart';
import 'package:simone/src/utils/colorpalette.dart';

class CTPLFileUploader extends StatefulHookWidget {
  const CTPLFileUploader({
    super.key,
    required this.policy,
    required this.updatePolicy,
    required this.onTermsChecked,
  });

  final ValueNotifier<CTPLPolicy> policy;
  final Function(CTPLPolicy) updatePolicy;
  final Function(bool) onTermsChecked;
  @override
  State<CTPLFileUploader> createState() => _CTPLFileUploaderState();
}

class _CTPLFileUploaderState extends State<CTPLFileUploader> {
  List<PlatformFile> selectedFiles = [];
  bool isChecked = false;

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        selectedFiles.addAll(result.files);
      });
    }
  }

  void removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Upload OR/CR, Government IDs, & Others'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            onPressed: pickFiles,
            style: OutlinedButton.styleFrom(
              backgroundColor: ColorPalette.primaryColor,
            ),
            child: const Text(
              'Upload',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Wrap(
            children: [
              if (selectedFiles.isNotEmpty)
                ...List.generate(selectedFiles.length, (int index) {
                  final file = selectedFiles[index];

                  return GestureDetector(
                    onTap: () => removeFile(index),
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: ColorPalette.neutralGrey),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.photo_rounded),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  file.name,
                                  style: const TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(2),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),

          // ListView.builder(
          //   scrollDirection: Axis.horizontal,
          //   itemCount: selectedFiles.length,
          //   itemBuilder: (context, index) {
          //     final file = selectedFiles[index];
          //     return GestureDetector(
          //       onTap: () => removeFile(index),
          //       child: Container(
          //         width: 100,
          //         margin: const EdgeInsets.symmetric(horizontal: 5),
          //         padding: const EdgeInsets.all(8),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Image.file(
          //               File(file.path!),
          //               width: 80,
          //             ),
          //             const SizedBox(height: 8),
          //             Text(
          //               file.name,
          //               style: const TextStyle(fontSize: 10),
          //               textAlign: TextAlign.center,
          //               overflow: TextOverflow.ellipsis,
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // ),
        ),
        const SizedBox(height: 20),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text(
            "I have read and agree to the KYC terms and conditions required for policy issuance. I confirm that all information is correct and valid.",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          value: isChecked,
          onChanged: (newBool) {
            widget.onTermsChecked(newBool ?? false);
            setState(() {
              isChecked = newBool ?? false;
            });
          },
        ),
      ],
    );
  }
}
