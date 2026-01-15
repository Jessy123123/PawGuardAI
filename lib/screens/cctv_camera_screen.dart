import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

class CctvCameraScreen extends StatefulWidget {
  const CctvCameraScreen({super.key});

  @override
  State<CctvCameraScreen> createState() => _CctvCameraScreenState();
}

class _CctvCameraScreenState extends State<CctvCameraScreen> {
  CameraController? _controller;
  late FaceDetector _faceDetector;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(enableContours: false),
    );
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Live CCTV Camera')),
      body: CameraPreview(_controller!),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera),
        onPressed: _captureAndProcess,
      ),
    );
  }

  Future<void> _captureAndProcess() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      // 1️. Capture image
      final file = await _controller!.takePicture();
      final imageFile = File(file.path);

      // 2️. FACE DETECTION
      final inputImage = InputImage.fromFile(imageFile);
      final faces = await _faceDetector.processImage(inputImage);

      // DEBUG LOG (IMPORTANT)
      print('Faces detected: ${faces.length}');

      // 3. Decode image for processing
      Uint8List bytes = await imageFile.readAsBytes();
      img.Image image = img.decodeImage(bytes)!;

      // 4. Blur detected faces
      for (final face in faces) {
        image = _blurFace(image, face.boundingBox);
      }

      // 5️. Pass sanitized image to animal AI
      // final species = classifier.predict(image);
    } catch (e) {
      print('Error during capture & process: $e');
    } finally {
      _isProcessing = false;
    }
  }

  img.Image _blurFace(img.Image src, Rect rect) {
    final x = rect.left.toInt().clamp(0, src.width);
    final y = rect.top.toInt().clamp(0, src.height);
    final w = rect.width.toInt().clamp(0, src.width - x);
    final h = rect.height.toInt().clamp(0, src.height - y);

    // Crop face region
    final faceCrop = img.copyCrop(src, x: x, y: y, width: w, height: h);

    // Blur face
    final blurredFace = img.gaussianBlur(faceCrop, radius: 15);

    // Paste back
    img.compositeImage(src, blurredFace, dstX: x, dstY: y);

    return src;
  }
}
