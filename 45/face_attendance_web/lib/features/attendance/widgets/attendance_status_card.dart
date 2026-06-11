import 'package:flutter/material.dart';

class AttendanceStatusCard
    extends StatelessWidget {

  final String title;

  final String value;

  final Color color;

  final IconData icon;

  const AttendanceStatusCard({

    super.key,

    required this.title,

    required this.value,

    required this.color,

    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      elevation: 4,

      shape: RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(16),
      ),

      child: Container(

        padding:
        const EdgeInsets.all(24),

        decoration: BoxDecoration(

          borderRadius:
          BorderRadius.circular(16),

          color: Colors.white,
        ),

        child: Row(

          children: [

            Container(

              padding:
              const EdgeInsets.all(14),

              decoration: BoxDecoration(

                color:
                // ignore: deprecated_member_use
                color.withOpacity(0.15),

                borderRadius:
                BorderRadius.circular(
                  12,
                ),
              ),

              child: Icon(

                icon,

                color: color,

                size: 32,
              ),
            ),

            const SizedBox(
              width: 20,
            ),

            Expanded(

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(

                    title,

                    style: TextStyle(

                      fontSize: 18,

                      color:
                      Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(

                    value,

                    style: TextStyle(

                      fontSize: 34,

                      fontWeight:
                      FontWeight.bold,

                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}