import 'dart:async';
import 'package:FleXcelerate/pages/Scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<String> notifications = [
    'You reached your step goal!',
    'You reached your daily calorie limit!',
    'Remember to drink water!',
  ];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  late Timer waterReminderTimer;

  @override
  void initState() {
    super.initState();
    initNotifications();
    scheduleDailyNotifications();
  }

  void handleNotification(String message) {
    showNotification('FleXcelerate', message);
    setState(() {
      notifications.add(message);
    });
  }

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {},
    );
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  void scheduleDailyNotifications() {
    DateTime now = DateTime.now();
    DateTime scheduledTime = DateTime(now.year, now.month, now.day, 19, 0, 0);

    if (now.isAfter(scheduledTime)) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }

    Duration initialDelay = scheduledTime.difference(now);

    waterReminderTimer = Timer(initialDelay, () {
      showNotification('FleXcelerate', 'You reached your step goal!');
      showNotification('FleXcelerate', 'You reached your daily calorie limit!');

      const Duration reminderInterval = Duration(hours: 24);
      waterReminderTimer = Timer.periodic(reminderInterval, (timer) {
        showNotification('FleXcelerate', 'You reached your step goal!');
        showNotification('FleXcelerate', 'You reached your daily calorie limit!');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      currentIndex: 2,
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Notification Page'),
          backgroundColor: Colors.greenAccent,
        ),
        body: SingleChildScrollView(
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 8,
            shadowColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.greenAccent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.greenAccent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: notifications.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(notifications[index]),
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                    ),
                    child: InkWell(
                      onTap: () {
                        showNotification('FleXcelerate', notifications[index]);
                      },
                      child: Card(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[900]
                            : Colors.white,
                        child: ListTile(
                          title: Text(
                            notifications[index],
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        notifications.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Notification dismissed")),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Planning',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              // Navigate to Home
            } else if (index == 1) {
              // Navigate to Planning
            } else if (index == 2) {
              // Stay on Notifications
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    waterReminderTimer.cancel();
    super.dispose();
  }
}
