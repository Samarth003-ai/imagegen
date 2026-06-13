import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImageGeneratorPage(),
    );
  }
}

class ImageGeneratorPage extends StatefulWidget {
  const ImageGeneratorPage({super.key});

  @override
  State<ImageGeneratorPage> createState() => _ImageGeneratorPageState();
}

class _ImageGeneratorPageState extends State<ImageGeneratorPage> {
  final TextEditingController promptController =
      TextEditingController(); //why not var
  String imageData = "";
  bool isLoading = false;

  Future<void> generateImage() async {
    // when button is pressed this sends prompt to backend
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse(
          "http://10.0.2.2:5000/generate-image",
        ), //parses document into objects

        headers: {
          "Content-Type": "application/json",
        }, // tells the server which server im sending

        body: jsonEncode({
          "prompt": promptController.text,
        }), // converts in json string
      );
      final data = jsonDecode(response.body); // converts json into dart object

      setState(() {
        imageData = data["image"];
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI IMAGE")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: promptController,
              decoration: const InputDecoration(
                hintText: "Enter Prompt",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: generateImage,
              child: const Text("Generate"),
            ),
            const SizedBox(height: 16),
            if (isLoading) const CircularProgressIndicator(),

            const SizedBox(height: 16),

            if (imageData.isNotEmpty)
              Image.memory(
                base64Decode(imageData),
              ), // network? it takes the url and shows the image
          ],
        ),
      ),
    );
  }
}
