import 'package:get_it/get_it.dart';
import 'package:todo_todo/archive/core/services/auth_service.dart';
import 'package:todo_todo/archive/core/services/category_service.dart';
import 'package:todo_todo/archive/core/services/repository/category_repository.dart';
import 'package:todo_todo/archive/core/services/repository/task_repository.dart';
import 'package:todo_todo/archive/core/services/repository/user_repository.dart';
import 'package:todo_todo/archive/core/view_models/auth_view_model.dart';
import 'package:todo_todo/archive/core/view_models/category_view_model.dart';
import 'package:todo_todo/archive/core/view_models/drawer_provider.dart';
import 'package:todo_todo/archive/core/view_models/main_calendar_provider.dart';
import 'package:todo_todo/archive/core/view_models/navigation_tab_provider.dart';
import 'package:todo_todo/archive/core/view_models/task_list_section_provider.dart';
import 'package:todo_todo/archive/core/view_models/task_view_model.dart';

final locator = GetIt.I;

void setupLocator() {
  // locator.registerLazySingleton<NavigationTabProvider>(() => NavigationTabProvider());
  //
  // locator.registerLazySingleton<UserRepository>(() => UserRepository());
  // locator.registerLazySingleton<CategoryRepository>(() => CategoryRepository());
  // locator.registerLazySingleton<TaskRepository>(() => TaskRepository());
  //
  //
  // locator.registerLazySingleton<AuthViewModel>(() => AuthViewModel());
  // locator.registerLazySingleton<CategoryViewModel>(() => CategoryViewModel());
  // locator.registerLazySingleton<TaskViewModel>(() => TaskViewModel());
  //
  // locator.registerLazySingleton<CategoryService>(() => CategoryService());
  // locator.registerLazySingleton<AuthService>(() => AuthService());
  //
  // locator.registerLazySingleton<MainCalendarProvider>(() => MainCalendarProvider());
  // locator.registerLazySingleton<TaskListSectionProvider>(() => TaskListSectionProvider());
  // locator.registerLazySingleton<DrawerProvider>(() => DrawerProvider());
  //
  // locator.registerFactory<GoogleSignIn>(() => GoogleSignIn());
}