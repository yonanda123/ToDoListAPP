import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectTimePage extends StatefulWidget {
  @override
  _SelectTimePageState createState() => _SelectTimePageState();
}

class _SelectTimePageState extends State<SelectTimePage> {
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Date and Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date',
              style: TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 16),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                  });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Color(0xffB19CEC)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Color(0xffB19CEC),
                    ),
                    SizedBox(width: 16),
                    Text(
                      selectedDate != null
                          ? DateFormat.yMMMd().format(selectedDate!)
                          : 'Choose a date',
                      style: TextStyle(
                          fontFamily: 'PoppinsMedium',
                          fontSize: 16,
                          color: Color(0xffB19CEC)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Start Time',
              style: TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 16),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: startTime ?? TimeOfDay.now(),
                );
                if (picked != null && picked != startTime)
                  setState(() {
                    startTime = picked;
                  });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Color(0xffB19CEC)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Color(0xffB19CEC),
                    ),
                    SizedBox(width: 16),
                    Text(
                      startTime != null
                          ? startTime!.format(context)
                          : 'Choose a start time',
                      style: TextStyle(
                          fontFamily: 'PoppinsMedium',
                          fontSize: 16,
                          color: Color(0xffB19CEC)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'End Time',
              style: TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 16),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: endTime ?? TimeOfDay.now(),
                );
                if (picked != null && picked != endTime)
                  setState(() {
                    endTime = picked;
                  });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Color(0xFFB19CEC)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Color(0xFFB19CEC),
                    ),
                    SizedBox(width: 16),
                    Text(
                      endTime != null
                          ? endTime!.format(context)
                          : 'Choose an end time',
                      style: TextStyle(
                          fontFamily: 'PoppinsMedium',
                          fontSize: 16,
                          color: Color(0xFFB19CEC)),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedDate != null &&
                      startTime != null &&
                      endTime != null) {
                    final selectedDateTime =
                        DateFormat.yMMMMd().format(selectedDate!);
                    final selectedStartTime = startTime!.format(context);
                    final selectedEndTime = endTime!.format(context);
                    final result =
                        '$selectedStartTime - $selectedEndTime; $selectedDateTime';
                    Navigator.of(context).pop(result);
                  }
                },
                child: Text(
                  'Select',
                  style: TextStyle(
                    fontFamily: 'PoppinsMedium',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xCCF14A5B),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
