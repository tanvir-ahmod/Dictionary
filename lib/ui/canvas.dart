import 'dart:io';

import 'package:dictionary/bloc/dictionary_bloc.dart';
import 'package:dictionary/bloc/dictionary_event.dart';
import 'package:dictionary/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'dart:ui' as ui;

import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';

class CustomCanvas extends StatefulWidget {
  @override
  _CustomCanvasState createState() => _CustomCanvasState();
}

class _CustomCanvasState extends State<CustomCanvas> {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'English',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 20),
            Icon(
              Icons.arrow_right,
              size: 50,
            ),
            SizedBox(width: 20),
            Text(
              'Bangla',
              style: TextStyle(fontSize: 20),
            )
          ],
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
            color: Constants.PEN_COLOR,
            backgroundPainter: _WatermarkPaint(),
            strokeWidth: Constants.STROKE_WIDTH,
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
                icon: Icon(Icons.search,
                    size: 30,
                    color: Hexcolor(Constants.BUTTON_BACKGROUND_COLOR)),
                onPressed: () async {
                  File imageFile = await _getDrawnImage();
                  BlocProvider.of<DictionaryBloc>(context)
                      .add(GetMeaning(imageFile));
                }),
            IconButton(
              icon: Icon(Icons.clear,
                  size: 30, color: Hexcolor(Constants.BUTTON_BACKGROUND_COLOR)),
              onPressed: () {
                _sign.currentState.clear();
                BlocProvider.of<DictionaryBloc>(context).add(ClearMeaning());
              },
            ),
            SizedBox(width: 20),
          ],
        ),
      ]),
    );
  }

  Future<File> _getDrawnImage() async {
    final sign = _sign.currentState;
    final image = await sign.getData();
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    final directory = await getApplicationDocumentsDirectory();
    final imageFile = File('${directory.path}/drawn_word.jpg');
    await imageFile.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return imageFile;
  }
}

class _WatermarkPaint extends CustomPainter {
  @override
  void paint(ui.Canvas canvas, ui.Size size) {}

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }
}
