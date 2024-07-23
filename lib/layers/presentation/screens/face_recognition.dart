import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FaceRecognitionScreen(),
    );
  }
}

class FaceRecognitionScreen extends StatefulWidget {
  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  late CameraDescription camera;
  bool isDetecting = false;
  List<Face> faces = [];
  late String imagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    camera = cameras.last;
    _cameraController = CameraController(camera, ResolutionPreset.high);
    await _cameraController.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Face Recognition')),
      body: Column(
        children: [
          if (_cameraController != null &&
              _cameraController.value.isInitialized)
            Stack(
              children: [
                Container(
                  height: 400,
                  child: CameraPreview(_cameraController),
                ),
                CustomPaint(
                  painter:
                      FacePainter(faces, _cameraController.value.previewSize!),
                ),
              ],
            ),
          ElevatedButton(
            onPressed: _captureAndDetectFace,
            child: Text('Capture'),
          ),
        ],
      ),
    );
  }

  void _captureAndDetectFace() async {
    if (isDetecting) return;

    setState(() {
      isDetecting = true;
    });

    final image = await _cameraController.takePicture();
    imagePath = image!.path;
    final visionImage = GoogleVisionImage.fromFilePath(image.path);
    final faceDetector = GoogleVision.instance.faceDetector();
    final detectedFaces = await faceDetector.processImage(visionImage);

    setState(() {
      faces = detectedFaces;
      isDetecting = false;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;

  FacePainter(this.faces, this.imageSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var face in faces) {
      final boundingBox = face.boundingBox;
      final rect = Rect.fromLTRB(
        boundingBox.left * size.width / imageSize.width,
        boundingBox.top * size.height / imageSize.height,
        boundingBox.right * size.width / imageSize.width,
        boundingBox.bottom * size.height / imageSize.height,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
