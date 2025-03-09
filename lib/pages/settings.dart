// settings.dart
import 'package:flutter/material.dart';
import 'Scaffold.dart';
import 'editProfilePage.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  hintColor: Colors.black,
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  appBarTheme: AppBarTheme(
    color: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.grey,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  hintColor: Colors.black,
  scaffoldBackgroundColor: const Color(0xFF212121),
  appBarTheme: AppBarTheme(
    color: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
  ),
);

class AppSettings extends StatefulWidget {
  final Function(bool) onDarkModeChanged;
  final String initialThemeMode;

  const AppSettings({
    Key? key,
    required this.onDarkModeChanged,
    required this.initialThemeMode,
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<AppSettings> {
  bool _isDarkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _isDarkModeEnabled = widget.initialThemeMode == 'Dark';
  }


  @override
  Widget build(BuildContext context) {
    ThemeMode currentThemeMode = ThemeManager().themeMode;


    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
          style: TextStyle(color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,),),
        backgroundColor: currentThemeMode == ThemeMode.dark ? Colors.black! : Colors.white,
        iconTheme: IconThemeData(
          color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
              ),
            ),
            SwitchListTile(
              title: Text('Enable Dark Mode',
                style: TextStyle(color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black),),
              value: _isDarkModeEnabled,
              activeColor: Colors.greenAccent,
              onChanged: (value) {
                setState(() {
                  _isDarkModeEnabled = value;
                  widget.onDarkModeChanged(value);
                });
              },
            ),
            Divider(),
            Text(
              'Account',
              style: TextStyle(
                color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  color: currentThemeMode == ThemeMode.dark ? Colors.blue : Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Help'),
                      content: Text('If you need support, contact FleXcelerate@support.ca'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                'Help',
                style: TextStyle(
                  color: currentThemeMode == ThemeMode.dark ? Colors.blue : Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: currentThemeMode == ThemeMode.dark ? Colors.grey[900] : null,
    );
  }
}
