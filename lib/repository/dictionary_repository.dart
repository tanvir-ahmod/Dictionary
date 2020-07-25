import 'dart:io';

import 'package:dictionary/dao/dictionary_dao.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class DictionaryRepository {
  var dao = DictionaryDao();

  Future initializeDatabase() => dao.initializeDatabase();

  Future isFirstTime() => dao.isFirstTime();

  Future<String> getMeaning(File imageFile) async {
    String textFromImage = await _detectText(imageFile);
    print('recognised Text $textFromImage');
    return await dao.getMeaning(textFromImage) ;
  }

  Future<String> _detectText(File imageFile) async {
    FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(imageFile);

    TextRecognizer textRecogniser = FirebaseVision.instance.textRecognizer();
    VisionText visionText =
        await textRecogniser.processImage(firebaseVisionImage);


    for (TextBlock textBlock in visionText.blocks) {
      for (TextLine line in textBlock.lines) {
        for (TextElement word in line.elements) {
         return word.text.toLowerCase();
        }
      }
    }
    return "";
  }
}
