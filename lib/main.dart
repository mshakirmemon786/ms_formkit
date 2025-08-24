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
            ),
            CustomTextField(
              controller: TextEditingController(),
              showBorder: true,
              fieldTitle: "Email",
            ),
            CustomTextField(
              controller: TextEditingController(),
              fillColor: Colors.grey,
            ),
            CustomTextField(
              controller: TextEditingController(),
              showBorder: true,
              fieldTitle: "Email",
            ),
            CustomTextField(
              controller: TextEditingController(),
              showBorder: true,
              fieldMarginAll: 5,
              fieldTitle: "Email",
            ),
            CustomTextField(
              controller: TextEditingController(),
              isPassword: true,
              isPasswordError: false,
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
