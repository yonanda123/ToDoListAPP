import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'select_time_page.dart';
import 'add_description_page.dart';

class AddTaskModal extends StatefulWidget {
  final VoidCallback? onDataAdded;

  const AddTaskModal({Key? key, this.onDataAdded}) : super(key: key);
  @override
  _AddTaskModalState createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  String description = '';
  String title = '';
  List<bool> isSelected = [false, false, false, false];
  String? selectedTime;
  bool showError = false;
  bool isLoading = false;
  String? titleError;
  String? taskTypeError;
  String? timeError;
  String? descriptionError;

  void updateSelectedTime(String time) {
    setState(() {
      selectedTime = time;
      timeError = null;
    });
  }

  void validateTitle(String value) {
    setState(() {
      if (value.length >= 30) {
        titleError = 'Title cannot exceed 30 characters';
      } else {
        titleError = null;
        title = value;
      }
    });
  }

  void postTaskData() async {
    bool valid = true;
    if (title.isEmpty) {
      setState(() {
        titleError = 'Title is required';
      });
      valid = false;
    }
    if (isSelected.every((element) => !element)) {
      setState(() {
        taskTypeError = 'Task type is required';
      });
      valid = false;
    }
    if (selectedTime == null) {
      setState(() {
        timeError = 'Time is required';
      });
      valid = false;
    }
    if (description.isEmpty) {
      setState(() {
        descriptionError = 'Description is required';
      });
      valid = false;
    }
    if (!valid) return;

    setState(() {
      isLoading = true;
    });

    final taskTypes = ['Work', 'Meeting', 'Family', 'Me'];
    String taskType = '';

    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i]) {
        taskType = taskTypes[i];
        break;
      }
    }

    final parts = selectedTime!.split('; ');
    final timePart = parts[0];
    final datePart = parts[1];

    final url = Uri.parse(
        'https://66465c4951e227f23aaeb737.mockapi.io/api/ToDoListApp/timeLine');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'taskType': taskType,
        'time': timePart,
        'date': datePart,
        'description': description,
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 201) {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(
          Duration(seconds: 2)); 
      setState(() {
        isLoading = false;
      });

      // Panggil callback onDataAdded jika ada
      widget.onDataAdded?.call();

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 500),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(70.0),
              topRight: Radius.circular(70.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 16, top: 40),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70.0),
                      topRight: Radius.circular(70.0),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      'Create New Task',
                      style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 24),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 32),
                child: Text(
                  'Title',
                  style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 32, top: 16, bottom: 8, right: 32),
                child: TextField(
                  maxLines: null,
                  onChanged: (value) => validateTitle(value),
                  decoration: InputDecoration(
                    hintText: '   Enter task title...',
                    errorText: titleError,
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                    hintStyle: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xd9B19CEC),
                        fontFamily: 'PoppinsLight'),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Color(0xFFB19CEC)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                          color: Color(0xd9B19CEC), width: 0.5),
                    ),
                    filled: true,
                    fillColor: Color(0x1AB19CEC),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 32, top: 8),
                child: Text(
                  'Task Type',
                  style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 24, top: 16, right: 16, bottom: 8),
                child: SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      TaskTypeButton(
                        title: 'Work',
                        color: Colors.blue.withOpacity(0.1),
                        fontColor: Colors.blue,
                        isSelected: isSelected[0],
                        onTap: () {
                          setState(() {
                            for (int i = 0; i < isSelected.length; i++) {
                              isSelected[i] = i == 0;
                            }
                            taskTypeError = null;
                          });
                        },
                      ),
                      TaskTypeButton(
                        title: 'Meeting',
                        color: Colors.green.withOpacity(0.1),
                        fontColor: Colors.green,
                        isSelected: isSelected[1],
                        onTap: () {
                          setState(() {
                            for (int i = 0; i < isSelected.length; i++) {
                              isSelected[i] = i == 1;
                            }
                            taskTypeError = null;
                          });
                        },
                      ),
                      TaskTypeButton(
                        title: 'Family',
                        color: Colors.red.withOpacity(0.1),
                        fontColor: Colors.red,
                        isSelected: isSelected[2],
                        onTap: () {
                          setState(() {
                            for (int i = 0; i < isSelected.length; i++) {
                              isSelected[i] = i == 2;
                            }
                            taskTypeError = null;
                          });
                        },
                      ),
                      TaskTypeButton(
                        title: 'Me',
                        color: Colors.orange.withOpacity(0.1),
                        fontColor: Colors.orange,
                        isSelected: isSelected[3],
                        onTap: () {
                          setState(() {
                            for (int i = 0; i < isSelected.length; i++) {
                              isSelected[i] = i == 3;
                            }
                            taskTypeError = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (taskTypeError != null)
                Padding(
                  padding: EdgeInsets.only(left: 32, bottom: 8),
                  child: Text(
                    taskTypeError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(left: 32, bottom: 16, top: 8),
                child: Text(
                  'Total Detail',
                  style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32, bottom: 6),
                child: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.of(context).push(
                      _createRoute(),
                    );
                    if (result != null) {
                      updateSelectedTime(result);
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 6),
                      Text(
                        selectedTime ?? 'Add Time',
                        style: TextStyle(
                          fontFamily: 'PoppinsMedium',
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
              ),
              if (timeError != null)
                Padding(
                  padding: EdgeInsets.only(left: 32, bottom: 8),
                  child: Text(
                    timeError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 32, top: 6, right: 32),
                child: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.of(context)
                        .push(_createDescriptionRoute());
                    if (result != null) {
                      setState(() {
                        description = result;
                        descriptionError = null;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.description),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          description.isNotEmpty
                              ? description
                              : 'Add Description',
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (descriptionError != null)
                Padding(
                  padding: EdgeInsets.only(left: 32, bottom: 8),
                  child: Text(
                    descriptionError!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 32, right: 32, bottom: 32),
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : postTaskData,
                  icon: isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Icon(Icons.add, color: Colors.white),
                  label: Text(
                    isLoading ? 'Adding...' : 'Add',
                    style: TextStyle(
                        fontFamily: 'PoppinsMedium',
                        fontSize: 16,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xCCF14A5B),
                    shadowColor: Color(0xCCF14A5B),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskTypeButton extends StatelessWidget {
  final String title;
  final Color color;
  final Color fontColor;
  final bool isSelected;
  final VoidCallback onTap;

  const TaskTypeButton({
    required this.title,
    required this.color,
    required this.fontColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? fontColor.withOpacity(0.3) : color,
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? Border.all(color: fontColor, width: 2) : null,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'PoppinsLight',
                fontSize: 16,
                color: isSelected ? Colors.white : fontColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SelectTimePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

void showCustomModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(100.0),
        topRight: Radius.circular(100.0),
      ),
    ),
    builder: (context) => AddTaskModal(),
  );
}

Route _createDescriptionRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AddDescriptionPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
