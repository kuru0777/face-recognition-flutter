import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:lottie/lottie.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras == null || _cameras!.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Kamera Hatası'),
            content: Text('Cihazınızda bir kamera bulunmuyor.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tamam'),
              ),
            ],
          );
        },
      );
    } else {
      final selectedCamera = _cameras![_selectedCameraIndex];
      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.high,
      );
      await _cameraController!.initialize();

      if (!mounted) {
        return;
      }
      setState(() {
        // Kamera başlatıldığında yüz algılama işlemi başlatın.
        startFaceDetection();
      });
    }
  }

  Future<void> startFaceDetection() async {
    // Kamera önizlemesi aldığınızda, bu önizleme görüntüsünü yüz algılama için işleyebilirsiniz.
    await _cameraController!.startImageStream((CameraImage image) async {
      final inputImage = InputImage.fromBytes(
        bytes: image.planes[0].bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.yuv420,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final List<Face> faces = await _faceDetector.processImage(inputImage);

      // Algılanan yüzlerle ilgili işlemleri burada yapabilirsiniz.

      for (Face face in faces) {
        final boundingBox = face.boundingBox; // Yüzün sınırlayıcı kutusu
        final headEulerAngleY = face.headEulerAngleY; // Yüzün başın eğim açısı
        final headEulerAngleZ = face.headEulerAngleZ; // Yüzün başın eğim açısı
        // Diğer özellikleri kullanabilirsiniz.
      }
    });
  }

  @override
  void dispose() {
    // Sayfadan çıkarken, kamerayı ve yüz algılama işlemini temizleyin.
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  void toggleCamera() {
    setState(() {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
      final selectedCamera = _cameras![_selectedCameraIndex];
      _cameraController =
          CameraController(selectedCamera, ResolutionPreset.high);
      _cameraController!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          // Kamera başlatıldığında yüz algılama işlemi başlatın.
          startFaceDetection();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Kamera'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _cameraController?.value.isInitialized == true
                ? AspectRatio(
                    aspectRatio: 9 / 16,
                    child: CameraPreview(_cameraController!),
                  )
                : Lottie.asset('Assets/face_loading_4.json'),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            isExtended: true,
            onPressed: toggleCamera,
            tooltip: 'Kamera Değiştir',
            child: Icon(Icons.switch_camera),
          ),
        ],
      ),
    );
  }
}
