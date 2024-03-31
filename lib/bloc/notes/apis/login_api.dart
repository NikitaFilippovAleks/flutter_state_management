import 'package:flutter/foundation.dart' show immutable;

import '../models.dart';

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({
    required String login,
    required String password,
  });
}

@immutable
class LoginApi implements LoginApiProtocol {
  // singleton pattern
  const LoginApi._sharedInstance();
  static const LoginApi _shared = LoginApi._sharedInstance();
  factory LoginApi.instance() => _shared;

  @override
  Future<LoginHandle?> login({
    required String login,
    required String password,
  }) {
    
  }

}
