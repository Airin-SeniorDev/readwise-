import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter_tts/flutter_tts.dart';

class OCRScreen extends StatefulWidget {
  @override
  _OCRScreenState createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  File? _image;
  String _extractedText = "";
  final FlutterTts flutterTts = FlutterTts();

  Future<void> pickImageAndScanText() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _extractedText = "กำลังสแกนข้อความ...";
      });

      final inputImage = InputImage.fromFile(_image!);
      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      setState(() {
        _extractedText = recognizedText.text;
      });

      textRecognizer.close();
    }
  }

  Future<void> speakText(String text) async {
    await flutterTts.setLanguage("th-TH"); // หรือ "en-US"
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("📷 สแกนข้อความ OCR")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickImageAndScanText,
              child: Text("📸 ถ่ายภาพเพื่อสแกนข้อความ"),
            ),
            SizedBox(height: 16),
            _image != null
                ? Image.file(_image!, height: 200)
                : Text("ยังไม่ได้เลือกรูปภาพ"),
            SizedBox(height: 16),
            if (_extractedText.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(_extractedText, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => speakText(_extractedText),
                        child: Text("🔊 ฟังข้อความที่สแกน"),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
