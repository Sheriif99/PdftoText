import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:book/pick_document.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  
  FlutterTts flutterTts = FlutterTts();

  void stop() async {
    await flutterTts.stop();
  }

  void speak({String? text}) async {
    await flutterTts.speak(text!); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text to speech"),
        actions: [
          IconButton(
              onPressed: () {
                stop();
              },
              icon: const Icon(Icons.play_arrow_sharp)),
          IconButton(
              onPressed: () {
              },
              icon: const Icon(Icons.pause)),
          IconButton(
              onPressed: () {
                controller.clear();
              },
              icon: const Icon(Icons.delete)),
          IconButton(
              onPressed: () {
                stop();
              },
              icon: const Icon(Icons.stop)),
          IconButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  speak(text: controller.text);
                }
              },
              icon: const Icon(Icons.mic))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          controller: controller,
          maxLines: MediaQuery.of(context).size.height.toInt(),
          decoration: const InputDecoration(
              border: InputBorder.none, label: Text("Text to read...")),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          pickDocument().then((value) async {
            debugPrint(value);
            if (value != '') {
              PDFDoc doc = await PDFDoc.fromPath(value);

              final text = await doc.text;

              controller.text = text;
            }
          });
        },
        label: const Text("Pick a book"),
      ),
    );
  }
}