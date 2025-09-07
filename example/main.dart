import 'package:flutter/material.dart';
import 'package:ms_formkit/ms_formkit.dart';

/// Example app demonstrating the usage of `CustomTextField`.
///
/// This registration form includes:
/// - First & Last Name
/// - Phone Number (only numbers allowed)
/// - Email Address
/// - Password (with strength indicator)
/// - Confirm Password (with validation)
///
/// On submission, entered data is displayed in a preview box.
void main() {
  runApp(const MyApp());
}

/// Root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MS FormKit Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleFormPage(),
    );
  }
}

/// A simple form page showcasing multiple `CustomTextField`
/// widgets together in a registration form layout.
class ExampleFormPage extends StatefulWidget {
  const ExampleFormPage({super.key});

  @override
  State<ExampleFormPage> createState() => _ExampleFormPageState();
}

class _ExampleFormPageState extends State<ExampleFormPage> {
  // Controllers for different fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Validation flags
  bool nameRequired = false;
  bool phoneRequired = false;
  bool emailRequired = false;
  bool passwordRequired = false;

  // Stores submitted data preview
  String submittedData = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registration Form")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _firstNameController,
              title: "First Name",
              isRequired: nameRequired,
              showBorder: true,
            ),
            const SizedBox(height: 5),

            /// Last Name field (optional)
            CustomTextField(
              controller: _lastNameController,
              title: "Last Name",
              showBorder: true,
            ),
            const SizedBox(height: 5),

            /// Phone Number field (only numeric input allowed, max 10 digits)
            CustomTextField(
              controller: _phoneController,
              title: "Phone Number",
              onlyNumbers: true,
              keyboardType: TextInputType.phone,
              isRequired: phoneRequired,
              showBorder: true,
              maxLength: 10,
            ),

            /// Email Address field (with proper keyboard type)
            CustomTextField(
              controller: _emailController,
              title: "Email Address",
              keyboardType: TextInputType.emailAddress,
              isRequired: emailRequired,
              showBorder: true,
            ),
            const SizedBox(height: 5),

            /// Password field (required, with strength indicator enabled)
            CustomTextField(
              controller: _passwordController,
              title: "Password",
              isPassword: true,
              showPasswordStrength: true,
              isRequired: passwordRequired,
              showBorder: true,
            ),
            const SizedBox(height: 5),

            /// Confirm Password field (validates against Password)
            CustomTextField(
              controller: _confirmPasswordController,
              title: "Confirm Password",
              isPassword: true,
              showBorder: true,
              isRequired: passwordRequired,
            ),
            const SizedBox(height: 5),

            /// Submit button with basic validation
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Reset validation flags
                  nameRequired = _firstNameController.text.isEmpty;
                  phoneRequired = _phoneController.text.isEmpty;
                  emailRequired = _emailController.text.isEmpty;
                  passwordRequired = _passwordController.text.isEmpty;
                });

                // Stop execution if any required field is empty
                if (nameRequired ||
                    phoneRequired ||
                    emailRequired ||
                    passwordRequired) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill all required fields."),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Check if passwords match
                if (_passwordController.text !=
                    _confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Passwords do not match!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Save submitted values
                setState(() {
                  submittedData = "Name: ${_firstNameController.text} "
                      "${_lastNameController.text}\n"
                      "Phone: ${_phoneController.text}\n"
                      "Email: ${_emailController.text}";
                });
              },
              child: const Text("Submit"),
            ),

            /// Display submitted data preview
            if (submittedData.isNotEmpty)
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  submittedData,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
