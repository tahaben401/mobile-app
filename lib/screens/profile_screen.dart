import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/event.dart';
import '../database_helper.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int totalEvents = 0;
  int activeEvents = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEventStats();
  }

  Future<void> _loadEventStats() async {
    try {
      // Get all events for this user
      List<Event> userEvents = await DatabaseHelper.instance.getEvents(widget.user.id!);

      // Calculate total events
      int total = userEvents.length;

      // Calculate active events (events that are today or in the future)
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      int active = userEvents.where((event) {
        DateTime eventDate = DateTime.parse(event.dateTime);
        DateTime eventDateOnly = DateTime(eventDate.year, eventDate.month, eventDate.day);
        return eventDateOnly.isAfter(today) || eventDateOnly.isAtSameMomentAs(today);
      }).length;

      setState(() {
        totalEvents = total;
        activeEvents = active;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading event stats: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String userName = widget.user.email.split('@')[0];

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
                      "Profile",
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
                    // Profile Avatar Section
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade400, Colors.blue.shade600],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.blue.shade100),
                            ),
                            child: Text(
                              'Event Organizer',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Profile Information Cards
                    _buildInfoCard(
                      icon: Icons.person,
                      title: 'Name',
                      value: userName,
                      gradient: [Colors.blue.shade400, Colors.blue.shade600],
                    ),

                    SizedBox(height: 16),

                    _buildInfoCard(
                      icon: Icons.email,
                      title: 'Email Address',
                      value: widget.user.email,
                      gradient: [Colors.blue.shade400, Colors.blue.shade600],
                    ),

                    SizedBox(height: 16),

                    _buildInfoCard(
                      icon: Icons.lock,
                      title: 'Password',
                      value: widget.user.password,
                      gradient: [Colors.blue.shade400, Colors.blue.shade600],
                      isPassword: true,
                    ),

                    SizedBox(height: 30),

                    // Account Stats Section - Now Dynamic
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
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
                          Row(
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
                                  Icons.bar_chart,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Account Overview',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                              Spacer(),
                              if (isLoading)
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue.shade400,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 20),
                          if (!isLoading) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatItem(
                                    icon: Icons.event,
                                    label: 'Total Events',
                                    value: totalEvents.toString(),
                                    color: Colors.green,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 50,
                                  color: Colors.grey.shade200,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                ),
                                Expanded(
                                  child: _buildStatItem(
                                    icon: Icons.calendar_today,
                                    label: 'Active Events',
                                    value: activeEvents.toString(),
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            // Loading state
                            Container(
                              height: 80,
                              child: Center(
                                child: Text(
                                  'Loading statistics...',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 30),

                    // Refresh Button
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : () {
                          setState(() {
                            isLoading = true;
                          });
                          _loadEventStats();
                        },
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Refresh Statistics',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required List<Color> gradient,
    bool isPassword = false,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
          ),
          if (isPassword)
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.visibility_off,
                color: Colors.blue.shade600,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.blue.shade800,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}