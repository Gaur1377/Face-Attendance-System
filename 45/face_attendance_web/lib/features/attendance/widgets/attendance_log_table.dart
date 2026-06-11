import 'package:flutter/material.dart';

class AttendanceLogTable
    extends StatelessWidget {

  final List attendanceLogs;

  const AttendanceLogTable({

    super.key,

    required this.attendanceLogs,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      elevation: 4,

      shape: RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(16),
      ),

      child: Padding(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Row(

              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [

                const Text(

                  'Attendance Logs',

                  style: TextStyle(

                    fontSize: 24,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                Container(

                  padding:
                  const EdgeInsets.symmetric(

                    horizontal: 12,

                    vertical: 6,
                  ),

                  decoration: BoxDecoration(

                    color:
                    Colors.blue.shade50,

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Text(

                    '${attendanceLogs.length} Records',

                    style: TextStyle(

                      color:
                      Colors.blue.shade700,

                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            Expanded(

              child:
              attendanceLogs.isEmpty

                  ? const Center(

                child: Column(

                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    Icon(

                      Icons.fact_check_outlined,

                      size: 70,

                      color: Colors.grey,
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    Text(

                      'No Attendance Logs',

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight:
                        FontWeight.w500,

                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )

                  : ListView.separated(

                itemCount:
                attendanceLogs.length,

                separatorBuilder:
                    (context, index) {

                  return const Divider();
                },

                itemBuilder:
                    (context, index) {

                  final log =
                  attendanceLogs[index];

                  return ListTile(

                    contentPadding:
                    EdgeInsets.zero,

                    leading: CircleAvatar(

                      backgroundColor:
                      Colors.blue.shade100,

                      child: const Icon(

                        Icons.person,

                        color: Colors.blue,
                      ),
                    ),

                    title: Text(

                      log["student_name"] ??
                          "Unknown",

                      style: const TextStyle(

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    subtitle: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const SizedBox(
                          height: 4,
                        ),

                        Text(

                          'Roll No: ${log["roll_no"]}',
                        ),

                        Text(

                          log["timestamp"]
                              .toString(),
                        ),
                      ],
                    ),

                    trailing: Container(

                      padding:
                      const EdgeInsets.symmetric(

                        horizontal: 12,

                        vertical: 6,
                      ),

                      decoration: BoxDecoration(

                        color:
                        Colors.green.shade100,

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: Text(

                        log["status"] ??
                            "Present",

                        style: TextStyle(

                          color:
                          Colors.green.shade800,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}