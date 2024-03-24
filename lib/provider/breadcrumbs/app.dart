
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BreadCrumbsProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
        ),
        home: HomePage(),
        routes: {
          '/new': (context) => const NewBredCrumbWidget()
        },
      ),
    );
  }
}

class BreadCrumb {
  bool isActive;
  final String name;
  final String uuid = const Uuid().v4();

  BreadCrumb({required this.isActive, required this.name});

  void activate() {
    isActive = true;
  }

  @override
  bool operator ==(covariant BreadCrumb other) => uuid == other.uuid;
  
  @override
  int get hashCode => uuid.hashCode;
  
  String get title => name + (isActive ? ' > ' : '');
}

class BreadCrumbsProvider extends ChangeNotifier {
  final List<BreadCrumb> _items = [];
  UnmodifiableListView<BreadCrumb> get items => UnmodifiableListView(_items);

  void add(BreadCrumb breadCrumb) {
    for(final item in _items) {
      item.activate();
    }

    _items.add(breadCrumb);
    notifyListeners();
  }

  void reset() {
    _items.clear();
    notifyListeners();
  }
}

class BreadCrumbsWidget extends StatelessWidget {
  final UnmodifiableListView<BreadCrumb> breadCrumbs;

  const BreadCrumbsWidget({super.key, required this.breadCrumbs});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: breadCrumbs.map((breadCrumb) {
        return Text(
          breadCrumb.title,
          style: TextStyle(
            color: breadCrumb.isActive ? Colors.blue : Colors.black
          ),
        );
      }).toList(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HomePage'),),
      body: Column(
        children: [
          Consumer<BreadCrumbsProvider>(
            builder:(context, value, child) {
              return BreadCrumbsWidget(breadCrumbs: value.items);
            }
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/new');
            },
            child: Text('Add new bread crumb')
          ),
          TextButton(
            onPressed: () {
              context.read<BreadCrumbsProvider>().reset();
            },
            child: Text('Reset')
          )
        ],
      ),
    );
  }
}

class NewBredCrumbWidget extends StatefulWidget {
  const NewBredCrumbWidget({super.key});

  @override
  State<NewBredCrumbWidget> createState() => _NewBredCrumbWidgetState();
}

class _NewBredCrumbWidgetState extends State<NewBredCrumbWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add new bread crumb'),),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter breadcrumb'
            ),
          ),
          TextButton(
            onPressed: () {
              final text = _controller.text;

              if (text.isNotEmpty) {
                final breadCrumb = BreadCrumb(isActive: false, name: text);
                context.read<BreadCrumbsProvider>().add(breadCrumb);

                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }
}
