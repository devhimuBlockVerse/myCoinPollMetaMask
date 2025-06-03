import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../framework/utils/dynamicFontSize.dart';
import '../../../side_nav_bar.dart';
import '../../viewmodel/side_navigation_provider.dart';


class KycUploadImage extends StatefulWidget {
  const KycUploadImage({super.key});

  @override
  State<KycUploadImage> createState() => _KycUploadImageState();
}

class _KycUploadImageState extends State<KycUploadImage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final bool isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    final textScale = screenWidth / 375;

    final navProvider = Provider.of<NavigationProvider>(context);
    final currentScreenId = navProvider.currentScreenId;
    final navItems = navProvider.drawerNavItems;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 80,
      drawer: SideNavBar(
        currentScreenId: currentScreenId,
        navItems: navItems,
        onScreenSelected: (id) => navProvider.setScreen(id),
        onLogoutTapped: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logout Pressed")),
          );
        },
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          // height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/affiliateBg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App bar row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/back_button.svg',
                      color: Colors.white,
                      width: screenWidth * 0.04,
                      height: screenWidth * 0.04,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      ' Upload Image of  ID Card',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: getResponsiveFontSize(context, 16),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.12),
                ],
              ),


              // Main content area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.01,
                    vertical: screenHeight * 0.01,
                  ),
                  child: ListView(
                    children: [

                      UploadCard(title: 'Upload back page'),
                      SizedBox(height: screenHeight * 0.02),





                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






/// Provider to manage upload state

class UploadProvider with ChangeNotifier {
  File? _image;

  File? get image => _image;
  bool get isUploaded => _image != null;

  void setImage(File file) {
    _image = file;
    notifyListeners();
  }

  void clearImage() {
    _image = null;
    notifyListeners();
  }
}


/// Reusable UploadCard widget
class UploadCard extends StatelessWidget {
  final String title;

  const UploadCard({super.key, required this.title});

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
                Provider.of<UploadProvider>(context, listen: false).setImage(File(picked.path));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () async {
              Navigator.pop(context);
              final picked = await picker.pickImage(source: ImageSource.gallery);
              if (picked != null) {
                Provider.of<UploadProvider>(context, listen: false).setImage(File(picked.path));
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
        child: provider.image == null
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
            provider.image!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
