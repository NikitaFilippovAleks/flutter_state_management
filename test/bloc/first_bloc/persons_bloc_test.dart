import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:vanillacontacts_course/bloc/first_bloc/bloc/bloc_actions.dart';

import 'package:vanillacontacts_course/bloc/first_bloc/bloc/person.dart';
import 'package:vanillacontacts_course/bloc/first_bloc/bloc/persons_bloc.dart';

const mockedPersons1 = [
  Person(
    name: 'Foo 1',
    age: 20
  ),
  Person(
    name: 'Foo 1',
    age: 30
  )
];

const mockedPersons2 = [
  Person(
    name: 'Foo 2',
    age: 20
  ),
  Person(
    name: 'Foo 2',
    age: 30
  )
];

Future<Iterable<Person>> mockGetPersons1(String _) =>
  Future.value(mockedPersons1);

Future<Iterable<Person>> mockGetPersons2(String _) =>
  Future.value(mockedPersons2);

void main() {
  group('Testing bloc', () {
    late PersonsBloc bloc;

    setUp(() {
      bloc = PersonsBloc();
    });

    blocTest<PersonsBloc, FetchResult?>(
      'Test initial state',
      build: () => bloc,
      verify: (bloc) => expect(bloc.state, null),
    );

    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving persons from first iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const LoadPersonsAction(
          url: 'fake_url_1',
          loader: mockGetPersons1,
        ));

        bloc.add(const LoadPersonsAction(
          url: 'fake_url_1',
          loader: mockGetPersons1,
        ));
      },
      expect: () => [
        const FetchResult(
          persons: mockedPersons1,
          isRetrievedFromCache: false,
        ),
        const FetchResult(
          persons: mockedPersons1,
          isRetrievedFromCache: true,
        )
      ],
    );

    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving persons from second iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(const LoadPersonsAction(
          url: 'fake_url_2',
          loader: mockGetPersons2,
        ));

        bloc.add(const LoadPersonsAction(
          url: 'fake_url_2',
          loader: mockGetPersons2,
        ));
      },
      expect: () => [
        const FetchResult(
          persons: mockedPersons2,
          isRetrievedFromCache: false,
        ),
        const FetchResult(
          persons: mockedPersons2,
          isRetrievedFromCache: true,
        )
      ],
    );
  });
}
