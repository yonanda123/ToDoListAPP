import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

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
                      _getCurrentDate(),
                      style: const TextStyle(
                          fontSize: 20, fontFamily: 'PoppinsBold'),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage(
                      'images/profile.jpeg'), 
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
        ),
      ),
      body: const Center(
        child: Text(
          'This is the Dashboard screen',
          style: TextStyle(fontFamily: 'PoppinsExtraBold'),
        ),
      ),
    );
  }

  String _getCurrentDate() {
    final DateTime now = DateTime.now();
    final String day = _getDayOfWeek(now.weekday);
    final String month = _getMonth(now.month);
    final int date = now.day;
    final int year = now.year;
    return '$day, $date $month $year';
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
}
