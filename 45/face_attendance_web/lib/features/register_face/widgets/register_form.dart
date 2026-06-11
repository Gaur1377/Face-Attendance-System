import 'package:flutter/material.dart';

import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_textfield.dart';

class RegisterForm extends StatefulWidget {

  final TextEditingController
  rollNoController;

  final TextEditingController
  nameController;

  final TextEditingController
  emailController;

  final TextEditingController
  courseController;

  final TextEditingController
  branchController;

  final VoidCallback onRegister;

  final bool isLoading;

  const RegisterForm({
    super.key,

    required this.rollNoController,

    required this.nameController,

    required this.emailController,

    required this.courseController,

    required this.branchController,

    required this.onRegister,

    required this.isLoading,
  });

  @override
  State<RegisterForm> createState() =>
      _RegisterFormState();
}

class _RegisterFormState
    extends State<RegisterForm> {

  @override
  Widget build(BuildContext context) {

    return Card(

      shape: RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(16),
      ),

      child: Padding(

        padding:
        const EdgeInsets.all(24),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(

              'Student Details',

              style: TextStyle(

                fontSize: 24,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            CustomTextField(

              hint: 'Roll No',

              controller:
              widget.rollNoController,
            ),

            const SizedBox(
              height: 20,
            ),

            CustomTextField(

              hint: 'Full Name',

              controller:
              widget.nameController,
            ),

            const SizedBox(
              height: 20,
            ),

            CustomTextField(

              hint: 'Email',

              controller:
              widget.emailController,
            ),

            const SizedBox(
              height: 20,
            ),

            CustomTextField(

              hint: 'Course',

              controller:
              widget.courseController,
            ),

            const SizedBox(
              height: 20,
            ),

            CustomTextField(

              hint: 'Branch',

              controller:
              widget.branchController,
            ),

            const Spacer(),

            widget.isLoading

                ? const Center(
              child:
              CircularProgressIndicator(),
            )

                : CustomButton(

              title:
              'Register Face',

              onTap:
              widget.onRegister,
            ),
          ],
        ),
      ),
    );
  }
}