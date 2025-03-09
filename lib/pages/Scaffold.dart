import 'package:FleXcelerate/logic/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../logic/user.dart';
import 'planningPage.dart';
import 'profilePage.dart';
import 'homePage.dart';
import 'notificationPage.dart';
import 'package:FleXcelerate/pages/settings.dart';

class ThemeManager {
  static final ThemeManager _instance = ThemeManager._internal();

  factory ThemeManager() {
    return _instance;
  }

  ThemeManager._internal();

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
    }
  }
}

Future<String?> _getUserEmail() async {
  User? user = FirebaseAuth.instance.currentUser;
  return user?.email;
}

class MyScaffold extends StatefulWidget {
  final Widget body;
  final int currentIndex;

  MyScaffold({
    required this.body,
    required this.currentIndex,
  });

  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  ThemeManager themeManager = ThemeManager();

  final AuthService _auth = AuthService();
  String userName = 'Default User';

  @override
  void initState() {
    super.initState();
    _fetchUserStream();
  }


  void onTabTapped(BuildContext context, int index) {
    if (index != widget.currentIndex) {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                _getPageByIndex(index),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
          )
      );
    }
  }

  Widget _getPageByIndex(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return PlanningPage();
      case 2:
        return NotificationPage();
      case 3:
        return ProfilePage();
      default:
        return Container(); // Return a default widget or handle as needed
    }
  }

  Stream<DocumentSnapshot> _fetchUserStream() {
    final FirebaseAuth _auths = FirebaseAuth.instance;
    final User? user = _auths.currentUser;

    if (user != null) {
      return FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots();
    }
    return Stream.empty();
  }

  @override
  Widget build(BuildContext context) {
    ThemeManager themeManager = ThemeManager();
    UserData? userData = UserDataSingleton().userData;

    return StreamBuilder<DocumentSnapshot>(
      stream: _fetchUserStream(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        //String userName = 'Default User';
        final data = snapshot.data?.data();
        if (data != null) {
          final Map<String, dynamic> userData = data as Map<String, dynamic>;
          final String? firstName = userData['firstName'];
          final String? lastName = userData['lastName'];
          userName = '$firstName $lastName';
        } else {
          userName = 'Default';
        }

        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeManager.themeMode,
          home: Scaffold(
            appBar: AppBar(
              title: Text('FleXcelerate'),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
            body: widget.body,
            extendBody: true,
            bottomNavigationBar: SafeArea(
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: widget.currentIndex,
                onTap: (index) => onTabTapped(context, index),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map),
                    label: 'Planning',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notifications),
                    label: 'Notifications',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: userData?.firstName != null ? Text("${userData?.firstName} ${userData?.lastName}") : Text(userName),
                    accountEmail: FutureBuilder(
                      future: _getUserEmail(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("Loading...");
                        } else {
                          return Text(snapshot.data ?? "No email");
                        }
                      },
                    ),//Text("john.doe@example.com"),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: userData?.profilePhoto ?? const AssetImage('lib/assets/logo.png'),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.greenAccent
                          : Colors.black54,
                    ),
                  ),
                  ListTile(
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppSettings(
                            onDarkModeChanged: (value) {
                              themeManager.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                              setState(() {});
                            },
                            initialThemeMode: themeManager.themeMode == ThemeMode.dark
                                ? 'Dark'
                                : 'Light',
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Logout'),
                    onTap: () async {
                      await _auth.signOut();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}