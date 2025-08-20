import 'package:face_detection_app/controller/gallery_provider.dart';
import 'package:face_detection_app/utils/face_detector_painter.dart';
import 'package:face_detection_app/widget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GalleryProvider(context.read()),
      child: _GalleryView(),
    );
  }
}

class _GalleryView extends StatelessWidget {
  const _GalleryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Face Detection from Gallery'),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<GalleryProvider>().goToCameraPage(context),
            icon: const Icon(Icons.camera_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: _GalleryBody(),
          ),
        ),
      ),
    );
  }
}

class _GalleryBody extends StatefulWidget {
  const _GalleryBody();

  @override
  State<_GalleryBody> createState() => _GalleryBodyState();
}

class _GalleryBodyState extends State<_GalleryBody> {
  @override
  void initState() {
    super.initState();

    final provider = context.read<GalleryProvider>();

    provider.addListener(() async {
      final faces = provider.faces;
      final isDetectingFaces = provider.isDetectingFaces;

      if (faces == null && !isDetectingFaces) {
        await provider.detectingFaces();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.titleSmall;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text("Input:", style: textTheme),
        Expanded(
          child: GestureDetector(
            onTap: () => context.read<GalleryProvider>().openGallery(),
            child: Consumer<GalleryProvider>(
              builder: (context, value, child) {
                final imageFile = value.imageFile;
                return ImageWidget(imageFile: imageFile);
              },
            ),
          ),
        ),
        Text("Output:", style: textTheme),
        Expanded(
          child: Consumer<GalleryProvider>(
            builder: (context, value, child) {
              final imageFile = value.imageFile;
              if (imageFile == null) {
                return SizedBox();
              }

              final isDetectingFaces = value.isDetectingFaces;
              if (isDetectingFaces) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return FittedBox(
                child: CustomPaint(
                  foregroundPainter: FaceDetectorPainter(
                    value.faces!,
                    frameSize: value.imageSize,
                  ),
                  child: ImageWidget(imageFile: imageFile),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
