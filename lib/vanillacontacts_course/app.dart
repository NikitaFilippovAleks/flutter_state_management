import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
      routes: {
        '/new-contact':(context) => const NewContactView()
      },
    );
  }
}

class Contact {
  final String id = const Uuid().v4();
  final String name;

  Contact({required this.name});
}

// class Contact {
//   final String id;
//   final String name;

//   Contact({required this.name}) : id = const Uuid().v4();
// }

class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._sharedInstance() : super([Contact(name: "ffff")]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  int get length => value.length;

  void add({ required Contact contact }) {
    // final contacts = [...value];
    // contacts.add(contact);
    // value = contacts;

    value.add(contact);
    notifyListeners();
  }

  void remove({ required Contact contact }) {
    // _contacts.remove(contact);
    if (value.contains(contact)) {
      // final contacts = [...value];
      // contacts.remove(contact);
      // value = contacts;

      value.remove(contact);
      notifyListeners();
    }
  }

  Contact? contact({required int atIndex}) => value.length > atIndex ? value[atIndex] : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final contactBook = ContactBook();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue,
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder:(context, value, child) {
          final contacts = value;

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];

              return Dismissible(
                key: ValueKey(contact.id),
                onDismissed: (direction) {
                  // contacts.remove(contact);
                  ContactBook().remove(contact: contact);
                },
                child: Material(
                  color: Colors.white,
                  elevation: 6,
                  child: ListTile(
                    title: Text(contact.name),
                  ),
                )
              );
              // return ListTile(
              //   title: Text(contact.name),
              // );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/new-contact');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
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
      appBar: AppBar(
        title: Text('Add a new contact'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter a new contact name here...'
            ),
          ),
          TextButton(
            onPressed: () {
              final contact = Contact(name: _controller.text);
              ContactBook().add(contact: contact);
              Navigator.of(context).pop();
            },
            child: const Text('Add contact')
          )
        ],
      ),
    );
  }
}
