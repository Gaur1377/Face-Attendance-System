import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),

                Icon(
                  icon,
                  size: 32,
                  color: Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              value,
              style: const TextStyle(
                fontSize: 34,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}