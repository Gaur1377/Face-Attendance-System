import 'package:flutter/material.dart';

class ReportTable extends StatelessWidget {

  final List<Map<String, dynamic>>
  reportData;

  const ReportTable({

    super.key,

    required this.reportData,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(20),
      ),

      child:
      reportData.isEmpty

          ? const Center(

        child: Text(
          "No Report Data",
        ),
      )

          : SingleChildScrollView(

        scrollDirection:
        Axis.horizontal,

        child: DataTable(

          columnSpacing: 40,

          headingRowColor:
          WidgetStateProperty.all(
            Colors.grey.shade200,
          ),

          columns: const [

            DataColumn(
              label: Text("Roll No"),
            ),

            DataColumn(
              label:
              Text("Student Name"),
            ),

            DataColumn(
              label: Text("Course"),
            ),

            DataColumn(
              label: Text("Branch"),
            ),

            DataColumn(
              label:
              Text("Attendance"),
            ),

            DataColumn(
              label: Text("Status"),
            ),
          ],

          rows:
          reportData.map(
                (record) {

              return DataRow(

                cells: [

                  DataCell(

                    Text(

                      record["roll_no"]
                          .toString(),
                    ),
                  ),

                  DataCell(

                    Text(

                      record["student_name"]
                          .toString(),
                    ),
                  ),

                  DataCell(

                    Text(

                      record["course"]
                          .toString(),
                    ),
                  ),

                  DataCell(

                    Text(

                      record["branch"]
                          .toString(),
                    ),
                  ),

                  DataCell(

                    Text(

                      record["attendance"]
                          .toString(),
                    ),
                  ),

                  DataCell(

                    Container(

                      padding:
                      const EdgeInsets.symmetric(

                        horizontal: 12,

                        vertical: 6,
                      ),

                      decoration:
                      BoxDecoration(

                        color:
                        record["status"] ==
                            "Good"

                            ? Colors.green
                            .shade100

                            : record["status"] ==
                            "Average"

                            ? Colors.orange
                            .shade100

                            : Colors.red
                            .shade100,

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: Text(

                        record["status"],

                        style: TextStyle(

                          color:
                          record["status"] ==
                              "Good"

                              ? Colors.green

                              : record["status"] ==
                              "Average"

                              ? Colors.orange

                              : Colors.red,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}