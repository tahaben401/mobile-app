import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/event.dart';
import '../database_helper.dart';

class SettingsScreen extends StatefulWidget {
  final User user;

  SettingsScreen({required this.user});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  bool soundEnabled = true;
  String selectedLanguage = 'English';

  final List<String> languages = ['English', 'Arabic', 'French', 'Spanish'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.blue.shade700,
                        size: 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Settings",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.blue.shade800,
                        fontSize: 28,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Account Section
                    _buildSettingsSection(
                      title: 'Account',
                      icon: Icons.person,
                      children: [
                        _buildSettingsItem(
                          icon: Icons.person,
                          title: 'Account Info',
                          subtitle: 'Email: ${widget.user.email}',
                          onTap: null,
                        ),
                        _buildSettingsItem(
                          icon: Icons.delete_forever,
                          title: 'Delete All Events',
                          subtitle: 'Remove all your events permanently',
                          onTap: () => _showDeleteAllEventsDialog(),
                          textColor: Colors.red,
                        ),
                      ],
                    ),

                    SizedBox(height: 20),



                    




                    SizedBox(height: 20),

                    // Data Management Section
                    _buildSettingsSection(
                      title: 'Data Management',
                      icon: Icons.storage,
                      children: [
                        _buildSettingsItem(
                          icon: Icons.info_outline,
                          title: 'Event Statistics',
                          subtitle: 'View your event statistics',
                          onTap: () => _showEventStatistics(),
                        ),
                        _buildSettingsItem(
                          icon: Icons.download,
                          title: 'Export Events',
                          subtitle: 'Export your events as text',
                          onTap: () => _exportEvents(),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // About Section
                    _buildSettingsSection(
                      title: 'About',
                      icon: Icons.info,
                      children: [
                        _buildSettingsItem(
                          icon: Icons.info_outline,
                          title: 'App Version',
                          subtitle: 'v1.0.0',
                          onTap: null,
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    // Logout Button
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showLogoutDialog(),
                        icon: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Sign Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
          ),
          // Section Content
          Column(children: children),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade100,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (textColor ?? Colors.blue.shade600).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: textColor ?? Colors.blue.shade600,
                size: 20,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor ?? Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade600.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.blue.shade600,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade600.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.blue.shade600,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            value: value,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            underline: SizedBox(),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.blue.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // Functional Dialog Methods
  void _showDeleteAllEventsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete All Events'),
        content: Text('Are you sure you want to delete all your events? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteAllEvents();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAllEvents() async {
    try {
      // Get all events for this user
      List<Event> events = await DatabaseHelper.instance.getEvents(widget.user.id!);

      // Delete each event
      for (Event event in events) {
        await DatabaseHelper.instance.deleteEvent(event.id!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All events deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting events: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showEventStatistics() async {
    try {
      List<Event> events = await DatabaseHelper.instance.getEvents(widget.user.id!);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Event Statistics'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Events: ${events.length}'),
              SizedBox(height: 8),
              Text('User ID: ${widget.user.id}'),
              SizedBox(height: 8),
              Text('Email: ${widget.user.email}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading statistics: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _exportEvents() async {
    try {
      List<Event> events = await DatabaseHelper.instance.getEvents(widget.user.id!);

      if (events.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No events to export'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      String exportData = 'Event Export for ${widget.user.email}\n';
      exportData += '=' * 40 + '\n\n';

      for (int i = 0; i < events.length; i++) {
        Event event = events[i];
        exportData += 'Event ${i + 1}:\n';
        exportData += 'Title: ${event.title}\n';
        exportData += 'Date: ${event.dateTime}\n';
        exportData += 'Description: ${event.description}\n';
        exportData += '-' * 20 + '\n\n';
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Export Events'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: SingleChildScrollView(
              child: Text(exportData),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Events exported successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting events: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate back to login screen
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}