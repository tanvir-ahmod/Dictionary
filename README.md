# Dictionary

A Flutter dictionary application where you can write in english and get the meaning in bangla. The writing process here is not typing rater than its drawing. you can draw a text and the corresponding meaning will be shown to you. 

## Getting Started

For android you need to provide own `google-services.json` file. It is explained in [codelab](https://codelabs.developers.google.com/codelabs/flutter-firebase/#4) and [here](https://firebase.google.com/docs/android/setup?authuser=0).

## Technology Used

* Dart (Primary Language)
* Architecture : **BLoC**
* Libraries: 
     * [flutter_signature_pad](https://pub.dev/packages/flutter_signature_pad) : To make the canvas to draw
     * [firebase_ml_vision](https://pub.dev/packages/firebase_ml_vision) : To detect the text from the drawn image.
     * [Hive](https://pub.dev/packages/hive) : To store and retrieve bangla meaning of the text.
     * [shared_preferences](https://pub.dev/packages/shared_preferences): To check if the app is launched for the first time so that from words.txt, the database can be initialized.
     * [flutter_bloc](https://pub.dev/packages/flutter_bloc): a predictable state management library for Dart.
      