import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../../../../../../framework/utils/dynamicFontSize.dart';
class UploadFileWidget extends StatefulWidget {
  final String title;
  final bool allowImageOnly;

  const UploadFileWidget({
    Key? key,
    this.title = "Choose a File",
    this.allowImageOnly = false,
  }) : super(key: key);

  @override
  State<UploadFileWidget> createState() => _UploadFileWidgetState();
}

class _UploadFileWidgetState extends State<UploadFileWidget> {
  XFile? selectedFile;

  Future<void> pickFile() async {
    List<XTypeGroup> acceptedTypeGroups = [];

    if (widget.allowImageOnly) {
      acceptedTypeGroups.add(const XTypeGroup(
        label: 'Images',
        extensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'],
        mimeTypes: ['image/jpeg', 'image/png', 'image/gif', 'image/bmp', 'image/webp'],
      ));
    } else {
      acceptedTypeGroups.add(const XTypeGroup(
        label: 'All Files',
        extensions: ['*'],
      ));
    }

    final XFile? file = await openFile(acceptedTypeGroups: acceptedTypeGroups);
    if (file != null) {
      setState(() {
        selectedFile = file;
      });
    }
  }

  void removeFile() {
    setState(() {
      selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isSmallScreen = constraints.maxWidth < 400;
      // final containerWidth = constraints.maxWidth * 0.95;
      final containerWidth = constraints.maxWidth;
      final screenHeight = MediaQuery.of(context).size.height;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: containerWidth,
            height: screenHeight * 0.05,

            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFF101A29),
              border: Border.all(color: const Color(0xFF141317)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFC7E0FF),
                  blurRadius: 0,
                  offset: Offset(0.1, 0.5),
                ),
              ],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: pickFile,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white.withOpacity(0.04),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: getResponsiveFontSize(context, 10),
                          fontFamily: 'Poppins',
                          height: 1.3,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedFile != null
                        ? selectedFile!.path.split('/').last
                        : "No File Chosen",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0XFF7D8FA9),
                      fontSize: getResponsiveFontSize(context, 12),
                      fontFamily: 'Poppins',
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (selectedFile != null)
            GestureDetector(
              onTap: removeFile,
              child: Container(
                height: screenHeight * 0.035,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0XFFE04043).withOpacity(0.20)),
                  borderRadius: BorderRadius.circular(3),
                  color: const Color(0xFFE04043).withOpacity(0.04),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Remove",
                    style: TextStyle(
                      color: const Color(0XFFE04043),
                      fontSize: getResponsiveFontSize(context, 10),
                      height: 1.3,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}