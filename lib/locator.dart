import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_todo/controller/auth_controller.dart';
import 'package:todo_todo/controller/category_controller.dart';
import 'package:todo_todo/repository/auth_repository.dart';
import 'package:todo_todo/repository/category_repository.dart';
import 'package:todo_todo/repository/user_repository.dart';

final locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(
    () => AuthRepository(auth: FirebaseAuth.instance),
  );

  locator.registerLazySingleton(
    () => UserRepository(firestore: FirebaseFirestore.instance),
  );

  locator.registerLazySingleton(
    () => CategoryRepository(firestore: FirebaseFirestore.instance),
  );

  locator.registerLazySingleton(
        () => CategoryController(
      authRepository: locator<AuthRepository>(),
      categoryRepository: locator<CategoryRepository>(),
    ),
  );

  locator.registerLazySingleton(
    () => AuthController(
      authRepository: locator<AuthRepository>(),
      firestoreRepository: locator<UserRepository>(),
      categoryController: locator<CategoryController>(),
    ),
  );

}
