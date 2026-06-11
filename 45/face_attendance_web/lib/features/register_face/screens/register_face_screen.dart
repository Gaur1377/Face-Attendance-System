import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../shared/widgets/sidebar.dart';

import '../widgets/camera_preview_box.dart';
import '../widgets/capture_button.dart';
import '../widgets/register_form.dart';

class RegisterFaceScreen extends StatefulWidget {

  const RegisterFaceScreen({
    super.key,
  });

  @override
  State<RegisterFaceScreen> createState() =>
      _RegisterFaceScreenState();
}

class _RegisterFaceScreenState
    extends State<RegisterFaceScreen> {

  // =========================
  // CONTROLLERS
  // =========================
  final TextEditingController
  rollNoController =
  TextEditingController();

  final TextEditingController
  nameController =
  TextEditingController();

  final TextEditingController
  emailController =
  TextEditingController();

  final TextEditingController
  courseController =
  TextEditingController();

  final TextEditingController
  branchController =
  TextEditingController();

  // =========================
  // IMAGE VARIABLES
  // =========================
  File? selectedImage;

  Uint8List? webImage;

  bool isLoading = false;

  // =========================
  // API URL
  // =========================
  final String baseUrl =
      'http://127.0.0.1:8000';

  @override
  void dispose() {

    rollNoController.dispose();
    nameController.dispose();
    emailController.dispose();
    courseController.dispose();
    branchController.dispose();

    super.dispose();
  }

  // =========================
  // PICK IMAGE
  // =========================
  Future<void> pickImage() async {

    FilePickerResult? result =
    await FilePicker.pickFiles(

      type: FileType.image,

      withData: true,
    );

    if (result != null) {

      // =========================
      // WEB
      // =========================
      if (kIsWeb) {

        setState(() {

          webImage =
          result.files.first.bytes;
        });
      }

      // =========================
      // MOBILE / WINDOWS
      // =========================
      else {

        if (result.files.single.path != null) {

          setState(() {

            selectedImage = File(
              result.files.single.path!,
            );
          });
        }
      }
    }
  }

  // =========================
  // REGISTER STUDENT
  // =========================
  Future<void> registerStudent() async {

    // =========================
    // VALIDATION
    // =========================
    if (rollNoController.text.isEmpty ||
        nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        courseController.text.isEmpty ||
        branchController.text.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            'Please fill all fields',
          ),
        ),
      );

      return;
    }

    // =========================
    // IMAGE VALIDATION
    // =========================
    if (selectedImage == null &&
        webImage == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            'Please select face image',
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      // =========================
      // REQUEST
      // =========================
      var request =
      http.MultipartRequest(

        'POST',

        Uri.parse(
          '$baseUrl/face/register',
        ),
      );

      // =========================
      // FORM DATA
      // =========================
      request.fields['roll_no'] =
          rollNoController.text;

      request.fields['name'] =
          nameController.text;

      request.fields['email'] =
          emailController.text;

      request.fields['course'] =
          courseController.text;

      request.fields['branch'] =
          branchController.text;

      // =========================
      // IMAGE UPLOAD
      // =========================
      if (kIsWeb) {

        request.files.add(

          http.MultipartFile.fromBytes(

            'file',

            webImage!,

            filename: 'face.jpg',
          ),
        );

      } else {

        request.files.add(

          await http.MultipartFile
              .fromPath(

            'file',

            selectedImage!.path,
          ),
        );
      }

      // =========================
      // SEND REQUEST
      // =========================
      final response =
      await request.send();

      final responseData =
      await response.stream.bytesToString();

      final data =
      jsonDecode(responseData);

      // =========================
      // SUCCESS
      // =========================
      if (response.statusCode == 200) {

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(

            content: Text(
              data['message'] ??
                  'Student Registered Successfully',
            ),
          ),
        );

        // =========================
        // CLEAR FORM
        // =========================
        rollNoController.clear();
        nameController.clear();
        emailController.clear();
        courseController.clear();
        branchController.clear();

        setState(() {

          selectedImage = null;

          webImage = null;
        });

      }

      // =========================
      // FAILED
      // =========================
      else {

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(

            content: Text(

              data['detail'] ??
                  'Registration Failed',
            ),
          ),
        );
      }

    } catch (e) {

      debugPrint(e.toString());

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      Colors.grey.shade100,

      body: Row(

        children: [

          const Sidebar(),

          Expanded(

            child: Padding(

              padding:
              const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Text(

                    'Register Face',

                    style: TextStyle(

                      fontSize: 32,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  Expanded(

                    child: Row(

                      children: [

                        // =========================
                        // LEFT SIDE
                        // =========================
                        Expanded(

                          flex: 2,

                          child: Column(

                            children: [

                              Expanded(

                                child:
                                CameraPreviewBox(

                                  selectedImage:
                                  selectedImage,

                                  webImage:
                                  webImage,
                                ),
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              CaptureButton(

                                onTap:
                                pickImage,

                                isLoading:
                                isLoading,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          width: 30,
                        ),

                        // =========================
                        // RIGHT SIDE
                        // =========================
                        Expanded(

                          child: RegisterForm(

                            rollNoController:
                            rollNoController,

                            nameController:
                            nameController,

                            emailController:
                            emailController,

                            courseController:
                            courseController,

                            branchController:
                            branchController,

                            onRegister:
                            registerStudent,

                            isLoading:
                            isLoading,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}