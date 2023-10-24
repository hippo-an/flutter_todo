import 'package:todo_todo/models/category_model.dart';
import 'package:todo_todo/archive/core/view_models/category_view_model.dart';
import 'package:todo_todo/archive/core/view_models/task_view_model.dart';
import 'package:todo_todo/archive/locator.dart';

class CategoryService {
  final CategoryViewModel _categoryViewModel;
  final TaskViewModel _taskViewModel;

  CategoryService()
      : _categoryViewModel = locator<CategoryViewModel>(),
        _taskViewModel = locator<TaskViewModel>();

  Future<void> initCategoryForUserSignUp() async {
    await _categoryViewModel.initCategoryForUserSignUp();
  }

  Future<void> deleteCategory(CategoryModel category) async {
    _categoryViewModel.deleteCategory(category);

    if (_categoryViewModel.selectedCategory == category) {
      _categoryViewModel.updateSelectedCategoryToDefault();
    }

    await _taskViewModel.deleteTaskByCategory(category);
  }
}
