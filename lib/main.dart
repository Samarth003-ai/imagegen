import 'package:flutter/material.dart';

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
  String imageUrl = "";
  bool isLoading = false;

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

            ElevatedButton(onPressed: () {}, child: const Text("Generate")),
            const SizedBox(height: 16),
            if (isLoading) const CircularProgressIndicator(),

            const SizedBox(height: 16),

            if (imageUrl.isNotEmpty) Image.network(imageUrl), // network??
          ],
        ),
      ),
    );
  }
}
