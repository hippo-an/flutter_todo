import 'dart:ui';

import 'package:flutter/material.dart';

enum Urgent {
  urgent,
  notUrgent,
}

extension UrgentExtension on Urgent {
  ({String koVal, Color color}) get properties {
    return switch(this) {
      Urgent.urgent => (koVal: "긴급", color: Colors.redAccent),
      Urgent.notUrgent => (koVal: "긴급하지 않음", color: Colors.black)
    };
  }
}

enum Importance {
  importance,
  notImportance
}

extension ImportanceExtension on Importance {
  ({String koVal, Color color}) get properties {
    return switch(this) {
      Importance.importance => (koVal: "중요", color: Colors.redAccent),
      Importance.notImportance => (koVal: "중요하지 않음", color: Colors.black)
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
  ({String koVal, Color color}) get properties {
    return switch(this) {
      Priority.strongest => (koVal: "가장 높음", color: Colors.redAccent),
      Priority.strong => (koVal: "높음", color: Colors.yellowAccent),
      Priority.normal => (koVal: "보통", color: Colors.greenAccent),
      Priority.weak => (koVal: "하위", color: Colors.blueAccent),
      Priority.weakest => (koVal: "가장 하위", color: Colors.purpleAccent),
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
  ({String koVal, Color color}) get properties {
    return switch(this) {
      Progression.ready => (koVal: "준비중", color: Colors.grey),
      Progression.progress => (koVal: "진행중", color: Colors.blueAccent),
      Progression.done => (koVal: "완료", color: Colors.greenAccent),
      Progression.abort => (koVal: "수행 안함", color: Colors.redAccent),
    };
  }
}