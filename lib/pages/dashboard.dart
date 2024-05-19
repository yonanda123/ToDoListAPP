import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timelines/timelines.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_app/components/edit_task_modal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DateTime _currentDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = true;
  List<_DeliveryProcess> _deliveryProcesses = [];

  @override
  void initState() {
    super.initState();
    _loadDeliveryProcesses();
  }

  Future<void> _loadDeliveryProcesses() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String selectedDateFormatted =
          DateFormat("MMM dd, yyyy").format(_selectedDate);
      List<_DeliveryProcess> processes =
          await fetchDeliveryProcesses(selectedDateFormatted);
      // processes.add(const _DeliveryProcess.complete());
      setState(() {
        _deliveryProcesses = processes;
      });
    } catch (e) {
      print('Failed to load delivery processes: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<_DeliveryProcess>> fetchDeliveryProcesses(
      String selectedDate) async {
    final response = await http.get(Uri.parse(
        'https://66465c4951e227f23aaeb737.mockapi.io/api/ToDoListApp/timeLine'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);

      List<_DeliveryProcess> processes = [];
      data.forEach((task) {
        String addTime = task['time'];
        if (task['date'] == selectedDate) {
          processes.add(
            _DeliveryProcess(
              task['taskType'],
              messages: [
                _DeliveryMessage(addTime, task['title'], task['description'],
                    task['date'], task['taskType'], task['id']),
              ],
            ),
          );
        }
      });

      return processes;
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  void showEditTaskModal(BuildContext context, Map<String, String> task,
      Function(Map<String, String>) onTaskUpdated) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(100.0),
          topRight: Radius.circular(100.0),
        ),
      ),
      builder: (context) => TaskModal(
        task: task,
      ),
    ).then((_) {
      onTaskUpdated(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          titleSpacing: 0,
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 56),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Today',
                      style:
                          TextStyle(fontSize: 16, fontFamily: 'PoppinsMedium'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(_currentDate),
                      style: const TextStyle(
                          fontSize: 20, fontFamily: 'PoppinsBold'),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('images/profile.jpeg'),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 145,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  DateTime(_currentDate.year, _currentDate.month + 1, 0).day,
              itemBuilder: (context, index) {
                DateTime date =
                    DateTime(_currentDate.year, _currentDate.month, index + 1);
                bool isSelected = _selectedDate.day == date.day &&
                    _selectedDate.month == date.month &&
                    _selectedDate.year == date.year;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                    _loadDeliveryProcesses();
                  },
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xCCF14A5B) : Colors.white,
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(
                        color: isSelected
                            ? Color(0xCCF14A5B)
                            : Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: isSelected
                              ? Colors.white
                              : Colors.grey.withOpacity(0.1),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.black.withOpacity(0.4),
                              fontSize: 16,
                              fontFamily:
                                  isSelected ? 'PoppinsBold' : 'PoppinsMedium',
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            _getDayAbbreviation(date.weekday),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.4),
                              fontSize: 16,
                              fontFamily:
                                  isSelected ? 'PoppinsBold' : 'PoppinsMedium',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _DeliveryProcesses(
                              processes: _deliveryProcesses,
                              onTaskTap: (task) {
                                showEditTaskModal(
                                  context,
                                  {
                                    'id': task['id'] ?? '',
                                    'title': task['title'] ?? '',
                                    'taskType': task['taskType'] ?? '',
                                    'time': task['time'] ?? '',
                                    'date': task['date'] ?? '',
                                    'description': task['description'] ?? '',
                                  },
                                  (updatedTask) {
                                    setState(() {
                                      _deliveryProcesses[index] =
                                          _DeliveryProcess(
                                        updatedTask['taskType']!,
                                        messages: [
                                          _DeliveryMessage(
                                            updatedTask['time']!,
                                            updatedTask['tile']!,
                                            updatedTask['description']!,
                                            updatedTask['date']!,
                                            updatedTask['taskType']!,
                                            updatedTask['id']!,
                                          ),
                                        ],
                                      );
                                    });
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: 1,
                  ),
          ),
        ],
      ),
    );
  }
}

class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({
    required this.messages,
    required this.onTaskTap,
  });

  final List<_DeliveryMessage> messages;
  final Function(Map<String, dynamic>) onTaskTap;

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == messages.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
                thickness: 1.0,
              ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
                size: 10.0,
                position: 0.5,
              ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) =>
              !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1.0) : null,
          startConnectorBuilder: (_, index) => Connector.solidLine(),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }

            return GestureDetector(
              onTap: () => onTaskTap({
                'title': messages[index - 1].message,
                'time': messages[index - 1].createdAt,
                'date': messages[index - 1].date,
                'description': messages[index - 1].description,
                'taskType': messages[index - 1].taskType,
                'id': messages[index - 1].id,
              }),
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(messages[index - 1].createdAt,
                            style: TextStyle(
                                fontFamily: 'PoppinsSemiBold', fontSize: 12)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(messages[index - 1].message,
                                  style: TextStyle(
                                      fontFamily: 'PoppinsLight',
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 30.0,
          nodeItemOverlapBuilder: (_, index) =>
              isEdgeIndex(index) ? true : null,
          itemCount: messages.length + 2,
        ),
      ),
    );
  }
}

