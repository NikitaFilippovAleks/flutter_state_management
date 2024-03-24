import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ObjectProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
        ),
        home: const HomePage(),
      ),
    );
  }
}

@immutable
class BaseObject {
  final String id = const Uuid().v4();
  final String lastUpdated = DateTime.now().toIso8601String();

  @override
  bool operator ==(covariant BaseObject other) => id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}

@immutable
class ExpensiveObject extends BaseObject {}

@immutable
class CheapObject extends BaseObject {}

class ObjectProvider extends ChangeNotifier {
  String id = const Uuid().v4();
  CheapObject _cheapObject = CheapObject();
  late StreamSubscription _cheapObjectStreamSubs;
  ExpensiveObject _expensiveObject = ExpensiveObject();
  late StreamSubscription _expensiveObjectStreamSubs;

  ObjectProvider() {
    start();
  }

  CheapObject get cheapObject => _cheapObject;
  ExpensiveObject get expensiveObject => _expensiveObject;

  @override
  void notifyListeners() {
    id = const Uuid().v4();
    super.notifyListeners();
  }

  void start() {
    _cheapObjectStreamSubs = Stream.periodic(
      const Duration(seconds: 1)
    ).listen((_) {
      _cheapObject = CheapObject();
      notifyListeners();
    });

    _expensiveObjectStreamSubs = Stream.periodic(
      const Duration(seconds: 10)
    ).listen((_) {
      _expensiveObject = ExpensiveObject();
      notifyListeners();
    });
  }

  void stop() {
    _cheapObjectStreamSubs.cancel();
    _expensiveObjectStreamSubs.cancel();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home page'),),
      body: Column(
        children: [
          const Row(
            children: [
              Expanded(child: CheapWidget()),
              Expanded(child: ExpensiveWidget()),
            ],
          ),
          const Row(
            children: [
              Expanded(child: ObjectProviderWidget())
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.read<ObjectProvider>().start();
                },
                child: const Text('Start'),
              ),
              TextButton(
                onPressed: () {
                  context.read<ObjectProvider>().stop();
                },
                child: const Text('Stop'),
              )
            ],
          )
        ],
      )
    );
  }
}

class CheapWidget extends StatelessWidget {
  const CheapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // print('Cheap widget rebuild');
    final cheapObject = context.select<ObjectProvider, CheapObject>(
      (provider) => provider.cheapObject
    );

    return Container(
      height: 100,
      color: Colors.pink[200],
      child: Column(
        children: [
          const Text('Cheap widget'),
          const Text('Last updated'),
          Text(cheapObject.lastUpdated)
        ],
      ),
    );
  }
}

class ExpensiveWidget extends StatelessWidget {
  const ExpensiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // print('Expensive widget rebuild');
    final expensiveObject = context.select<ObjectProvider, ExpensiveObject>(
      (provider) => provider.expensiveObject
    );

    return Container(
      height: 100,
      color: Colors.green,
      child: Column(
        children: [
          const Text('Expensive widget'),
          const Text('Last updated'),
          Text(expensiveObject.lastUpdated)
        ],
      ),
    );
  }
}

class ObjectProviderWidget extends StatelessWidget {
  const ObjectProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // print('Object widget rebuild');
    final provider = context.watch<ObjectProvider>();

    return Container(
      height: 100,
      color: Colors.purple,
      child: Column(
        children: [
          const Text('Object Provider widget'),
          const Text('ID'),
          Text(provider.id)
        ],
      ),
    );
  }
}
