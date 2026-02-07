import 'package:flutter/material.dart';
import 'package:onepali/src/features/lessons/models/nepali_letter.dart';
import 'package:onepali/src/features/lessons/services/nepali_letter_service.dart';
import 'package:onepali/src/features/lessons/views/letter_tracing_view.dart';
import 'package:onepali/src/features/lessons/views/new_letter_tracing_page.dart';

class NepaliTracingApp extends StatelessWidget {
  const NepaliTracingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nepali Letter Tracing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const LetterSelectionScreen(),
    );
  }
}

class LetterSelectionScreen extends StatefulWidget {
  const LetterSelectionScreen({super.key});

  @override
  State<LetterSelectionScreen> createState() => _LetterSelectionScreenState();
}

class _LetterSelectionScreenState extends State<LetterSelectionScreen> {
  List<NepaliLetter> letters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLetters();
  }

  Future<void> _loadLetters() async {
    final loadedLetters = await LetterService.loadLetters();
    setState(() {
      letters = loadedLetters;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Nepali Letter'),
        backgroundColor: Colors.deepOrange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: letters.length,
              itemBuilder: (context, index) {
                final letter = letters[index];
                return _buildLetterCard(letter);
              },
            ),
    );
  }

  Widget _buildLetterCard(NepaliLetter letter) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => NewLetterTracingPage(letter: letter),
        //   ),
        // );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              letter.letter,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              letter.name,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
