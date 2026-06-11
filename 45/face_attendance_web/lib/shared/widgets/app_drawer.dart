import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [
                Icon(
                  Icons.face,
                  size: 70,
                  color: Colors.blue,
                ),

                SizedBox(height: 10),

                Text(
                  'Face Attendance',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            leading:
                const Icon(Icons.dashboard),

            title: const Text('Dashboard'),

            onTap: () {},
          ),

          ListTile(
            leading:
                const Icon(Icons.face),

            title:
                const Text('Register Face'),

            onTap: () {},
          ),

          ListTile(
            leading:
                const Icon(Icons.camera),

            title:
                const Text('Attendance'),

            onTap: () {},
          ),

          ListTile(
            leading:
                const Icon(Icons.table_chart),

            title: const Text('Records'),

            onTap: () {},
          ),

          ListTile(
            leading:
                const Icon(Icons.download),

            title: const Text('Export'),

            onTap: () {},
          ),
        ],
      ),
    );
  }
}