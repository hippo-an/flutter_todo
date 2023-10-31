import 'package:todo_todo/enums.dart';

class TaskTabOpenController {
  bool pastOpen = true;
  bool todayOpen = true;
  bool futureOpen = true;
  bool completeTodayOpen = true;

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
    pastOpen = true;
    todayOpen = true;
    futureOpen = true;
    completeTodayOpen = true;
  }
}
