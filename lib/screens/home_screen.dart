import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/user.dart';
import 'add_event_screen.dart';
import '../database_helper.dart';
import 'calendar_screen.dart';
class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    // You'll need to implement getEvents in DatabaseHelper
    // _events = await DatabaseHelper.instance.getEvents(widget.user.id!);
    try {
      final events = await DatabaseHelper.instance.getEvents(widget.user.id!);
      setState(() {
        _events = events;
      });
    } catch (e) {
      print('Error loading events: $e');
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Events')),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: CalendarScreen(),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
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
        },
      ),
    );
  }}