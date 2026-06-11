import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class LiveCameraBox
    extends StatelessWidget {

  final CameraController? controller;

  final bool isCameraReady;
  
  final String? errorMessage;

  const LiveCameraBox({

    super.key,

    required this.controller,

    required this.isCameraReady,
    
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      shape: RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(16),
      ),

      elevation: 4,

      child: Container(

        width: double.infinity,

        decoration: BoxDecoration(

          borderRadius:
          BorderRadius.circular(16),

          color: Colors.black,
        ),

        child: ClipRRect(

          borderRadius:
          BorderRadius.circular(16),

          child:
          isCameraReady &&
              controller != null

              ? CameraPreview(
            controller!,
          )

              : Container(
            
            color: Colors.black87,
            
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.videocam_off,
                    size: 60,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Camera Not Ready",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}