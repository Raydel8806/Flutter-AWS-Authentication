import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_page.dart';
import 'gallery_page.dart';

class CameraFlow extends StatefulWidget {
  // 1 CameraFlow deberá activarse cuando el usuario cierre la sesión y se actualice el estado en main.dart. Implementaremos esta funcionalidad poco después de crear la GalleryPage.
  final VoidCallback shouldLogOut;

  const CameraFlow({Key? key, required this.shouldLogOut}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraFlowState();
}

class _CameraFlowState extends State<CameraFlow> {
  late CameraDescription _camera;

  // 2 Este indicador actuará como el estado responsable de cuándo la cámara debería mostrarse o no mostrarse.
  bool _shouldShowCamera = false;

  // 3 Para asegurarnos de que nuestro navegador esté actualizado cuando _shouldShowCamera se actualice, usamos una propiedad calculada para devolver la pila de navegación correcta según el estado actual. Por ahora estamos usando las páginas de marcador de posición.
  List<MaterialPage> get _pages {
    return [
      // Show Gallery Page
      MaterialPage(
          child: GalleryPage(
              shouldLogOut: widget.shouldLogOut,
              shouldShowCamera: () => _toggleCameraOpen(true))),

      // Show Camera Page
      if (_shouldShowCamera)
        MaterialPage(
            child: CameraPage(
                camera: _camera,
                didProvideImagePath: (imagePath) {
                  _toggleCameraOpen(false);
                }))
    ];
  }

  @override
  void initState() {
    super.initState();
    _getCamera();
  }

  @override
  Widget build(BuildContext context) {
    // 4 De forma similar a _MyAppState, estamos usando un widget de navegador para determinar qué página debe mostrarse en un momento dado para una sesión.
    return Navigator(
      pages: _pages,
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  // 5 Este método nos permitirá alternar si la cámara se muestra o no sin tener que implementar setState() en el sitio de la llamada.
  void _toggleCameraOpen(bool isOpen) {
    setState(() {
      _shouldShowCamera = isOpen;
    });
  }

  void _getCamera() async {
    final camerasList = await availableCameras();
    setState(() {
      final firstCamera = camerasList.first;
      _camera = firstCamera;
    });
  }
}
