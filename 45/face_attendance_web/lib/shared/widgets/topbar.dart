import 'package:flutter/material.dart';

class Topbar extends StatelessWidget {
  final String title;

  const Topbar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      decoration: const BoxDecoration(
        color: Colors.white,
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          Row(
            children: [
              IconButton(
                onPressed: () {},

                icon: const Icon(
                  Icons.notifications,
                ),
              ),

              const SizedBox(width: 10),

              const CircleAvatar(
                radius: 22,
                child: Icon(Icons.person),
              ),
            ],
          ),
        ],
      ),
    );
  }
}