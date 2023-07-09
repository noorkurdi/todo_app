import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_todo/bloc/cubits/tasks_cubit.dart';
import 'package:new_todo/bloc/states/tasks_states.dart';
import 'package:new_todo/pages/add_tasks_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TasksCubit tasksCubit = TasksCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              title: Text('ToDo App',
                  style: GoogleFonts.pacifico(
                    textStyle:
                        const TextStyle(color: Colors.cyan, fontSize: 30),
                  )),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTasksPages(),
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add new task',
                style: TextStyle(color: Colors.white),
              ),
              elevation: 0,
              splashColor: Colors.white,
              focusColor: Colors.cyan,
              backgroundColor: Colors.cyan,
              hoverColor: Colors.cyan,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: Visibility(
              visible: tasksCubit.tasksList.length == 0 ? true : false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'You have no tasks :)',
                      style: TextStyle(color: Colors.cyan, fontSize: 40),
                    ),
                    Icon(
                      Icons.add,
                      size: 40,
                      color: Colors.cyan,
                    )
                  ],
                ),
              ),
              replacement: ListView.builder(
                itemCount: tasksCubit.tasksList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        tasksCubit.fillEvent(
                            tasksCubit.tasksList[index], index);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTasksPages(),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 8,
                        color: Colors.primaries[
                            Random().nextInt(Colors.primaries.length)],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 70,
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      tasksCubit.tasksList[index].date,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      tasksCubit.tasksList[index].time,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("still",
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white))
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        tasksCubit.tasksList[index].title,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        tasksCubit
                                                .tasksList[index].description ??
                                            "",
                                        style: const TextStyle(
                                            color: Colors.white),
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                content: const Text(
                                                    'Are you sure ?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        await tasksCubit
                                                            .deleteTaskEvent(
                                                                index);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Yes')),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('No'))
                                                ],
                                              ));
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Checkbox(
                                    value: tasksCubit.tasksList[index].isDone,
                                    onChanged: (value) {
                                      tasksCubit.changeIsDone(
                                          value ?? false, index);
                                    },
                                    activeColor: Colors.white,
                                    checkColor: Colors.blueGrey[200],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ));
      },
    );
  }
}