class _DeliveryProcesses extends StatelessWidget {
  const _DeliveryProcesses(
      {Key? key, required this.processes, required this.onTaskTap})
      : super(key: key);

  final List<_DeliveryProcess> processes;
  final Function(Map<String, dynamic>) onTaskTap;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Color(0xff989898),
            indicatorTheme: IndicatorThemeData(
              position: 0,
              size: 20.0,
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 2.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: processes.length,
            contentsBuilder: (_, index) {
              if (processes[index].isCompleted) return null;

              return Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      processes[index].name,
                      style: DefaultTextStyle.of(context).style.copyWith(
                          fontSize: 18.0, fontFamily: 'PoppinsSemiBold'),
                    ),
                    _InnerTimeline(
                      messages: processes[index].messages,
                      onTaskTap: onTaskTap,
                    ),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              if (index == 0) {
                return DotIndicator(
                  color: Color(0xCCF14A5B),
                  child: Icon(
                    Icons.check,
                    color: Colors.grey.withOpacity(0.3),
                    size: 12.0,
                  ),
                );
              } else {
                final process = processes[index - 1];
                if (process.isCompleted) {
                  return DotIndicator(
                    color: Color(0xCCF14A5B),
                    child: Icon(
                      Icons.check,
                      color: Colors.grey.withOpacity(0.3),
                      size: 12.0,
                    ),
                  );
                } else {
                  return OutlinedDotIndicator(
                    borderWidth: 2.5,
                  );
                }
              }
            },
            connectorBuilder: (_, index, ___) => SolidLineConnector(
              color: processes[index].isCompleted ? Colors.grey : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderInfo {
  const _OrderInfo({
    required this.id,
    required this.date,
    required this.deliveryProcesses,
  });

  final int id;
  final DateTime date;
  final List<_DeliveryProcess> deliveryProcesses;
}

class _DeliveryProcess {
  const _DeliveryProcess(
    this.name, {
    this.messages = const [],
  });

  // const _DeliveryProcess.complete()
  //     : this.name = 'Done',
  //       this.messages = const [];

  final String name;
  final List<_DeliveryMessage> messages;

  bool get isCompleted => name == 'Done';
}

class _DeliveryMessage {
  const _DeliveryMessage(this.createdAt, this.message, this.description,
      this.date, this.taskType, this.id);

  final String createdAt;
  final String message;
  final String description;
  final String date;
  final String taskType;
  final String id;

  @override
  String toString() {
    return '$createdAt $message $description $date';
  }
}

String _formatDate(DateTime date) {
  final String day = _getDayOfWeek(date.weekday);
  final String month = _getMonth(date.month);
  return '$day, ${date.day} $month ${date.year}';
}

String _getDayOfWeek(int day) {
  switch (day) {
    case DateTime.monday:
      return 'Monday';
    case DateTime.tuesday:
      return 'Tuesday';
    case DateTime.wednesday:
      return 'Wednesday';
    case DateTime.thursday:
      return 'Thursday';
    case DateTime.friday:
      return 'Friday';
    case DateTime.saturday:
      return 'Saturday';
    case DateTime.sunday:
      return 'Sunday';
    default:
      return '';
  }
}

String _getMonth(int month) {
  switch (month) {
    case DateTime.january:
      return 'January';
    case DateTime.february:
      return 'February';
    case DateTime.march:
      return 'March';
    case DateTime.april:
      return 'April';
    case DateTime.may:
      return 'May';
    case DateTime.june:
      return 'June';
    case DateTime.july:
      return 'July';
    case DateTime.august:
      return 'August';
    case DateTime.september:
      return 'September';
    case DateTime.october:
      return 'October';
    case DateTime.november:
      return 'November';
    case DateTime.december:
      return 'December';
    default:
      return '';
  }
}

String _getDayAbbreviation(int day) {
  switch (day) {
    case DateTime.monday:
      return 'Mo';
    case DateTime.tuesday:
      return 'Tu';
    case DateTime.wednesday:
      return 'We';
    case DateTime.thursday:
      return 'Th';
    case DateTime.friday:
      return 'Fr';
    case DateTime.saturday:
      return 'Sa';
    case DateTime.sunday:
      return 'Su';
    default:
      return '';
  }
}
