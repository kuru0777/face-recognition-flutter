import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:loading_indicator/loading_indicator.dart';
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
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
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
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kamera'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            _cameraController?.value.isInitialized == true
                ? AspectRatio(
                    aspectRatio: 9 / 16,
                    child: CameraPreview(_cameraController!),
                  )
                : Lottie.asset('Assets/face_loading_4.json'),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: toggleCamera,
            tooltip: 'Kamera Değiştir',
            child: Icon(Icons.switch_camera),
          ),
        ],
      ),
    );
  }
}
