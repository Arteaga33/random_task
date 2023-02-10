import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../providers/tasks.dart';

class SelectedTaskScreen extends StatelessWidget {
  static const routeName = '/selected-task';
  const SelectedTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Getting the task in here
    final randomTaskId = ModalRoute.of(context)?.settings.arguments;
    final choosenTask = Provider.of<Tasks>(context, listen: false)
        .findById(randomTaskId.toString());
    //This should speak the description.
    final FlutterTts flutterTtsDescription = FlutterTts();

    speakDescription() async {
      List<dynamic> languages = await flutterTtsDescription.getLanguages;
      await flutterTtsDescription.setLanguage("en-US");
      await flutterTtsDescription.setPitch(0.7);
      await flutterTtsDescription.setSpeechRate(0.7);
      flutterTtsDescription.getVoices;
      await flutterTtsDescription.speak(choosenTask.description);
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
        choosenTask.title,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      )),
      body: Center(
        child: Column(
          children: [
            Text(
              choosenTask.description,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            ElevatedButton(onPressed: speakDescription, child: const Text('Say the damn thing'))
          ],
        ),
      ),
    );
  }
}
