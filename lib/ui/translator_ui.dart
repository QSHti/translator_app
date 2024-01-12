import 'package:flutter/material.dart';
import '../model/translator_model.dart';

class TranslatorApp extends StatefulWidget {
  @override
  _TranslatorAppState createState() => _TranslatorAppState();
}

class _TranslatorAppState extends State<TranslatorApp> {
  final TranslatorModel model = TranslatorModel();
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translator'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Language selection
              _buildLanguageDropdown('From', model.fromLanguageCode, model.setFromLanguage),
              SizedBox(height: 8),
              _buildLanguageDropdown('To', model.toLanguageCode, model.setToLanguage),
              SizedBox(height: 16), // Added space

              // Text input field
              TextFormField(
                controller: textController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Enter text to translate',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16), // Added space

              // Translate button
              ElevatedButton(
                onPressed: () async {
                  await model.translate(textController.text);
                  setState(() {});
                },
                child: Text(
                    'Translate',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white // Set the text color to white
                    )
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              SizedBox(height: 24), // Added space

              // Translation result
              Text(
                'Translation:',
                style: Theme.of(context).textTheme.headline6,
              ),
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.grey[200],
                child: Text(
                  model.translatedText,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 24), // Added space

              // Translation history
              Text(
                'History:',
                style: Theme.of(context).textTheme.headline6,
              ),
              _buildTranslationHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(String label, String selectedCode, Function(String) onChanged) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCode, // Ensuring the value matches one of the items
          isExpanded: true,
          items: model.languages.map<DropdownMenuItem<String>>((String language) {
            String languageCode = model.languageCodes[model.languages.indexOf(language)];
            return DropdownMenuItem<String>(
              value: languageCode,
              child: Text(language),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  Widget _buildTranslationHistory() {
    if (model.translationHistory.isEmpty) {
      return Text('No translations yet.');
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: model.translationHistory.length,
      itemBuilder: (context, index) {
        var historyItem = model.translationHistory[index];
        return ListTile(
          title: Text(historyItem['input'] ?? ''),
          subtitle: Text(historyItem['output'] ?? ''),
          trailing: Text('From ${historyItem['from']} to ${historyItem['to']}'),
        );
      },
    );
  }
}
