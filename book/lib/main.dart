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

  Future PDFsorter(String? text) async{
    if(text!.length > 4000){
      final chunks = <String>[];
      for(var i = 0; i < text.length; i += 3000){
        final chunk = text.substring(i, i += 3000);
        chunks.add(chunk);
        String test = chunks[0];
        String test2 = chunks[1];
        print(test);
        print("---------------------------------------");
        print(test2);
        //return chunks;
        return test;
      }
    }else{
        return text;
    }
  }

  void stop() async {
    await flutterTts.stop();
  }

  void speak({String? text,String? test, List<String>? chunks}) async {
    try{ if (text!.length > 4000) {
    for(var chunkie in chunks!){
      //await flutterTts.speak(chunkie);
      await flutterTts.speak(test!);
      //delay
      await Future.delayed(const Duration(microseconds: 500));
    }
  } else {
    await flutterTts.speak(text);
  }
  }
  catch(e){
    print(test);
  }}

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
              //call chunk sorter function
              PDFsorter(text);
            }
          });
        },
        label: const Text("Pick a book"),
      ),
    );
  }
}