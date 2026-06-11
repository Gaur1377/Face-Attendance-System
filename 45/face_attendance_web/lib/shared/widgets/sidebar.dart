import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  Widget navItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),

      onTap: () {
        Navigator.pushNamed(
          context,
          route,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,

      child: Column(
        children: [
          Container(
            height: 120,
            alignment: Alignment.center,

            child: const Text(
              'Face Attendance',
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          navItem(
            context: context,
            icon: Icons.dashboard,
            title: 'Dashboard',
            route:
                AppRoutes.dashboard,
          ),

          navItem(
            context: context,
            icon: Icons.face,
            title: 'Register Face',
            route:
                AppRoutes.registerFace,
          ),

          navItem(
            context: context,
            icon: Icons.camera_alt,
            title: 'Attendance',
            route:
                AppRoutes.attendance,
          ),

          navItem(
            context: context,
            icon: Icons.table_chart,
            title: 'Records',
            route:
                AppRoutes.records,
          ),

          navItem(
            context: context,
            icon: Icons.download,
            title: 'Export',
            route:
                AppRoutes.export,
          ),
        ],
      ),
    );
  }
}