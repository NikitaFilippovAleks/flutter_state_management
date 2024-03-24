import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

String now() => DateTime.now().toIso8601String();

@immutable
class Seconds {
  final String value = now();
}

@immutable
class Minutes {
  final String value = now();
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home page'),),
      body: MultiProvider(
        providers: [
          StreamProvider.value(
            value: Stream<Seconds>.periodic(
              const Duration(seconds: 1),
              (_) => Seconds(),
            ),
            initialData: Seconds(),
          ),
          StreamProvider.value(
            value: Stream<Minutes>.periodic(
              const Duration(seconds: 5),
              (_) => Minutes(),
            ),
            initialData: Minutes(),
          ),
        ],
        child: const Row(children: [
          SecondsWidget(),
          MinutesWidget()
        ],),
      ),
    );
  }
}

class SecondsWidget extends StatelessWidget {
  const SecondsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // print('Seconds rebuild');
    final seconds = context.watch<Seconds>();

    return Expanded(
      child: Container(
        height: 100,
        color: Colors.green,
        child: Text(seconds.value),
      )
    );
  }
}

class MinutesWidget extends StatelessWidget {
  const MinutesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // print('Minutes rebuild');
    final minutes = context.watch<Minutes>();

    return Expanded(
      child: Container(
        height: 100,
        color: Colors.pink[200],
        child: Text(minutes.value),
      )
    );
  }
}
