import 'package:flutter/material.dart';

// 1 GalleryPage solo mostrará imágenes, por lo que se puede implementar como un StatelessWidget.
class GalleryPage extends StatelessWidget {
  // 2 Esta VoidCallback se conectará al método shouldLogOut en CameraFlow.
  final VoidCallback shouldLogOut;
  // 3 Esta VoidCallback actualizará el indicador _shouldShowCamera en
  // CameraFlow.
  final VoidCallback shouldShowCamera;

  const GalleryPage(
      {Key? key, required this.shouldLogOut, required this.shouldShowCamera})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          // 4 Nuestro botón de cierre de sesión se implementa como una acción en la AppBar y cuando se la toca, llama a shouldLogOut.
          // Log Out Button
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
                onTap: shouldLogOut, child: const Icon(Icons.logout)),
          )
        ],
      ),
      // 5 Al presionar este FloatingActionButton, se activará nuestra cámara para mostrarla.
      floatingActionButton: FloatingActionButton(
          onPressed: shouldShowCamera, child: const Icon(Icons.camera_alt)),
      body: Container(child: _galleryGrid()),
    );
  }

  Widget _galleryGrid() {
    // 6 Las imágenes se mostrarán en una grilla con dos columnas. Actualmente estamos codificando tres elementos en esta grilla.
    return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: 5,
        itemBuilder: (context, index) {
          // 7 En el módulo Agregar almacenamiento, implementaremos un widget para cargar imágenes. Hasta entonces, usaremos el marcador de posición para representar las imágenes.
          return const Placeholder();
        });
  }
}
