import 'package:flutter/foundation.dart' show immutable;
import 'package:vanillacontacts_course/bloc/first_bloc/bloc/person.dart';

const persons1Url = 'http://127.0.0.1:5500/api/persons1.json';
const persons2Url = 'http://127.0.0.1:5500/api/persons2.json';

// enum PersonUrl {
//   persons1,
//   persons2
// }

// extension UrlString on PersonUrl {
//   String get urlString {
//     switch (this) {
//       case PersonUrl.persons1:
//         return 'http://127.0.0.1:5500/api/persons1.json';
//       case PersonUrl.persons2:
//         return 'http://127.0.0.1:5500/api/persons2.json';
//     }
//   }
// }

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonsLoader loader;

  const LoadPersonsAction({
    required this.url,
    required this.loader
  });
}
