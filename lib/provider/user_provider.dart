import 'package:flutter/material.dart';
import 'package:todo_todo/models/user_model.dart';
import 'package:todo_todo/repository/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository userRepository;
  UserModel? _loginUser;

  UserProvider(this.userRepository);

  UserModel? get loginUser => _loginUser;

  void updateLoginUser(UserModel? loginUser) {
    _loginUser = loginUser;
    notifyListeners();
  }

  Future<UserModel> fetchUserById(String uid) async {
    return await userRepository.fetchUserById(uid);
  }

  void createUser(String uid, String identity) async {
    await userRepository.createUser(
      UserModel(
        userId: uid,
        identity: identity,
        createdAt: DateTime.now(),
      ),
    );
  }
}
