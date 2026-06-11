import 'package:flutter/material.dart';

class RecordsTable extends StatelessWidget {

  final List<Map<String, dynamic>>
  records;

  const RecordsTable({
    super.key,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: records.isEmpty

          ? const Center(

        child: Text(
          "No Records Found",
        ),
      )

          : SingleChildScrollView(

        scrollDirection: Axis.horizontal,

        child: DataTable(

          columnSpacing: 40,

          headingRowColor:
          WidgetStateProperty.all(
            Colors.grey.shade200,
          ),

          columns: const [

            DataColumn(
              label: Text("ID"),
            ),

            DataColumn(
              label: Text("Roll No"),
            ),

            DataColumn(
              label: Text("Student Name"),
            ),

            DataColumn(
              label: Text("Email"),
            ),

            DataColumn(
              label: Text("Course"),
            ),

            DataColumn(
              label: Text("Branch"),
            ),

            DataColumn(
              label: Text("Timestamp"),
            ),
          ],

          rows: records.map((record) {

            return DataRow(

              cells: [

                DataCell(

                  Text(

                    record["attendance_id"]
                        ?.toString() ??
                        "",
                  ),
                ),

                DataCell(

                  Text(

                    record["roll_no"]
                        ?.toString() ??
                        "",
                  ),
                ),

                DataCell(

                  Text(

                    record["student_name"]
                        ?.toString() ??
                        "",
                  ),
                ),

                DataCell(

                  Text(

                    record["email"]
                        ?.toString() ??
                        "",
                  ),
                ),

                DataCell(

                  Text(

                    record["course"]
                        ?.toString() ??
                        "",
                  ),
                ),

                DataCell(

                  Text(

                    record["branch"]
                        ?.toString() ??
                        "",
                  ),
                ),

                DataCell(

                  Text(

                    record["timestamp"]
                        ?.toString() ??
                        "",
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}