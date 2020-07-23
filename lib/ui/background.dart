import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Background extends StatelessWidget {
  static final bluishColor = Hexcolor('#5e35b1');
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            color: bluishColor,
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Text(
                  'Dictionary',
                  style: TextStyle(fontSize: 34.0, color: Colors.white),
                ),
              ],
            )),
        Expanded(
            child: Container(
          color: Colors.white12,
          height: MediaQuery.of(context).size.height,
        )),
      ],
    );
  }
}
