import 'package:FleXcelerate/pages/Scaffold.dart';
import 'package:FleXcelerate/pages/profileCharts.dart';
import 'package:FleXcelerate/pages/profileData.dart';
import 'package:flutter/material.dart';
import '../logic/user.dart';
import '../logic/dailyStats.dart';

// This page is near completion, there is still some functionality to be added
// before it all comes together, as well as gathering info from the user's database.

// this is of the three different sized cards used to display the user's information.
class SmallProfilePageCards extends StatelessWidget {
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;
  final double leftTitlePadding;
  final double rightTitlePadding;
  final double topTitlePadding;
  final double bottomTitlePadding;
  final String title;
  final String? info;
  final String? columnValue;
  final String? rowValue;


  const SmallProfilePageCards({super.key,
    required this.title,
    this.info,
    this.columnValue,
    this.rowValue,
    required this.leftPadding,
    required this.rightPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.leftTitlePadding,
    required this.rightTitlePadding,
    required this.topTitlePadding,
    required this.bottomTitlePadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: topPadding,
        bottom: bottomPadding,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        shadowColor: Colors.greenAccent,
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.greenAccent : Colors.greenAccent, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          // decoration: const BoxDecoration(
          // ),
          child: Padding(
            padding: EdgeInsets.only(
              left: leftTitlePadding,
              right: rightTitlePadding,
              top: topTitlePadding,
              bottom: bottomTitlePadding,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (rowValue != null)
                      Text(
                        rowValue!,
                        style: const TextStyle(
                          fontSize: 13.0,
                        ),
                      ),
                  ],
                ),
                if (columnValue != null)
                  Text(
                    columnValue!,
                    style: const TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
                if (info != null)
                  Text(
                    info!,
                    style: const TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MediumProfilePageCards extends StatelessWidget {
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;
  final double leftTitlePadding;
  final double rightTitlePadding;
  final double topTitlePadding;
  final double bottomTitlePadding;
  final String title;
  final String? info;
  final String? columnValue;
  final String? rowValue;


  const MediumProfilePageCards({super.key,
    required this.title,
    this.info,
    this.columnValue,
    this.rowValue,
    required this.leftPadding,
    required this.rightPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.leftTitlePadding,
    required this.rightTitlePadding,
    required this.topTitlePadding,
    required this.bottomTitlePadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: topPadding,
        bottom: bottomPadding,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        shadowColor: Colors.greenAccent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white10,
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.greenAccent : Colors.greenAccent, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          // decoration: const BoxDecoration(
          // ),
          child: Padding(
            padding: EdgeInsets.only(
              left: leftTitlePadding,
              right: rightTitlePadding,
              top: topTitlePadding,
              bottom: bottomTitlePadding,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (rowValue != null)
                      Text(
                        rowValue!,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                  ],
                ),
                if (columnValue != null)
                  Text(
                    columnValue!,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                if (info != null)
                  Text(
                    info!,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LargeProfilePageCards extends StatelessWidget {
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;
  final double leftTitlePadding;
  final double rightTitlePadding;
  final double topTitlePadding;
  final double bottomTitlePadding;
  final String title;
  final String? info;
  final String? columnValue;
  final String? rowValue;


  const LargeProfilePageCards({super.key,
    required this.title,
    this.info,
    this.columnValue,
    this.rowValue,
    required this.leftPadding,
    required this.rightPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.leftTitlePadding,
    required this.rightTitlePadding,
    required this.topTitlePadding,
    required this.bottomTitlePadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: topPadding,
        bottom: bottomPadding,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        shadowColor: Colors.greenAccent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.greenAccent : Colors.greenAccent, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          // decoration: const BoxDecoration(
          // ),
          child: Padding(
            padding: EdgeInsets.only(
              left: leftTitlePadding,
              right: rightTitlePadding,
              top: topTitlePadding,
              bottom: bottomTitlePadding,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (rowValue != null)
                      Text(
                        rowValue!,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                  ],
                ),
                if (columnValue != null)
                  Text(
                    columnValue!,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                if (info != null)
                  Text(
                    info!,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CaloriesChartCard extends StatelessWidget {
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;
  final double leftTitlePadding;
  final double rightTitlePadding;
  final double topTitlePadding;
  final double bottomTitlePadding;
  final List<DailyStatistics> info;


  const CaloriesChartCard({super.key,
    required this.info,
    required this.leftPadding,
    required this.rightPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.leftTitlePadding,
    required this.rightTitlePadding,
    required this.topTitlePadding,
    required this.bottomTitlePadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: topPadding,
        bottom: bottomPadding,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        shadowColor: Colors.greenAccent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.greenAccent : Colors.greenAccent, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: leftTitlePadding,
              right: rightTitlePadding,
              top: topTitlePadding,
              bottom: bottomTitlePadding,
            ),
            child: Column(
              children: [
                CaloriesBurnedChart(data: info),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StepsTakenCard extends StatelessWidget {
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;
  final double leftTitlePadding;
  final double rightTitlePadding;
  final double topTitlePadding;
  final double bottomTitlePadding;
  final List<DailyStatistics> info;


  const StepsTakenCard({super.key,
    required this.info,
    required this.leftPadding,
    required this.rightPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.leftTitlePadding,
    required this.rightTitlePadding,
    required this.topTitlePadding,
    required this.bottomTitlePadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: topPadding,
        bottom: bottomPadding,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        shadowColor: Colors.greenAccent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.greenAccent : Colors.greenAccent, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: leftTitlePadding,
              right: rightTitlePadding,
              top: topTitlePadding,
              bottom: bottomTitlePadding,
            ),
            child: Column(
              children: [
                StepsTakenChart(data: info),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  List<DailyStatistics> weeklyData = ProfileData.getWeeklyData();

  @override
  Widget build(BuildContext context) {
    UserData? userData = UserDataSingleton().userData;
    return MyScaffold(currentIndex: 3, body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                      children: [
                        if (userData?.profilePhoto != null)
                          CircleAvatar(
                            backgroundImage: userData?.profilePhoto, // Replace with user's profile image
                            backgroundColor: Colors.greenAccent,
                            radius: 50,
                          ),
                        if (userData?.profilePhoto == null)
                          const CircleAvatar(
                            backgroundImage: AssetImage('lib/assets/logo.png'), // Replace with user's profile image
                            backgroundColor: Colors.greenAccent,
                            radius: 50,
                          ),
                        SizedBox(height: 20),
                        if (userData?.firstName != null && userData?.lastName != null)
                          Text(
                            '${userData?.firstName} ${userData?.lastName}' ?? '', // Replace with user's name
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (userData?.firstName == null && userData?.lastName == null)
                          const Text(
                            'Default', // Replace with user's name
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ]
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                      children: [
                        MediumProfilePageCards(
                          title: 'Streak\n',
                          columnValue: '1\n',
                          info: 'Days',
                          leftPadding: 10,
                          rightPadding: 10,
                          topPadding: 10,
                          bottomPadding: 10,
                          leftTitlePadding: 15,
                          rightTitlePadding: 15,
                          topTitlePadding: 8,
                          bottomTitlePadding: 8,
                        ),
                      ]
                  ),
                  Column(
                    children: [
                      MediumProfilePageCards(
                        title: 'Age: ',
                        rowValue: userData?.age ?? "<int>", // Replaced with the user's age
                        leftPadding: 10,
                        rightPadding: 10,
                        topPadding: 10,
                        bottomPadding: 5,
                        leftTitlePadding: 29,
                        rightTitlePadding: 29,
                        topTitlePadding: 0,
                        bottomTitlePadding: 0,
                      ),
                      MediumProfilePageCards(
                        title: 'Height: ',
                        rowValue: userData?.height ?? "<int>", // Replaced with the user's height
                        leftPadding: 10,
                        rightPadding: 10,
                        topPadding: 10,
                        bottomPadding: 5,
                        leftTitlePadding: 0,
                        rightTitlePadding: 0,
                        topTitlePadding: 0,
                        bottomTitlePadding: 0,
                      ),
                      MediumProfilePageCards(
                        title: 'Weight: ',
                        rowValue: userData?.weight ?? "<int>", // Replaced with the user's weight
                        leftPadding: 10,
                        rightPadding: 10,
                        topPadding: 10,
                        bottomPadding: 10,
                        leftTitlePadding: 0,
                        rightTitlePadding: 0,
                        topTitlePadding: 0,
                        bottomTitlePadding: 0,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Steps Taken', // Update with the user's fitness goals
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              StepsTakenCard(
                info: weeklyData,
                leftPadding: 10,
                rightPadding: 10,
                topPadding: 10,
                bottomPadding: 10,
                leftTitlePadding: 0,
                rightTitlePadding: 10,
                topTitlePadding: 12,
                bottomTitlePadding: 0,
              ),
              const SizedBox(height: 30),
              const Text(
                'Calories Burned', // Replaced with the user's activity history
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              CaloriesChartCard(
                info: weeklyData,
                leftPadding: 10,
                rightPadding: 10,
                topPadding: 10,
                bottomPadding: 10,
                leftTitlePadding: 0,
                rightTitlePadding: 10,
                topTitlePadding: 12,
                bottomTitlePadding: 0,
              ),
            ],
          ),
        ),
      ],
    ),
    );
  }
}