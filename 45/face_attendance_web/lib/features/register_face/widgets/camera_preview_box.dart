import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CameraPreviewBox
    extends StatelessWidget {

  final File? selectedImage;

  final Uint8List? webImage;

  const CameraPreviewBox({
    super.key,
    required this.selectedImage,
    required this.webImage,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      shape: RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(16),
      ),

      child: Container(

        width: double.infinity,

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
          BorderRadius.circular(16),
        ),

        child:

        // =========================
        // NO IMAGE
        // =========================
        (selectedImage == null &&
            webImage == null)

            ? const Center(

          child: Column(

            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              Icon(
                Icons.camera_alt,
                size: 80,
                color: Colors.grey,
              ),

              SizedBox(height: 20),

              Text(

                'No Image Selected',

                style: TextStyle(

                  fontSize: 24,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ],
          ),
        )

            :

        // =========================
        // IMAGE PREVIEW
        // =========================
        ClipRRect(

          borderRadius:
          BorderRadius.circular(16),

          child:

          // =========================
          // WEB
          // =========================
          kIsWeb

              ? Image.memory(

            webImage!,

            fit: BoxFit.cover,

            width: double.infinity,

            height: double.infinity,
          )

              :

          // =========================
          // MOBILE / WINDOWS
          // =========================
          Image.file(

            selectedImage!,

            fit: BoxFit.cover,

            width: double.infinity,

            height: double.infinity,
          ),
        ),
      ),
    );
  }
}