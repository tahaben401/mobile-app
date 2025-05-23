import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Now properly imported
import '../models/event.dart';
import '../models/user.dart';
import '../database_helper.dart';

class AddEventScreen extends StatefulWidget {
  final User user;

  const AddEventScreen({required this.user, Key? key}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      try {
        final event = Event(
          title: _titleController.text,
          dateTime: _selectedDateTime.toIso8601String().split('T')[0],
          description: _descController.text,
          userId: widget.user.id!,
        );

        await DatabaseHelper.instance.addEvent(event);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving event: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xff0277BD), Color(0xff03A9F4) , Color(0xff80D8FF)] ,begin: Alignment.topLeft , end: Alignment.topRight),
          ),



          child :Column(
            children: [

              Container(
                  child: Column(
                    children: [
                      Container(padding: EdgeInsets.only(top: 40 ,left: 30 ,bottom: 10),
                        child: Row(children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: 10,),
                          Text("Add Event",style:TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                            color: Colors.white,
                          ),),
                        ],
                        ),
                      )

                    ],

                  )


              ),

              Expanded(


                  child: Container(

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),

                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: EdgeInsets.only(top: 50 ,left: 20 , right: 20),
                        children: [
                          SizedBox(height: 50,),
                          TextFormField(

                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Event Title*',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.title),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Date & Time'),
                            subtitle: Text(
                              DateFormat('MMM dd, yyyy - hh:mm a').format(_selectedDateTime),
                            ),
                            trailing: const Icon(Icons.edit),
                            onTap: () => _selectDateTime(context),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _descController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.description),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: _saveEvent,
                            child:Text('SAVE EVENT',style:TextStyle(
                              fontWeight: FontWeight.bold ,
                              color: Colors.white,
                              fontSize: 20 ,
                            ),),
                          ),
                        ],
                      ),
                    ),
                  )),

            ],
          )

      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}