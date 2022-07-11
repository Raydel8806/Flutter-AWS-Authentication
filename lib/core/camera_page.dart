import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  // 1 Para tomar una foto, necesitaremos obtener una instancia de CameraDescription proporcionada por CameraFlow.
  final CameraDescription camera;
  // 2 Este ValueChanged proporcionará a CameraFlow la ruta local a la imagen capturada por la cámara.
  final ValueChanged didProvideImagePath;

  const CameraPage(
      {Key? key, required this.camera, required this.didProvideImagePath})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // 3 Para asegurarnos de que tenemos una instancia de CameraController, la inicializamos en el método initState e iniciamos _initializeControllerFuture una vez que haya terminado.
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          // 4 FutureBuilder observará cuando se muestre Future y mostrará una vista previa de lo que ve la cámara o un CircularProgressIndicator.
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(this._controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      // 5 Al presionarlo, el FloatingActionButton activará _takePicture().
      floatingActionButton: FloatingActionButton(
          onPressed: _takePicture, child: const Icon(Icons.camera)),
    );
  }

  // 6 Este método construirá una ruta temporal a la ubicación de la imagen y la devolverá a CameraFlow a través de didProvideImagePath.
  void _takePicture() async {
    try {
      await _initializeControllerFuture;

      final tmpDirectory = await getTemporaryDirectory();
      final filePath = '${DateTime.now().millisecondsSinceEpoch}.png';
      final path = join(tmpDirectory.path, filePath);

      XFile xFile = await _controller.takePicture();
      widget.didProvideImagePath(xFile.path);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // 7 Por último, debemos asegurarnos de eliminar el CameraController una vez que se haya eliminado la página.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
