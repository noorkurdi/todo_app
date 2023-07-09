import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:new_todo/bloc/cubits/tasks_cubit.dart';
import 'package:new_todo/bloc/states/tasks_states.dart';
import 'package:new_todo/pages/home_page.dart';

import '../utils/ui_states_enum.dart';

class AddTasksPages extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  AddTasksPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksStates>(
      listener: (context, state) {},
      builder: (context, state) {
        TasksCubit tasksCubit = TasksCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'Add new task ',
              style: GoogleFonts.pacifico(
                textStyle: const TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(1000),
                          bottomRight: Radius.circular(1000)),
                    ),
                    height: 15,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, top: 16),
                    child: TextFormField(
                        validator: (value) {
                          if (value == null) {
                            return "this field is required";
                          } else if (value == "") {
                            return "this field is required";
                          } else {
                            return null;
                          }
                        },
                        controller: tasksCubit.titleController,
                        cursorColor: Colors.cyan,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(255, 70, 68, 68),
                        ),
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            labelText: 'Title',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none))),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 15, right: 15),
                    child: TextFormField(
                      controller: tasksCubit.desController,
                      cursorColor: Colors.cyan,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 70, 68, 68),
                      ),
                      minLines: null,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintStyle:
                            const TextStyle(fontSize: 20, color: Colors.grey),
                        hintText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.cyan),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return "this field is required";
                        } else if (value == "") {
                          return "this field is required";
                        } else {
                          return null;
                        }
                      },
                      controller: tasksCubit.dateController,
                      onTap: () async {
                        DateTime? pickeddate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2053),
                        );
                        if (pickeddate != null) {
                          tasksCubit.dateController.text =
                              DateFormat("yyyy-MM-dd").format(pickeddate);
                        }
                      },
                      readOnly: true,
                      cursorColor: Colors.orange[400],
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        label: Text('Date'),
                        labelStyle: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 134, 134, 134)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return "this field is required";
                        } else if (value == "") {
                          return "this field is required";
                        } else {
                          return null;
                        }
                      },
                      onTap: () async {
                        TimeOfDay? timeOfDay = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (timeOfDay != null) {
                          tasksCubit.timeController.text =
                              timeOfDay.format(context);
                        }
                      },
                      controller: tasksCubit.timeController,
                      readOnly: true,
                      cursorColor: Colors.orange[400],
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        label: Text('Time'),
                        labelStyle: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 134, 134, 134)),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 35),
                            onPrimary: Colors.white,
                            primary: Colors.cyan,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (tasksCubit.uiStateEnum == UIStateEnum.add) {
                                await tasksCubit.addNewTaskEvent();
                              } else {
                                await tasksCubit.editEvent();
                              }
                              tasksCubit.getDate();
                              tasksCubit.clearEvent();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
                            }
                          },
                          child: const Text('save'),
                        ),
                        Row(
                          children: [
                            const Text(
                              'is Done?',
                              style: TextStyle(fontSize: 18),
                            ),
                            Checkbox(
                                value: tasksCubit.isDone,
                                onChanged: (value) {
                                  tasksCubit.changeIsDoneEvent(value ?? false);
                                },
                                checkColor: Colors.white,
                                fillColor:
                                    MaterialStateProperty.all(Colors.cyan),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7))),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
