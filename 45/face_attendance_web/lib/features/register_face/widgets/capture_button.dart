import 'package:flutter/material.dart';

class CaptureButton
    extends StatelessWidget {

  final VoidCallback onTap;

  final bool isLoading;

  const CaptureButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      width: double.infinity,

      height: 55,

      child: ElevatedButton.icon(

        onPressed:
        isLoading
            ? null
            : onTap,

        icon: isLoading

            ? const SizedBox(

          width: 20,
          height: 20,

          child:
          CircularProgressIndicator(
            strokeWidth: 2,
          ),
        )

            : const Icon(
          Icons.camera_alt,
        ),

        label: Text(

          isLoading
              ? 'Processing...'
              : 'Capture Face',

          style: const TextStyle(
            fontSize: 18,
          ),
        ),

        style: ElevatedButton.styleFrom(

          shape:
          RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(12),
          ),

          padding:
          const EdgeInsets.symmetric(
            vertical: 14,
          ),
        ),
      ),
    );
  }
}