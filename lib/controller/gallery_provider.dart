import 'dart:io';

import 'package:face_detection_app/service/face_detection_service.dart';
import 'package:face_detection_app/ui/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class GalleryProvider extends ChangeNotifier {
  final FaceDetectionService _service;

  GalleryProvider(this._service);

  List<Face>? faces;

  File? imageFile;
  Size? imageSize;
  bool isDetectingFaces = false;

  void openGallery() async {
    final picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final bytes = pickedFile.path;
      imageFile = File(bytes);

      final decodedImage =
          await decodeImageFromList(imageFile!.readAsBytesSync());

      imageSize = Size(
        decodedImage.width.toDouble(),
        decodedImage.height.toDouble(),
      );
      faces = null;

      notifyListeners();
    }
  }

  Future<void> detectingFaces() async {
    isDetectingFaces = true;
    notifyListeners();

    faces = await _service.runDetectingFacesFromFilePath(imageFile!);
    isDetectingFaces = false;
    notifyListeners();

    print("_faces: ${faces?.length}");
  }

  void goToCameraPage(BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.pushReplacement(
      MaterialPageRoute(
        builder: (context) => const CameraPage(),
      ),
    );
  }

  @override
  void notifyListeners() {
    if (hasListeners) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _service.close();

    super.dispose();
  }
}
