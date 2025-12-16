import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../services/notification_service.dart';

class ScheduledReminder {
  final int id;
  final String title;
  final DateTime scheduledDateTime;
  final String timeZone;

  ScheduledReminder({
    required this.id,
    required this.title,
    required this.scheduledDateTime,
    this.timeZone = 'WIB',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'scheduledDateTime': scheduledDateTime.toIso8601String(),
      'timeZone': timeZone,
    };
  }

  factory ScheduledReminder.fromJson(Map<String, dynamic> json) {
    return ScheduledReminder(
      id: json['id'],
      title: json['title'],
      scheduledDateTime: DateTime.parse(json['scheduledDateTime']),
      timeZone: json['timeZone'] ?? 'WIB',
    );
  }
}

class SchedulePage extends StatefulWidget {
  final Function(int) onNavigate;

  const SchedulePage({super.key, required this.onNavigate});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final NotificationService _notificationService = NotificationService();
  final TextEditingController _titleController = TextEditingController();
  final List<ScheduledReminder> _scheduledReminders = [];

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedTimeZone = 'WIB';

  // Map zona waktu Indonesia dengan offset UTC
  final Map<String, int> _timeZoneOffsets = {
    'WIB': 7, // UTC+7 (Waktu Indonesia Barat)
    'WITA': 8, // UTC+8 (Waktu Indonesia Tengah)
    'WIT': 9, // UTC+9 (Waktu Indonesia Timur)
  };

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? remindersJson = prefs.getString('scheduled_reminders');

    if (remindersJson != null) {
      final List<dynamic> decodedList = json.decode(remindersJson);
      setState(() {
        _scheduledReminders.clear();
        _scheduledReminders.addAll(
          decodedList.map((item) => ScheduledReminder.fromJson(item)).toList(),
        );
        _scheduledReminders.sort(
          (a, b) => a.scheduledDateTime.compareTo(b.scheduledDateTime),
        );
      });
    }
  }

  Future<void> _saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String remindersJson = json.encode(
      _scheduledReminders.map((reminder) => reminder.toJson()).toList(),
    );
    await prefs.setString('scheduled_reminders', remindersJson);
  }

  // Konversi dari zona waktu yang dipilih ke waktu lokal device
  DateTime _convertToLocalTime(DateTime dateTime, String fromTimeZone) {
    // Dapatkan offset zona waktu yang dipilih
    int selectedOffset = _timeZoneOffsets[fromTimeZone]!;

    // Dapatkan offset zona waktu lokal device (dalam jam)
    int localOffset = DateTime.now().timeZoneOffset.inHours;

    // Hitung perbedaan offset
    int offsetDifference = localOffset - selectedOffset;

    // Tambahkan perbedaan offset ke waktu yang dipilih
    return dateTime.add(Duration(hours: offsetDifference));
  }

  // Konversi dari waktu lokal device ke zona waktu tertentu (untuk tampilan)
  DateTime _convertFromLocalTime(DateTime localDateTime, String toTimeZone) {
    int targetOffset = _timeZoneOffsets[toTimeZone]!;
    int localOffset = DateTime.now().timeZoneOffset.inHours;
    int offsetDifference = targetOffset - localOffset;

    return localDateTime.add(Duration(hours: offsetDifference));
  }

  Future<void> _scheduleReminder() async {
    if (_selectedDate == null ||
        _selectedTime == null ||
        _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please complete all schedule data'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Buat DateTime berdasarkan input user (dalam zona waktu yang dipilih)
    final userInputDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    // Konversi ke waktu lokal device untuk scheduling
    final scheduledDateTime = _convertToLocalTime(
      userInputDateTime,
      _selectedTimeZone,
    );

    if (scheduledDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cannot schedule reminder in the past'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    int notificationId = scheduledDateTime.millisecondsSinceEpoch ~/ 1000;
    String reminderTitle = _titleController.text;

    await _notificationService.scheduleNotification(
      notificationId,
      reminderTitle,
      'Time to start your routine: $reminderTitle!',
      scheduledDateTime,
    );

    setState(() {
      _scheduledReminders.add(
        ScheduledReminder(
          id: notificationId,
          title: reminderTitle,
          scheduledDateTime: scheduledDateTime,
          timeZone: _selectedTimeZone,
        ),
      );

      _scheduledReminders.sort(
        (a, b) => a.scheduledDateTime.compareTo(b.scheduledDateTime),
      );

      _titleController.clear();
      _selectedDate = null;
      _selectedTime = null;
      _selectedTimeZone = 'WIB'; // Reset ke default
    });

    await _saveReminders();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child:
                    Text('Reminder "$reminderTitle" successfully scheduled!'),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2028),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.pink,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.pink,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${days[dateTime.weekday - 1]}, ${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Schedule & Reminder',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create New Reminder',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Routine Name',
                        hintText: 'e.g., Morning Skincare, Night Routine',
                        prefixIcon: const Icon(Icons.spa, color: Colors.pink),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.pink,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.pink.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.calendar_today,
                                color: Colors.pink,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _selectedDate == null
                                        ? 'Select date'
                                        : _formatDateTime(_selectedDate!),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _selectTime(context),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.pink.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.access_time,
                                color: Colors.pink,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Time',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _selectedTime == null
                                        ? 'Select time'
                                        : _selectedTime!.format(context),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Dropdown Time Zone
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.pink.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.public,
                              color: Colors.pink,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Time Zone',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedTimeZone,
                                    isExpanded: true,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    items: _timeZoneOffsets.keys
                                        .map((String zone) {
                                      return DropdownMenuItem<String>(
                                        value: zone,
                                        child: Text(
                                            '$zone (UTC+${_timeZoneOffsets[zone]})'),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(
                                            () => _selectedTimeZone = newValue);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _scheduleReminder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_alarm, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Create Reminder',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Scheduled Reminders',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (_scheduledReminders.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_scheduledReminders.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _scheduledReminders.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 60,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No Scheduled Reminders',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create your first reminder above',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _scheduledReminders.length,
                          itemBuilder: (context, index) {
                            final reminder = _scheduledReminders[index];
                            final isPast = reminder.scheduledDateTime.isBefore(
                              DateTime.now(),
                            );

                            // Konversi waktu untuk tampilan dalam zona waktu aslinya
                            final displayDateTime = _convertFromLocalTime(
                              reminder.scheduledDateTime,
                              reminder.timeZone,
                            );

                            return Dismissible(
                              key: ValueKey(reminder.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      title: const Text("Confirm Delete"),
                                      content: Text(
                                        'Are you sure you want to delete "${reminder.title}"?',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("CANCEL"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text(
                                            "DELETE",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (direction) async {
                                await _notificationService.cancelNotification(
                                  reminder.id,
                                );

                                setState(() {
                                  _scheduledReminders.removeAt(index);
                                });

                                await _saveReminders();

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Reminder "${reminder.title}" deleted',
                                      ),
                                      backgroundColor: Colors.orange,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: isPast
                                        ? Colors.grey.shade300
                                        : Colors.pink.shade100,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: isPast
                                          ? Colors.grey.shade100
                                          : Colors.pink.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.notifications_active,
                                      color: isPast
                                          ? Colors.grey.shade400
                                          : Colors.pink,
                                      size: 28,
                                    ),
                                  ),
                                  title: Text(
                                    reminder.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isPast
                                          ? Colors.grey.shade500
                                          : Colors.black87,
                                      decoration: isPast
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            _formatDateTime(displayDateTime),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${_formatTime(displayDateTime)} ${reminder.timeZone}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (isPast) ...[
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            'Completed',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
