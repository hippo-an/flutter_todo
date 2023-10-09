import 'package:flutter/material.dart';
import 'package:todo_todo/core/models/user_model.dart';
import 'package:todo_todo/core/services/repository/user_repository.dart';
import 'package:todo_todo/locator.dart';

class SignUpViewModel extends ChangeNotifier {
  late final UserRepository _userRepository;
  SignUpViewModel() : _userRepository = locator<UserRepository>();

  Future<void> createUser(String uid, String identity) async {
    await _userRepository.createUser(
      UserModel(
        userId: uid,
        identity: identity,
        createdAt: DateTime.now(),
      ),
    );
  }
}
