import 'package:camera/camera.dart';
import 'package:face_detection_app/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(
    this.faces, {
    this.frameSize,
    this.rotation,
    this.cameraLensDirection,
  });

  final List<Face> faces;
  final Size? frameSize;
  final InputImageRotation? rotation;
  final CameraLensDirection? cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final imageSize = frameSize;
    if (imageSize == null || faces.isEmpty) return;

    final Paint paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = Colors.red;
    final Paint paint2 = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.0;

    for (var face in faces) {
      final rect = face.boundingBox;
      final left =
          translateX(rect.left, size, imageSize, rotation, cameraLensDirection);
      final top =
          translateY(rect.top, size, imageSize, rotation, cameraLensDirection);
      final right = translateX(
          rect.right, size, imageSize, rotation, cameraLensDirection);
      final bottom = translateY(
          rect.bottom, size, imageSize, rotation, cameraLensDirection);

      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint1,
      );

      void paintContour(FaceContourType type) {
        final contour = face.contours[type];
        if (contour?.points != null) {
          for (final point in contour!.points) {
            canvas.drawCircle(
                Offset(
                  translateX(point.x.toDouble(), size, imageSize, rotation,
                      cameraLensDirection),
                  translateY(point.y.toDouble(), size, imageSize, rotation,
                      cameraLensDirection),
                ),
                5,
                paint2..color = Colors.white);
          }
        }
      }

      void paintLandmark(FaceLandmarkType type) {
        final landmark = face.landmarks[type];
        if (landmark?.position != null) {
          canvas.drawCircle(
              Offset(
                translateX(landmark!.position.x.toDouble(), size, imageSize,
                    rotation, cameraLensDirection),
                translateY(landmark.position.y.toDouble(), size, imageSize,
                    rotation, cameraLensDirection),
              ),
              5,
              paint2..color = Colors.cyan);
        }
      }

      for (final type in FaceContourType.values) {
        paintContour(type);
      }

      for (final type in FaceLandmarkType.values) {
        paintLandmark(type);
      }
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.faces != faces;
  }
}
