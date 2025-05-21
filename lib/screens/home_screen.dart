import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event.dart';
import '../models/user.dart';
import 'add_event_screen.dart';
import '../database_helper.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> _events = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<String, int> _eventCounts = {};
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay; // Initialize with current date
    _loadEvents();
    _loadEventCounts();
  }

  Future<void> _loadEvents() async {
    try {
      final events = await DatabaseHelper.instance.getEventsbydate(
          widget.user.id!,
          _selectedDay != null ? _selectedDay!.toIso8601String().split('T')[0] :
          _focusedDay.toIso8601String().split('T')[0]
      );
      setState(() {
        _events = events;
      });
    } catch (e) {
      print('Error loading events: $e');
      // Handle error appropriately
    }
  }
  Future<void> _loadEventCounts() async {
    final events = await DatabaseHelper.instance.getEvents(widget.user.id!);
    final counts = <String, int>{};

    for (var event in events) {
      final date = event.dateTime; // Get just the date part
      counts[date] = (counts[date] ?? 0) + 1;
    }

    setState(() {
      _eventCounts = counts;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Events')),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => _selectedDay == day,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _loadEvents();
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final dateStr = day.toIso8601String().split('T')[0];
                  final count = _eventCounts[dateStr] ?? 0;

                  return Stack(
                    children: [
                      Center(child: Text('${day.day}')),
                      if (count > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: _events.isEmpty
                ? Center(child: Text('No events found'))
                : ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  title: Text(
                    _events[index].title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    _events[index].description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    _events[index].dateTime.split('T')[0],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEventScreen(user: widget.user)),
          );
          _loadEvents();
          _loadEventCounts();
        },
      ),
    );
  }
}