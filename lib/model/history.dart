import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'history.g.dart';
@HiveType(typeId: 0)
class History {
  @HiveField(0)
  String textKey;
  @HiveField(1)
  String textMeaning;

  History({@required this.textKey, @required this.textMeaning});
}
