import 'package:flutter/foundation.dart' show immutable;
import 'package:vanillacontacts_course/bloc/notes/models.dart';
import 'package:collection/collection.dart';

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginErrors;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNotes;

  const AppState({
    required this.isLoading,
    required this.loginErrors,
    required this.loginHandle,
    required this.fetchedNotes,
  });

  const AppState.empty() :
    isLoading = false,
    loginErrors = null,
    loginHandle = null,
    fetchedNotes = null;

  @override
  String toString() => {
    'isLoading': isLoading,
    'loginErrors': loginErrors,
    'loginHandle': loginHandle,
    'fetchedNotes': fetchedNotes,
  }.toString();

  @override
  bool operator ==(covariant AppState other) {
    final otherProps = isLoading == other.isLoading &&
      loginErrors == other.loginErrors &&
      loginHandle == other.loginHandle;

    if (fetchedNotes == null && other.fetchedNotes == null) {
      return otherProps;
    } else {
      return otherProps && (fetchedNotes?.isEqualTo(other.fetchedNotes) ?? false);
    }
  }
  
  @override
  int get hashCode => Object.hash(
    isLoading,
    loginErrors,
    loginHandle,
    fetchedNotes,
  );
  
}

extension UnorderedEquality on Object {
  bool isEqualTo(other) => const DeepCollectionEquality.unordered().equals(
    this,
    other,
  );
}
