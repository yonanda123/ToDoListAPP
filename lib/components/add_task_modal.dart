import 'package:flutter/material.dart';

class AddTaskModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 500),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
                  left: 32, top: 16, bottom: 32, right: 32),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '     Enter task title...',
                  hintStyle: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xd9B19CEC),
                      fontFamily: 'PoppinsLight'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:
                        const BorderSide(color: Color(0xFFB19CEC), width: 0.5),
                  ),
                  filled: true,
                  fillColor: Color(0x1AB19CEC),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 32),
              child: Text(
                'Task Type',
                style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24, top: 16, right: 16, bottom: 24),
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    TaskTypeButton(
                      title: 'Work',
                      color: Colors.blue.withOpacity(0.1),
                      fontColor: Colors.blue,
                    ),
                    TaskTypeButton(
                      title: 'Meeting',
                      color: Colors.green.withOpacity(0.1),
                      fontColor: Colors.green,
                    ),
                    TaskTypeButton(
                      title: 'Family',
                      color: Colors.red.withOpacity(0.1),
                      fontColor: Colors.red,
                    ),
                    TaskTypeButton(
                      title: 'Me',
                      color: Colors.orange.withOpacity(0.1),
                      fontColor: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 32, bottom: 16),
              child: Text(
                'Task Type',
                style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, bottom: 6),
              child: GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.access_time),
                    SizedBox(width: 6),
                    Text('Add Time'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 6),
              child: GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.description),
                    SizedBox(width: 5),
                    Text('Add Description'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 32, right: 32, bottom: 32),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Add',
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
    );
  }
}

class TaskTypeButton extends StatelessWidget {
  final String title;
  final Color color;
  final Color fontColor;

  const TaskTypeButton({
    required this.title,
    required this.color,
    required this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shadowColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
              fontFamily: 'PoppinsLight', fontSize: 16, color: fontColor),
        ),
      ),
    );
  }
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
