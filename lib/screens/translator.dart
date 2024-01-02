import 'dart:io';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'space_invaders_game.dart';
import 'tictactoe.dart';

class TranslatorApp extends StatefulWidget {
  const TranslatorApp({super.key});

  @override
  State<TranslatorApp> createState() => _TranslatorAppState();
}

class _TranslatorAppState extends State<TranslatorApp> {
  final translator = GoogleTranslator();
  final TextEditingController controller = TextEditingController(text: 'Hello!');
  bool isLoading = false;
  String translatedText = '';
  String fromLanguageCode = 'en';
  String toLanguageCode = 'ru';

  List<String> languages = [
    'English',
    'Estonian',
    'Arabic',
    'German',
    'Russian',
    'Spanish',
    'Japanese',
    'Italian'
  ];

  List<String> languageCodes = [
    'en',
    'et',
    'ar',
    'de',
    'ru',
    'es',
    'ja',
    'it'
  ];

  Future<void> translate() async {
    if (controller.text.isEmpty) {
      showSnackbar('Please enter some text', Colors.red);
      return;
    }

    setState(() => isLoading = true);

    try {
      var translation = await translator.translate(controller.text, from: fromLanguageCode, to: toLanguageCode);
      setState(() => translatedText = translation.text);
    } on SocketException {
      showSnackbar('Internet not connected', Colors.red);
    } catch (e) {
      showSnackbar('Error: ${e.toString()}', Colors.red);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSnackbar(String content, Color color) {
    final snackbar = SnackBar(content: Text(content), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Translator App'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LanguageDropdown(
                label: 'From',
                value: languages[languageCodes.indexOf(fromLanguageCode)],
                items: languages,
                onChanged: (value) {
                  setState(() => fromLanguageCode = languageCodes[languages.indexOf(value)]);
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: controller,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Enter Text',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              LanguageDropdown(
                label: 'To',
                value: languages[languageCodes.indexOf(toLanguageCode)],
                items: languages,
                onChanged: (value) {
                  setState(() => toLanguageCode = languageCodes[languages.indexOf(value)]);
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: translate,
                child: const Text(
                  'Translate',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SelectableText(
                  translatedText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),

          Padding(
            padding: const EdgeInsets.only(top: 20), // Adjust the padding as needed
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => SpaceInvadersGame()));
                },
                child: const Text(
                  'Play Space Invaders',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
             ),

              Padding(
                padding: const EdgeInsets.only(top: 20), // Adjust the padding as needed
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => TicTacToe()));
                  },
                  child: const Text(
                    'Play Tic Tac Toe',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Choose a color that fits your app design
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const LanguageDropdown({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }
}
