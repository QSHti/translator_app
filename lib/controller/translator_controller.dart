import 'package:flutter/material.dart';
import '../model/translator_model.dart';

class TranslatorController {
  final TranslatorModel model;

  TranslatorController(this.model);

  // Function to update the source language in the model
  void setFromLanguage(String language) {
    model.setFromLanguage(language);
  }

  // Function to update the target language in the model
  void setToLanguage(String language) {
    model.setToLanguage(language);
  }

  // Function to perform the translation
  Future<void> translate(String text) async {
    await model.translate(text);
    if (model.translatedText.isNotEmpty && text.isNotEmpty) {
      await model.addTranslationToHistory(text, model.translatedText);
    }
  }

  // Getter to obtain the current translation
  String get translation => model.translatedText;

  // Getter to check if the translation is in progress
  bool get isLoading => model.isLoading;

  // Function to display a snack bar with a message
  void showSnackbar(BuildContext context, String content, Color color) {
    final snackbar = SnackBar(content: Text(content), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<List<Map<String, dynamic>>> getTranslationHistory() async {
    return await model.fetchTranslationHistory();
  }
}
