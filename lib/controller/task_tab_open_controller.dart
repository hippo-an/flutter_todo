import 'package:todo_todo/enums.dart';

class TaskTabOpenController {
  bool pastOpen = false;
  bool todayOpen = false;
  bool futureOpen = false;
  bool completeTodayOpen = false;

  bool changeState(TaskListBlockState taskListBlockState) {
    switch (taskListBlockState) {
      case TaskListBlockState.past:
        pastOpen = !pastOpen;
        return pastOpen;
      case TaskListBlockState.today:
        todayOpen = !todayOpen;
        return todayOpen;
      case TaskListBlockState.future:
        futureOpen = !futureOpen;
        return futureOpen;
      case TaskListBlockState.complete:
        completeTodayOpen = !completeTodayOpen;
        return completeTodayOpen;
    }
  }

  void init() {
    pastOpen = false;
    todayOpen = false;
    futureOpen = false;
    completeTodayOpen = false;
  }
}
