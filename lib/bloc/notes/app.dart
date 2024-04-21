import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vanillacontacts_course/bloc/notes/apis/login_api.dart';
import 'package:vanillacontacts_course/bloc/notes/apis/notes_api.dart';
import 'package:vanillacontacts_course/bloc/notes/bloc/actions.dart';
import 'package:vanillacontacts_course/bloc/notes/bloc/app_bloc.dart';
import 'package:vanillacontacts_course/bloc/notes/bloc/app_state.dart';
import 'package:vanillacontacts_course/bloc/notes/dialogs/generic_dialog.dart';
import 'package:vanillacontacts_course/bloc/notes/dialogs/loading/screen.dart';
import 'package:vanillacontacts_course/bloc/notes/models.dart';
import 'package:vanillacontacts_course/bloc/notes/strings.dart';
import 'package:vanillacontacts_course/bloc/notes/views/iterable_list_view.dart';
import 'package:vanillacontacts_course/bloc/notes/views/login_view.dart';

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            // loading screen
            if (state.isLoading) {
              LoadingScreen().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen().hide();
            }

            // display possible errors
            final loginError = state.loginErrors;
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {ok: true},
              );
            }

            // if we are logged in, but we have no fetched notes, fetch them now
            if (
              state.isLoading == false &&
              state.loginErrors == null &&
              state.loginHandle == const LoginHandle.fooBar() &&
              state.fetchedNotes == null
            ) {
              context.read<AppBloc>().add(const LoadNotesAction());
            }
          },
          builder: (context, state) {
            final notes = state.fetchedNotes;

            if (notes == null) {
              return LoginView((email, password) {
                context.read<AppBloc>().add(
                  LoginAction(email: email, password: password),
                );
              });
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
