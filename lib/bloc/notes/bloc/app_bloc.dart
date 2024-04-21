
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vanillacontacts_course/bloc/notes/apis/login_api.dart';
import 'package:vanillacontacts_course/bloc/notes/apis/notes_api.dart';
import 'package:vanillacontacts_course/bloc/notes/bloc/actions.dart';
import 'package:vanillacontacts_course/bloc/notes/bloc/app_state.dart';
import 'package:vanillacontacts_course/bloc/notes/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginAction>((event, emit) async {
      // start loading
      emit(
        const AppState(
          isLoading: true,
          loginErrors: null,
          loginHandle: null,
          fetchedNotes: null,
        ),
      );

      // log the user in
      final loginHandle = await loginApi.login(email: event.email, password: event.password);

      emit(
        AppState(
          isLoading: false,
          loginErrors: loginHandle == null ? LoginErrors.invalidHandle : null,
          loginHandle: loginHandle,
          fetchedNotes: null,
        ),
      );
    });

    on<LoadNotesAction>((event, emit) async {
      final loginHandle = state.loginHandle;

      emit(
        AppState(
          isLoading: true,
          loginErrors: null,
          loginHandle: loginHandle,
          fetchedNotes: null,
        ),
      );

      if (loginHandle != const LoginHandle.fooBar()) {
        emit(
          AppState(
            isLoading: false,
            loginErrors: LoginErrors.invalidHandle,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );

        return;
      }

      final notes = await notesApi.getNotes(loginHandle: loginHandle!);
      emit(
        AppState(
          isLoading: false,
          loginErrors: null,
          loginHandle: loginHandle,
          fetchedNotes: notes,
        ),
      );
    });
  }
}
