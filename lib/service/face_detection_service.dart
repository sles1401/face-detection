import 'dart:io';

import 'package:google_ml_kit/google_ml_kit.dart';

class FaceDetectionService {
  final FaceDetector _faceDetector;

  FaceDetectionService([
    FaceDetector? faceDetector,
  ]) : _faceDetector = faceDetector ??
            FaceDetector(
              options: FaceDetectorOptions(
                enableContours: true,
                enableLandmarks: true,
              ),
            );

  Future<List<Face>> runDetectingFacesFromFilePath(File file) async {
    final InputImage inputImage = InputImage.fromFile(file);

    return await runDetectingFaces(inputImage);
  }

  Future<List<Face>> runDetectingFaces(InputImage inputImage) async {
    final List<Face> faces = await _faceDetector.processImage(inputImage);

    return faces;
  }

  Future<void> close() => _faceDetector.close();
}
