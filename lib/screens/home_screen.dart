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
  bool _isMenuOpen = false;
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

      body:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),


        child: Column(
          children: [
            SizedBox(height: 50,),
            Row(
              children: [
                SizedBox(width: 20,),
                IconButton(
                  icon: Icon(Icons.menu,
                  color: Colors.blue,),
                  onPressed:() {},
                ),
                SizedBox(width: 40,),
                Text("My Events",style: TextStyle(
                  fontWeight:FontWeight.w400 ,
                  color: Colors.blue,
                  fontSize: 28 ,
                ),),
              ],
            ),
            SizedBox(height: 30,),
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
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),

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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (ctx) => Dialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 20,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Update Event',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue.shade800,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Divider(
                                        thickness: 1.5,
                                        color: Colors.grey.shade200,
                                      ),
                                      SizedBox(height: 16),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Event Title',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          TextField(
                                            controller: TextEditingController(text: _events[index].title),
                                            onChanged: (value) => _events[index] = _events[index].copyWith(title: value),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blue.shade800,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'Enter event title',
                                              hintStyle: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade400,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(color: Colors.grey.shade200),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(color: Colors.blue.shade600),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Description',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          TextField(
                                            controller: TextEditingController(text: _events[index].description),
                                            onChanged: (value) => _events[index] = _events[index].copyWith(description: value),
                                            minLines: 3,
                                            maxLines: 5,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blue.shade800,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'Enter event description',
                                              hintStyle: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade400,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(color: Colors.grey.shade200),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(color: Colors.blue.shade600),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 24),

                                      ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            await DatabaseHelper.instance.updateEvent(_events[index]);
                                            Navigator.pop(ctx);
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Error: $e')),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue.shade600,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          shadowColor: Colors.blue.withOpacity(0.3),
                                        ),
                                        child: Text(
                                          'Save Changes',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            try {
                              await DatabaseHelper.instance.deleteEvent(_events[index].id!);
                              setState(() => _events.removeAt(index));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
                padding: EdgeInsets.only(bottom: 50 , right: 30),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,

                  children: [FloatingActionButton(

                    child : Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue
                      ),
                      child: Icon(Icons.add,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddEventScreen(user: widget.user)),
                      );
                      _loadEvents();
                      _loadEventCounts();
                    },
                  ),],
                ),
                ),


          ],
        ),
      )


    );
  }
}