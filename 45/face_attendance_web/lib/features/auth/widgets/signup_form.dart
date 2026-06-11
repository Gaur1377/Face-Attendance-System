import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_textfield.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() =>
      _SignupFormState();
}

class _SignupFormState
    extends State<SignupForm> {
  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final subjectController =
      TextEditingController();


  final passwordController =
      TextEditingController();

  bool isLoading = false;

  // Backend Signup API
  // Backend Signup API
static const String signup =
    'http://localhost:8000/auth/register';
  Future<void> signupUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(signup),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          
          'subject':
                subjectController.text.trim(),
          'password':
              passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Account Created Successfully',
            ),
          ),
        );

        Navigator.pop(context);
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              data['detail'] ??
                  'Signup Failed',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text('Server Error: $e'),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          hint: 'Full Name',
          controller: nameController,
        ),

        const SizedBox(height: 20),

        CustomTextField(
          hint: 'Email',
          controller: emailController,
        ),

        const SizedBox(height: 20),

        CustomTextField(
          hint: 'Subject',
          controller: subjectController,
        ),

        const SizedBox(height: 20),

        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 30),

        isLoading
            ? const CircularProgressIndicator()
            : CustomButton(
                title: 'Create Account',
                onTap: signupUser,
              ),
      ],
    );
  }
}