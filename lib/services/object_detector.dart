import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ObjectDetectorService {
  late Interpreter _interpreter;
  late List<String> _labels;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Load the TFLite model and labels
  Future<void> loadModel() async {
    try {
      // Load the interpreter from asset
      _interpreter = await Interpreter.fromAsset(
        'ssd_mobilenet_v2.tflite',
        options: InterpreterOptions()..threads = 4,
      );

      // Load labels from assets
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();

      _isInitialized = true;
      debugPrint('✅ Model loaded successfully!');
      debugPrint('📋 Labels loaded: ${_labels.length} classes');
    } catch (e) {
      debugPrint('❌ Error loading model: $e');
      rethrow;
    }
  }

  /// Detect objects in an image file
  List<Map<String, dynamic>> detect(File imageFile) {
    if (!_isInitialized) {
      throw Exception('Model not initialized. Call loadModel() first.');
    }

    // 1️⃣ Load and preprocess image
    final image = img.decodeImage(imageFile.readAsBytesSync());
    if (image == null) {
      throw Exception('Failed to decode image');
    }
    
    final resized = img.copyResize(image, width: 300, height: 300);

    // 2️⃣ Convert image to input tensor format (normalized Float32)
    final inputBuffer = _imageToByteBuffer(resized);

    // 3️⃣ Prepare output buffers - SSD MobileNet V2 outputs
    // Output shapes: boxes [1,10,4], classes [1,10], scores [1,10], numDetections [1]
    final outputLocations = List.generate(1, (_) => List.generate(10, (_) => List.filled(4, 0.0)));
    final outputClasses = List.generate(1, (_) => List.filled(10, 0.0));
    final outputScores = List.generate(1, (_) => List.filled(10, 0.0));
    final numDetections = List.filled(1, 0.0);

    final outputs = <int, Object>{
      0: outputLocations,
      1: outputClasses,
      2: outputScores,
      3: numDetections,
    };

    // 4️⃣ Run inference
    _interpreter.runForMultipleInputs([inputBuffer], outputs);

    // 5️⃣ Parse results
    List<Map<String, dynamic>> detections = [];

    final numDetected = numDetections[0].toInt();
    for (int i = 0; i < numDetected && i < 10; i++) {
      final score = outputScores[0][i];
      if (score > 0.5) {
        final classIndex = outputClasses[0][i].toInt();
        final label = classIndex < _labels.length ? _labels[classIndex] : 'Unknown';
        
        detections.add({
          'label': label,
          'confidence': score,
          'box': outputLocations[0][i],
        });
      }
    }

    return detections;
  }

  /// Detect objects from raw image bytes (useful for camera frames)
  List<Map<String, dynamic>> detectFromBytes(Uint8List bytes) {
    if (!_isInitialized) {
      throw Exception('Model not initialized. Call loadModel() first.');
    }

    final image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('Failed to decode image bytes');
    }

    // Create a temporary file for processing
    final resized = img.copyResize(image, width: 300, height: 300);
    final inputBuffer = _imageToByteBuffer(resized);

    final outputLocations = List.generate(1, (_) => List.generate(10, (_) => List.filled(4, 0.0)));
    final outputClasses = List.generate(1, (_) => List.filled(10, 0.0));
    final outputScores = List.generate(1, (_) => List.filled(10, 0.0));
    final numDetections = List.filled(1, 0.0);

    final outputs = <int, Object>{
      0: outputLocations,
      1: outputClasses,
      2: outputScores,
      3: numDetections,
    };

    _interpreter.runForMultipleInputs([inputBuffer], outputs);

    List<Map<String, dynamic>> detections = [];
    final numDetected = numDetections[0].toInt();
    
    for (int i = 0; i < numDetected && i < 10; i++) {
      final score = outputScores[0][i];
      if (score > 0.5) {
        final classIndex = outputClasses[0][i].toInt();
        final label = classIndex < _labels.length ? _labels[classIndex] : 'Unknown';
        
        detections.add({
          'label': label,
          'confidence': score,
          'box': outputLocations[0][i],
        });
      }
    }

    return detections;
  }

  /// Convert image to Float32List buffer for model input
  List<List<List<List<double>>>> _imageToByteBuffer(img.Image image) {
    // Create 4D tensor: [1, 300, 300, 3]
    return List.generate(1, (_) {
      return List.generate(300, (y) {
        return List.generate(300, (x) {
          final pixel = image.getPixel(x, y);
          // Normalize to 0-1 range (or use appropriate normalization for your model)
          return [
            pixel.r / 255.0,
            pixel.g / 255.0,
            pixel.b / 255.0,
          ];
        });
      });
    });
  }

  /// Dispose resources
  void dispose() {
    if (_isInitialized) {
      _interpreter.close();
      _isInitialized = false;
    }
  }
}
