import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_todo/core/services/auth_service.dart';
import 'package:todo_todo/core/services/repository/category_repository.dart';
import 'package:todo_todo/core/services/repository/task_repository.dart';
import 'package:todo_todo/core/services/repository/user_repository.dart';
import 'package:todo_todo/core/view_models/sign_up_view_model.dart';

final locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton<UserRepository>(() => UserRepository());
  locator.registerLazySingleton<SignUpViewModel>(() => SignUpViewModel());


  locator.registerLazySingleton<CategoryRepository>(() => CategoryRepository());
  locator.registerLazySingleton<TaskRepository>(() => TaskRepository());
  locator.registerLazySingleton<AuthService>(() => AuthService());

  locator.registerFactory<GoogleSignIn>(() => GoogleSignIn());
}