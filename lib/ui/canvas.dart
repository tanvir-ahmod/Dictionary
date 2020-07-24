import 'dart:convert';
import 'dart:io';

import 'package:dictionary/ui/background.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'dart:ui' as ui;

import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';

class CustomCanvas extends StatefulWidget {
  @override
  _CustomCanvasState createState() => _CustomCanvasState();
}

class _CustomCanvasState extends State<CustomCanvas> {
  ByteData _img = ByteData(0);

  var color = Colors.blueAccent;

  var strokeWidth = 5.0;

  final _sign = GlobalKey<SignatureState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(4.0, 4.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'English',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(width: 50),
            Icon(
              Icons.arrow_right,
              size: 50,
            ),
            SizedBox(width: 50),
            Text(
              'Bangla',
              style: TextStyle(fontSize: 30),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Divider(
          color: Colors.black12,
          height: 1,
          thickness: 1,
          indent: 1,
          endIndent: 0,
        ),
        Expanded(
          child: Signature(
            key: _sign,
            color: color,
            backgroundPainter: _WatermarkPaint("2.0", "2.0"),
            strokeWidth: strokeWidth,
          ),
        ),
        Divider(
          color: Colors.black12,
          height: 1,
          thickness: 1,
          indent: 1,
          endIndent: 0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.search, size: 40, color: Hexcolor('3f51b5')),
                onPressed: () async {
                  _detectText();
                }),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.clear, size: 40, color: Hexcolor('3f51b5')),
              onPressed: () {
                _sign.currentState.clear();
                setState(() {
                  _img = ByteData(0);
                });
              },
            ),
            SizedBox(width: 40),
          ],
        ),
        SizedBox(
          height: 5,
        ),

      ]),
    );
  }

  void _detectText() async {
    final sign = _sign.currentState;
    final image = await sign.getData();
    var data = await image.toByteData(format: ui.ImageByteFormat.png);

    setState(() {
      _img = data;
    });

    // Temporary saving file
    final directory = await getApplicationDocumentsDirectory();
    final imageFile = File('${directory.path}/my_file.jpg');
    await imageFile.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(imageFile);

    TextRecognizer textRecogniser = FirebaseVision.instance.textRecognizer();
    VisionText visionText =
        await textRecogniser.processImage(firebaseVisionImage);
    for (TextBlock textBlock in visionText.blocks) {
      for (TextLine line in textBlock.lines) {
        for (TextElement word in line.elements) {
          print('word ${word.text}');
        }
      }
    }
  }
}

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {

  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}
