import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/object_detector.dart';

class TestDetectorScreen extends StatefulWidget {
  const TestDetectorScreen({super.key});

  @override
  State<TestDetectorScreen> createState() => _TestDetectorScreenState();
}

class _TestDetectorScreenState extends State<TestDetectorScreen> {
  final ObjectDetectorService _detector = ObjectDetectorService();
  bool _isLoading = true;
  String _status = 'Initializing...';
  List<Map<String, dynamic>> _detections = [];
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeAll();
  }

  Future<void> _initializeAll() async {
    setState(() => _status = 'Loading model...');
    
    try {
      // Load the detector model
      await _detector.loadModel();
      setState(() => _status = 'Model loaded! Initializing camera...');

      // Initialize cameras
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras!.first,
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        setState(() {
          _isLoading = false;
          _status = 'Ready! Tap "Detect" to analyze';
        });
      } else {
        setState(() {
          _isLoading = false;
          _status = 'No camera available. Model is ready for file-based detection.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Error: $e';
      });
    }
  }

  Future<void> _captureAndDetect() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      setState(() => _status = 'Camera not available');
      return;
    }

    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
      _status = 'Capturing...';
    });

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() => _status = 'Analyzing image...');

      final File imageFile = File(photo.path);
      final results = _detector.detect(imageFile);

      setState(() {
        _detections = results;
        _status = 'Found ${results.length} object(s)';
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Detection error: $e';
        _isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _detector.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐾 PawGuard AI - Test'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Status bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.deepPurple.shade100,
            child: Text(
              _status,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // Camera preview or loading
          Expanded(
            flex: 2,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _cameraController != null && _cameraController!.value.isInitialized
                    ? CameraPreview(_cameraController!)
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('Camera not available'),
                          ],
                        ),
                      ),
          ),

          // Detection results
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detected Objects:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _detections.isEmpty
                        ? const Center(child: Text('No detections yet'))
                        : ListView.builder(
                            itemCount: _detections.length,
                            itemBuilder: (context, index) {
                              final det = _detections[index];
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.pets, color: Colors.deepPurple),
                                  title: Text(det['label'] ?? 'Unknown'),
                                  subtitle: Text(
                                    'Confidence: ${((det['confidence'] as double) * 100).toStringAsFixed(1)}%',
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isProcessing ? null : _captureAndDetect,
        backgroundColor: Colors.deepPurple,
        icon: Icon(_isProcessing ? Icons.hourglass_empty : Icons.camera),
        label: Text(_isProcessing ? 'Processing...' : 'Detect'),
      ),
    );
  }
}
