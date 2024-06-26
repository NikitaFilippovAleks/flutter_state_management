import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vanillacontacts_course/bloc/first_bloc/bloc/bloc_actions.dart';
import 'package:vanillacontacts_course/bloc/first_bloc/bloc/person.dart';
import 'dart:developer' as devtools show log;

import 'package:vanillacontacts_course/bloc/first_bloc/bloc/persons_bloc.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

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
      home: BlocProvider(
        create: (_) => PersonsBloc(),
        child: const HomePage()
      ),
    );
  }
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
  .getUrl(Uri.parse(url))
  .then((req) => req.close())
  .then((resp) => resp.transform(utf8.decoder).join())
  .then((str) => json.decode(str) as List<dynamic>)
  .then((list) => list.map((e) => Person.fromJson(e)));

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home page'),),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(
                    const LoadPersonsAction(
                      url: persons1Url,
                      loader: getPersons
                    )
                  );
                },
                child: const Text('Load json #1')
              ),
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(
                    const LoadPersonsAction(
                      url: persons2Url,
                      loader: getPersons
                    )
                  );
                },
                child: const Text('Load json #2')
              )
            ],
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
            buildWhen: (previous, current) {
              return previous?.persons != current?.persons;
            },
            builder:(context, fetchResult) {
              fetchResult?.log();
              final persons = fetchResult?.persons;
              if (persons == null) {
                return const SizedBox();
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final person = persons[index]!;
                    return ListTile(title: Text(person.name),);
                  }
                )
              );
            },
          )
        ],
      ),
    );
  }
}
