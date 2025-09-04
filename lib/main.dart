import 'package:flutter/material.dart';

import 'custom_textfield_package.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String values = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: TextEditingController(),
              showBorder: true,
              labelText: "Name",
              suffixIcon: Icons.abc,
            ),
            CustomTextField(
              controller: TextEditingController(),
              showBorder: true,
              labelText: "Name",
              suffixAssetPath: "assets/icon.png",
              fillColor: Colors.green,
            ),
            CustomTextField(
              controller: TextEditingController(),
              showBorder: true,
              labelText: "Name",
            ),
            CustomTextField(
              controller: TextEditingController(),
              fillColor: Colors.green,
            ),
            CustomTextField(
              controller: TextEditingController(),
              showBorder: true,
            ),
            CustomTextField(
              controller: TextEditingController(),
              showBorder: true,
              fieldMarginAll: 5,
              title: "Email",
              maxLength: 1000,
              maxLines: 5,
            ),
            CustomTextField(
              controller: TextEditingController(),
              fillColor: Colors.grey.shade200,
              title: "Name",
              isRequired: true,
            ),
            CustomTextField(
              controller: TextEditingController(),
              isRequired: true,
              showBorder: true,
            ),
            CustomTextField(
              controller: TextEditingController(),
              isPassword: true,
              showPasswordStrength: false,
              showBorder: true,
              onChanged: (value) {
                setState(() {
                  values = value;
                });
              },
            ),
            CustomTextField(
              controller: TextEditingController(),
              isPassword: true,
              fieldPaddingAll: 10,
              showBorder: true,
              onChanged: (value) {
                setState(() {
                  values = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
