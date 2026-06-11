import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_textfield.dart';

import '../../dashboard/screens/dashboard_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() =>
      _LoginFormState();
}

class _LoginFormState
    extends State<LoginForm> {

  // =========================
  // CONTROLLERS
  // =========================
  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool isLoading = false;

  // =========================
  // BACKEND LOGIN API
  // =========================
  static const String loginUrl =
      'http://127.0.0.1:8000/auth/login';

  // =========================
  // LOGIN USER
  // =========================
  Future<void> loginUser() async {

    // Validation
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Please fill all fields",
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final response = await http.post(

        Uri.parse(loginUrl),

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode({

          'email':
          emailController.text.trim(),

          'password':
          passwordController.text.trim(),
        }),
      );

      // =========================
      // DEBUG
      // =========================
      print(
        "Status Code: ${response.statusCode}"
      );

      print(
        "Response Body: ${response.body}"
      );

      final data =
          jsonDecode(response.body);

      // =========================
      // LOGIN SUCCESS
      // =========================
      if (response.statusCode == 200) {

        int userId =
            data["user_id"];

        print(
          "Logged User ID: $userId"
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              "Login Success",
            ),
          ),
        );

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (_) =>
                DashboardScreen(
                  userId: userId,
                ),
          ),
        );

      } else {

        // =========================
        // LOGIN FAILED
        // =========================
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(

            content: Text(

              data["error"] ??
              data["message"] ??
              "Invalid Email or Password",
            ),
          ),
        );
      }

    } catch (e) {

      // =========================
      // SERVER ERROR
      // =========================
      print("Login Error: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(
            "Server Error: $e",
          ),
        ),
      );

    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {

    emailController.dispose();

    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        // =========================
        // EMAIL
        // =========================
        CustomTextField(

          hint: 'Email',

          controller:
          emailController,
        ),

        const SizedBox(height: 20),

        // =========================
        // PASSWORD
        // =========================
        TextField(

          controller:
          passwordController,

          obscureText: true,

          decoration: InputDecoration(

            hintText: 'Password',

            border:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 30),

        // =========================
        // BUTTON / LOADER
        // =========================
        isLoading

            ? const CircularProgressIndicator()

            : CustomButton(

                title: 'Login',

                onTap: loginUser,
              ),
      ],
    );
  }
}