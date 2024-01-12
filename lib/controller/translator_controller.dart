import 'package:flutter/material.dart';
import '../model/translator_model.dart';

class TranslatorController {
  final TranslatorModel model;

  TranslatorController(this.model);

  void setFromLanguage(String language) {
    model.setFromLanguage(language);
  }

  void setToLanguage(String language) {
    model.setToLanguage(language);
  }

  Future<void> translate(String text) async {
    await model.translate(text);
    if (model.translatedText.isNotEmpty && text.isNotEmpty) {
      await model.addTranslationToHistory(text, model.translatedText);
    }
  }

  String get translation => model.translatedText;

  bool get isLoading => model.isLoading;

  void showSnackbar(BuildContext context, String content, Color color) {
    final snackbar = SnackBar(content: Text(content), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<List<Map<String, dynamic>>> getTranslationHistory() async {
    return await model.fetchTranslationHistory();
  }
}
