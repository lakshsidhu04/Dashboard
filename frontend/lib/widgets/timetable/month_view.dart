import 'package:dashbaord/widgets/timetable/scroll_to_today_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';

class MonthViewScreen extends StatefulWidget {
  const MonthViewScreen({Key? key}) : super(key: key);

  @override
  _MonthViewScreenState createState() => _MonthViewScreenState();
}

class _MonthViewScreenState extends State<MonthViewScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToToday() {
    DateTime today = DateTime.now();
    double offset = today.day * 1;

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PagedVerticalCalendar(
            scrollController: _scrollController,
            addAutomaticKeepAlives: true,
            startWeekWithSunday: true,
            monthBuilder: (context, month, year) {
              final formattedMonth =
                  DateFormat('MMMM yyyy').format(DateTime(year, month));
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  formattedMonth,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              );
            },
            dayBuilder: (context, date) {
              bool isToday = DateTime.now().day == date.day &&
                  DateTime.now().month == date.month &&
                  DateTime.now().year == date.year;

              return Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: isToday ? Colors.blueAccent : Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: isToday
                      ? [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                ),
                child: Center(
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isToday ? Colors.white : Colors.grey.shade300,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
            onDayPressed: (date) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Selected date: ${date.toLocal()}'),
                backgroundColor: Colors.grey.shade800,
              ));
            },
          ),
          TodayButton(onPressed: _scrollToToday),
        ],
      ),
    );
  }
}