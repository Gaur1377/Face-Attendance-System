import 'package:flutter/material.dart';

class ExportCard extends StatelessWidget {

  final String title;

  final IconData icon;

  final VoidCallback onPressed;

  const ExportCard({

    super.key,

    required this.title,

    required this.icon,

    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding:
      const EdgeInsets.all(24),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Column(

        children: [

          Icon(

            icon,

            size: 60,

            color: Colors.blue,
          ),

          const SizedBox(
            height: 20,
          ),

          Text(

            title,

            style: const TextStyle(

              fontSize: 22,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          SizedBox(

            width: double.infinity,

            height: 50,

            child: ElevatedButton.icon(

              onPressed:
              onPressed,

              icon:
              const Icon(
                Icons.download,
              ),

              label:
              const Text(
                'Download',
              ),
            ),
          ),
        ],
      ),
    );
  }
}