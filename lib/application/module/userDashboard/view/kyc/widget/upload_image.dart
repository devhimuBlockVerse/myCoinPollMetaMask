import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../../framework/utils/dynamicFontSize.dart';
import '../../../viewmodel/upload_image_provider.dart';

class UploadCard extends StatelessWidget {
  final String title;
  final String uploadKey;


  const UploadCard({super.key, required this.title, required this.uploadKey});

  Future<void> _showImageSourceDialog(BuildContext context) async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () async {
              Navigator.pop(context);
              final picked = await picker.pickImage(source: ImageSource.camera);
              if (picked != null) {
                Provider.of<UploadProvider>(context, listen: false).setImage(uploadKey, File(picked.path));              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () async {
              Navigator.pop(context);
              final picked = await picker.pickImage(source: ImageSource.gallery);
              if (picked != null) {
                Provider.of<UploadProvider>(context, listen: false).setImage(uploadKey,File(picked.path));
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UploadProvider>(context);
    final image = provider.getImage(uploadKey);

    final size = MediaQuery.of(context).size;
    final screenHeight =  MediaQuery.of(context).size.height;
    final screenWidth =  MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => _showImageSourceDialog(context),
      child: Container(
        width: size.width * 0.85,
        height: size.height * 0.18,
        decoration: BoxDecoration(
          color: const Color(0xFF21242D),
          borderRadius: BorderRadius.circular(8),
        ),
        child: image == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/camera.svg',fit: BoxFit.contain,height: screenHeight * 0.05,),
            const SizedBox(height: 8),
            Text(
              title,
              style:  TextStyle(
                color: Color(0xFFA7ADBF),
                fontSize: getResponsiveFontSize(context, 12),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}