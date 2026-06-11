import 'package:flutter/material.dart';

import '../widgets/sidebar.dart';
import '../widgets/topbar.dart';

class DashboardLayout
    extends StatelessWidget {
  final String title;
  final Widget child;

  const DashboardLayout({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: Row(
        children: [
          const Sidebar(),

          Expanded(
            child: Column(
              children: [
                Topbar(title: title),

                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                            20),

                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}