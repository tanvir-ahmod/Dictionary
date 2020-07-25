import 'package:dictionary/bloc/dictionary_bloc.dart';
import 'package:dictionary/bloc/dictionary_event.dart';
import 'package:dictionary/repository/dictionary_repository.dart';
import 'package:dictionary/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  final dictionaryRepository = DictionaryRepository();
  runApp(MyApp(dictionaryRepository: dictionaryRepository));
}

class MyApp extends StatelessWidget {
  final DictionaryRepository dictionaryRepository;

  MyApp({Key key, @required this.dictionaryRepository})
      : assert(dictionaryRepository != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocProvider(
          create: (context) => DictionaryBloc(repository: dictionaryRepository),
          child: MyHomePage(title: 'Flutter Demo Home Page'),
        ));
  }
}
