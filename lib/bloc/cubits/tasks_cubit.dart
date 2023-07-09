import 'dart:convert';
import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_todo/bloc/states/tasks_states.dart';
import 'package:new_todo/models/tasksmodel.dart';
import 'package:new_todo/utils/ui_states_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksCubit extends Cubit<TasksStates> {
  TasksCubit(this.sp) : super(InitialTasksState());

  static TasksCubit get(context) => BlocProvider.of(context);
  final SharedPreferences sp;
  List<TasksModels> tasksList = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime howStill = DateTime(2025);
  bool isDone = false;
  //AnimationController isDoneAnimation= AnimationController(duration: Duration(seconds: 2),vsync: );
  int currentIndex = -1;
  UIStateEnum uiStateEnum = UIStateEnum.add;

  void changeIsDoneEvent(bool val) {
    isDone = val;
    emit(RefreshUITasksStates());
  }

  void clearEvent() {
    titleController.text = "";
    desController.text = "";
    dateController.text = "";
    timeController.text = "";

    isDone = false;
    uiStateEnum = UIStateEnum.add;
    emit(RefreshUITasksStates());
  }

  void fillEvent(TasksModels tasksModels, int index) {
    titleController.text = tasksModels.title;
    dateController.text = tasksModels.date;
    timeController.text = tasksModels.time;
    desController.text = tasksModels.description ?? "";
    isDone = tasksModels.isDone;
    uiStateEnum = UIStateEnum.edit;
    currentIndex = index;
    emit(RefreshUITasksStates());
  }

  Future<void> editEvent() async {
    if (currentIndex != -1) {
      tasksList[currentIndex].title = titleController.text.trim();
      tasksList[currentIndex].description =
          desController.text.trim() == "" ? null : desController.text.trim();
      tasksList[currentIndex].date = dateController.text.trim();
      tasksList[currentIndex].time = timeController.text.trim();
      tasksList[currentIndex].isDone = isDone;
      await saveData();
      emit(RefreshUITasksStates());
    }
  }

  Future<void> addNewTaskEvent() async {
    TasksModels tm = TasksModels(
      title: titleController.text.trim(),
      isDone: isDone,
      date: dateController.text.trim(),
      time: timeController.text.trim(),
      description: desController.text.trim(),
    );
    tasksList.add(tm);
    currentIndex = -1;
    await saveData();
    emit(RefreshUITasksStates());
  }

  Future<void> deleteTaskEvent(int index) async {
    tasksList.remove(tasksList[index]);

    await saveData();
    emit(RefreshUITasksStates());
    getDate();
  }

  Future<void> changeIsDone(bool val, int index) async {
    tasksList[index].isDone = val;
    await saveData();
    getDate();
  }

  String still(DateTime dateTime) {
    if (DateTime.now().year.toString() == dateTime.year.toString()) {
      if (DateTime.now().month.toString() == dateTime.month.toString()) {
        if (DateTime.now().day.toString() == dateTime.day.toString()) {
          return dateTime.day.toString();
        } else {
          return dateTime.month.toString();
        }
      } else {
        return dateTime.year.toString();
      }
    }

    emit(RefreshUITasksStates());
    return "";
  }

  Future<void> saveData() async {
    List<Map<String, dynamic>> tasksAsJson = [];
    List<String> tasksAsString = [];
    for (var element in tasksList) {
      tasksAsJson.add(element.toJson());
    }
    for (var element in tasksAsJson) {
      tasksAsString.add(jsonEncode(element));
    }
    bool res = await sp.setStringList('tasks', tasksAsString);
    emit(RefreshUITasksStates());
  }

  void getDate() {
    List<String> tasksAsString = [];
    List<Map<String, dynamic>> tasksAsJson = [];
    tasksList.clear();
    tasksAsString = sp.getStringList('tasks') ?? [];
    for (var element in tasksAsString) {
      tasksAsJson.add(jsonDecode(element));
    }
    for (var element in tasksAsJson) {
      tasksList.add(TasksModels.fromJson(element));
      emit(RefreshUITasksStates());
    }
  }
}
