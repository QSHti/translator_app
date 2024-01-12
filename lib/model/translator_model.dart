import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:translator/translator.dart';

class TranslatorModel extends ChangeNotifier {
  final GoogleTranslator translator = GoogleTranslator();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String fromLanguageCode = 'en';
  String toLanguageCode = 'ru';
  String translatedText = '';
  bool isLoading = false;
  List<Map<String, dynamic>> translationHistory = [];

  List<String> languages = [
    'English', 'Estonian', 'Arabic', 'German', 'Russian', 'Spanish', 'Japanese', 'Italian'
  ];
  List<String> languageCodes = [
    'en', 'et', 'ar', 'de', 'ru', 'es', 'ja', 'it'
  ];

  Future<void> translate(String text) async {
    if (text.isEmpty) {
      translatedText = 'Please enter some text';
      isLoading = false;
      return;
    }

    isLoading = true;
    try {
      var translation = await translator.translate(text, from: fromLanguageCode, to: toLanguageCode);
      translatedText = translation.text;

      var historyItem = {
        'input': text,
        'output': translatedText,
        'from': fromLanguageCode,
        'to': toLanguageCode,
        'timestamp': Timestamp.now()
      };
      translationHistory.add(historyItem);
      await firestore.collection('translationHistory').add(historyItem);
    } catch (e) {
      translatedText = 'Error: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  void setFromLanguage(String language) {
    fromLanguageCode = language;
    notifyListeners();
  }

  void setToLanguage(String language) {
    toLanguageCode = language;
    notifyListeners();
  }

  Future<void> addTranslationToHistory(String input, String output) async {
    await FirebaseFirestore.instance.collection('translationHistory').add({
      'input': input,
      'output': output,
      'fromLanguage': fromLanguageCode,
      'toLanguage': toLanguageCode,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  Future<List<Map<String, dynamic>>> fetchTranslationHistory() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('translationHistory')
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
