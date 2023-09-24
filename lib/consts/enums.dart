import 'package:flutter/material.dart';

enum CategoryState { seen, hide }

enum TaskListSectionState {
  past, today, future, complete
}
extension TaskListSectionStateExtension on TaskListSectionState {
  String get mappingValue {
    return switch (this) {
      TaskListSectionState.past => 'Past',
      TaskListSectionState.today => 'Today',
      TaskListSectionState.future => 'Future',
      TaskListSectionState.complete => 'Complete today',
    };
  }
}

enum ColorType {
  red([244, 67, 54]),
  pink([233, 30, 99]),
  deepOrange([255, 87, 34]),
  orange([255, 152, 0]),
  amber([255, 193, 7]),
  yellow([255, 235, 59]),
  lightGreen([139, 195, 74]),
  green([76, 175, 80]),
  teal([0, 150, 136]),
  cyan([0, 188, 212]),
  lightBlue([3, 169, 244]),
  blue([33, 150, 243]),
  navy([33, 64, 243]),
  purple([156, 39, 176]),
  deepPurple([103, 58, 183]),
  white([206, 206, 206]),
  grey([100, 100, 100]),
  black([49, 49, 49]);

  final List<int> rgb;

  const ColorType(this.rgb);
}

enum Urgent {
  urgent,
  notUrgent,
}

extension UrgentExtension on Urgent {
  ({Color color, IconData iconData}) get properties {
    return switch (this) {
      Urgent.urgent => (color: Colors.red[500]!, iconData: Icons.warning_amber),
      Urgent.notUrgent => (color: Colors.black, iconData: Icons.do_not_disturb_on_outlined),
    };
  }
}

enum Importance { importance, notImportance }

extension ImportanceExtension on Importance {
  ({Color color, IconData iconData}) get properties {
    return switch (this) {
      Importance.importance => (color: Colors.red[500]!, iconData: Icons.star),
      Importance.notImportance => (color: Colors.black,  iconData: Icons.star_border_outlined)
    };
  }
}

enum Priority {
  strongest,
  strong,
  normal,
  weak,
  weakest,
}

extension PriorityExtension on Priority {
  ({Color color, IconData iconData}) get properties {
    return switch (this) {
      Priority.strongest => (color: Colors.red[500]!, iconData: Icons.signal_wifi_4_bar_sharp),
      Priority.strong => (color: Colors.orange[500]!, iconData: Icons.network_wifi_3_bar_sharp),
      Priority.normal => (color: Colors.green[500]!, iconData: Icons.network_wifi_2_bar_sharp),
      Priority.weak => (color: Colors.black, iconData: Icons.network_wifi_1_bar_sharp),
      Priority.weakest => (color: Colors.grey[500]!, iconData: Icons.signal_wifi_0_bar_sharp),
    };
  }
}

enum Progression {
  ready,
  progress,
  done,
  abort,
}

extension ProgressionExtension on Progression {
  ({Color color, IconData iconData}) get properties {
    return switch (this) {
      Progression.ready => (color: Colors.grey[500]!, iconData: Icons.upcoming),
      Progression.progress => ( color: Colors.blue[500]!, iconData: Icons.update),
      Progression.done => (color: Colors.green[500]!, iconData: Icons.done_all),
      Progression.abort => (color: Colors.red[500]!, iconData: Icons.pause),
    };
  }
}
