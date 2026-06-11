import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {

  final TextEditingController searchController;

  final String selectedCourse;

  final String selectedBranch;

  final List<String> courses;

  final List<String> branches;

  final Function(String) onSearch;

  final Function(String?) onCourseChanged;

  final Function(String?) onBranchChanged;

  final VoidCallback onRefresh;

  const FilterBar({
    super.key,
    required this.searchController,
    required this.selectedCourse,
    required this.selectedBranch,
    required this.courses,
    required this.branches,
    required this.onSearch,
    required this.onCourseChanged,
    required this.onBranchChanged,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {

    return Wrap(

      spacing: 20,

      runSpacing: 15,

      crossAxisAlignment:
      WrapCrossAlignment.center,

      children: [

        // =========================
        // SEARCH
        // =========================
        SizedBox(

          width: 280,

          child: TextField(

            controller: searchController,

            onChanged: onSearch,

            decoration: InputDecoration(

              hintText: "Search Student",

              prefixIcon: const Icon(
                Icons.search,
              ),

              filled: true,

              fillColor: Colors.white,

              border: OutlineInputBorder(

                borderRadius:
                BorderRadius.circular(12),

                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // =========================
        // COURSE FILTER
        // =========================
        Container(

          padding:
          const EdgeInsets.symmetric(
            horizontal: 12,
          ),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:
            BorderRadius.circular(12),
          ),

          child: DropdownButton<String>(

            value: selectedCourse,

            underline: const SizedBox(),

            items: courses.map((course) {

              return DropdownMenuItem(

                value: course,

                child: Text(course),
              );
            }).toList(),

            onChanged: onCourseChanged,
          ),
        ),

        // =========================
        // BRANCH FILTER
        // =========================
        Container(

          padding:
          const EdgeInsets.symmetric(
            horizontal: 12,
          ),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:
            BorderRadius.circular(12),
          ),

          child: DropdownButton<String>(

            value: selectedBranch,

            underline: const SizedBox(),

            items: branches.map((branch) {

              return DropdownMenuItem(

                value: branch,

                child: Text(branch),
              );
            }).toList(),

            onChanged: onBranchChanged,
          ),
        ),

        // =========================
        // REFRESH
        // =========================
        ElevatedButton.icon(

          onPressed: onRefresh,

          icon: const Icon(
            Icons.refresh,
          ),

          label: const Text(
            "Refresh",
          ),
        ),
      ],
    );
  }
}