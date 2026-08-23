import 'package:camera/camera.dart';

abstract interface class CameraCaptureService {
  Future<void> initialize();

  bool get isInitialized;

  CameraController? get controller;

  Future<XFile> capture();

  Future<void> dispose();
}

/// Isolates the official camera plugin from the rest of the feature.
class FlutterCameraCaptureService implements CameraCaptureService {
  CameraController? _controller;

  @override
  bool get isInitialized => _controller?.value.isInitialized ?? false;

  @override
  CameraController? get controller => _controller;

  @override
  Future<void> initialize() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) throw StateError('No usable camera was found.');
    final camera = cameras.firstWhere(
      (candidate) => candidate.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    final controller = CameraController(
      camera,
      // Page OCR benefits materially from the extra source detail. The
      // adapter remains isolated so device-specific tuning can happen here.
      ResolutionPreset.veryHigh,
      enableAudio: false,
    );
    await controller.initialize();
    _controller = controller;
  }

  @override
  Future<XFile> capture() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw StateError('Camera is not initialized.');
    }
    return controller.takePicture();
  }

  @override
  Future<void> dispose() async {
    final controller = _controller;
    _controller = null;
    await controller?.dispose();
  }
}
