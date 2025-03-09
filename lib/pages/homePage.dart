import 'dart:async';
import 'package:FleXcelerate/pages/Scaffold.dart';
import 'package:FleXcelerate/pages/planningPage.dart';
import 'package:FleXcelerate/pages/timerPage.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../logic/activity.dart';
import '../logic/user.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}
int waterCount = 0;


// Creates design for the homepage using the class HomePageCards to create numerous cards given specific padding
// Functionality for cards will be added at a later date
class HomePageState extends State<HomePage> {

  UserData? userData = UserDataSingleton().userData;
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  StreamController<dynamic> _combinedStreamController = StreamController<dynamic>();
  bool _initialized = false;
  int lastTotalStepCount = 0;
  String _lastPedestrianStatus = 'Idle';
  late List<String> selectedActivities = activities[selectedActivityDayForHomePage!] ?? [];
  int currentIndex = 0;


  List<Activity> remainingActivities = [
    Activity(id: '1', name: 'Biking', caloriesPerMinute: 15.0),
    Activity(id: '2', name: 'Running', caloriesPerMinute: 14.2),
    Activity(id: '3', name: 'Swimming', caloriesPerMinute: 8.0),
    Activity(id: '4', name: 'Boxing', caloriesPerMinute: 10.8),
    Activity(id: '5', name: 'Archery', caloriesPerMinute: 4.1),
    // Add more activities as needed
  ];

  // Define YouTube video links for each activity
  final Map<String, String> activityVideoLinks = {
    'Biking': 'https://www.youtube.com/watch?v=VsuShNWghXk',
    'Running': 'https://www.youtube.com/watch?v=kVnyY17VS9Y',
    'Swimming': 'https://www.youtube.com/watch?v=p6ROh-M7S0k',
    'Boxing': 'https://www.youtube.com/watch?v=kKDHdsVN0b8',
    'Archery': 'https://www.youtube.com/watch?v=5_c6K_DYpRU',
    // Add more activities and their corresponding YouTube video links
  };

  // Add a method to launch YouTube video using url_launcher package
  void launchYouTubeVideo(String activity) async {
    final link = activityVideoLinks[activity];
    if (link != null && await canLaunch(link)) {
      await launch(link);
    } else {
      // Handle the case where the link cannot be launched
      print('Cannot launch YouTube video link for $activity');
    }
  }

  @override
  void initState() {
    super.initState();
    //initPlatformState();
    checkAndRequestPermissions();
  }

  Future<void> checkAndRequestPermissions() async {
    // Check if permission is granted
    if (await Permission.activityRecognition.request().isGranted) {
      // Permission granted, you can now initialize and use step count functionality.
      await initPlatformState(); // You can call your initialization function here.

      setState(() {
        _initialized = true;
      });


    } else {
      showPermissionDeniedDialog();
      // Permission not granted. Handle accordingly.
      // You might want to show a dialog explaining why the permission is necessary and redirect the user to the settings page.
    }
  }

  void showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Required'),
          content: Text('Step count functionality requires permission to access activity data. Please grant the necessary permission in the app settings.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> initPlatformState() async {
    // Set default values
    lastTotalStepCount = 0;
    _lastPedestrianStatus = 'Idle';

    // Init streams
    _pedestrianStatusStream = await Pedometer.pedestrianStatusStream;
    _stepCountStream = await Pedometer.stepCountStream;

    // Listen to streams, add data to the combined stream
    _stepCountStream.listen((StepCount event) {
      _combinedStreamController.add(event);
      lastTotalStepCount = event.steps;
    }).onError((error) {
      onStepCountError(error);
    });

    _pedestrianStatusStream.listen((PedestrianStatus event) {
      _combinedStreamController.add(event);
      _lastPedestrianStatus = event.status;
    }).onError((error) {
      onPedestrianStatusError(error);
    });
  }

  /// Handle step count changed
  void onStepCount(StepCount event) {
    int steps = event.steps;
    DateTime timeStamp = event.timeStamp;
    // Update your UI or perform any other actions with the step count
  }

  /// Handle status changed
  void onPedestrianStatusChanged(PedestrianStatus event) {
    String status = event.status;
    DateTime timeStamp = event.timeStamp;
    // Handle pedestrian status changes if needed
  }

  /// Handle the error
  void onPedestrianStatusError(error) {
    print('Pedestrian Status Error: $error');
  }

  /// Handle the error
  void onStepCountError(error) {
    print('Step Count Error: $error');
  }

  double caloriesBurnedToday() {
    return totalCaloriesBurned;
  }

  double stepsTakenToday() {
    return lastTotalStepCount.toDouble();
  }

  @override
  void dispose() {
    // Cancel the stream subscriptions when the widget is disposed
    _stepCountStream.drain();
    _pedestrianStatusStream.drain();
    _combinedStreamController.close();
    super.dispose();
  }

  // Creates a function for handling time based homepage message
  String getGreeting() {
    final now = DateTime.now();
    final currentTime = now.hour;

    if (currentTime < 12) {
      return ' Good Morning!';
    } else if (currentTime < 17) {
      return ' Good Afternoon!';
    } else {
      return ' Good Evening!';
    }
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  Future<void> _refreshHomePage() async {
    // Implement your refresh logic here.
    // For example, you can fetch new data from the server.
    // For demonstration purposes, we use a delay to simulate a network request.
    await Future.delayed(Duration(seconds: 1));

    // After the data is refreshed, show a notification.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Homepage Refreshed!'),
        duration: Duration(seconds: 2),
      ),
    );

    // After the data is refreshed, rebuild the widget to reflect the changes.
    setState(() {
      // Update your data here if needed.
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(currentIndex: currentIndex,
      body: RefreshIndicator(
        onRefresh: _refreshHomePage,
        child: ListView(      // For scrollable page
          children:[
            Padding(
              padding: EdgeInsets.only(left: 8, right: 10, top: 15, bottom: 0),
              child: Text(
                getGreeting(),
                style: TextStyle(
                  fontSize: 24, // Font size
                  fontWeight: FontWeight.bold, // Text weight (e.g., bold)
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, // Text color
                ),
              ),
            ),

            Column(
              children: <Widget>[

                // Holds the Daily Activity, Calorie and Steps cards (first three)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 330,
                        child: HomePageCards(
                          leftPadding: 10,
                          rightPadding: 10,
                          topPadding: 10,
                          bottomPadding: 10,
                          leftTitlePadding: 0,
                          rightTitlePadding: 0,
                          topTitlePadding: 0,
                          bottomTitlePadding: 0,
                          content: Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Daily Activities',
                                      //style: TextStyle(fontSize: 17),
                                    ),
                                    SizedBox(height: 20),
                                    if (selectedActivityDayForHomePage != null && isToday(selectedActivityDayForHomePage!))
                                      ...activities[selectedActivityDayForHomePage!]?.map((activity) {
                                        var matchingActivity = preMadeActivities.firstWhere(
                                              (preMadeActivity) => preMadeActivity.name == activity,
                                          orElse: () => Activity(id: '', name: '', caloriesPerMinute: 0.0),
                                        );

                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 15),
                                          child: Dismissible(
                                            key: Key(activity), // Unique key for each meal
                                            onDismissed: (direction) {
                                              // Remove the meal from the list when swiped
                                              activities[selectedActivityDayForHomePage!]?.remove(activity);
                                              _refreshHomePage();
                                            },
                                            background: Container(
                                              color: Colors.red, // Background color when swiping
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.only(right: 16),
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => TimerPage(activity: matchingActivity),
                                                  ),
                                                );
                                              },
                                              child: Text(matchingActivity.name),
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all<Color>(
                                                  Theme.of(context).brightness == Brightness.dark ? Colors.grey[900]! : Colors.greenAccent,
                                                ),
                                                foregroundColor: MaterialStateProperty.all<Color>(
                                                  Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                                ),
                                                padding: MaterialStateProperty.all<EdgeInsets>(
                                                  EdgeInsets.all(16.0),
                                                ),
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                ),
                                                elevation: MaterialStateProperty.all<double>(8.0),
                                              ),
                                            ),
                                          ),
                                        );
                                      })?.toList() ?? [],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 162,
                              width: 500,
                              child: HomePageCards(
                                leftPadding: 0,
                                rightPadding: 10,
                                topPadding: 10,
                                bottomPadding: 0,
                                leftTitlePadding: 0,
                                rightTitlePadding: 0,
                                topTitlePadding: 0,
                                bottomTitlePadding: 0,
                                content: Center(
                                    child: Column (
                                      children: [
                                        Padding(padding: EdgeInsets.only(left: 5, right: 0, top: 0, bottom: 0),
                                          child: Image(
                                            width: 60,
                                            height: 50,
                                            image: AssetImage('lib/assets/calorieIcon.png'),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Text('Calorie Goal: ${userData?.calorieGoal ?? 0}'),
                                        Text('Total Calories Burned: $totalCaloriesBurned',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 157,
                              width: 500,
                              child: HomePageCards(
                                leftPadding: 0,
                                rightPadding: 10,
                                topPadding: 10,
                                bottomPadding: 0,
                                leftTitlePadding: 0,
                                rightTitlePadding: 0,
                                topTitlePadding: 0,
                                bottomTitlePadding: 0,
                                content: Center (
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(padding: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 5),

                                        child: ClipOval(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.greenAccent, // Set the color of the border
                                                width: 3.0, // Set the width of the border
                                              ),
                                            ),
                                            child: Image(

                                              image: AssetImage('lib/assets/logo.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                      ),

                                      if(_initialized)
                                        Text("Step Goal: ${userData?.stepsGoal ?? 0}"),

                                      if (_initialized)
                                        StreamBuilder<StepCount>(
                                          stream: _stepCountStream!,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Padding(padding: EdgeInsets.only(bottom: 0),
                                                child: Text(
                                                  'Steps Taken: ${snapshot.data?.steps}',
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Text('Error: Steps tracking unsupported on this device');
                                            } else {
                                              return Padding(padding: EdgeInsets.only(bottom: 0),
                                                child: Text(
                                                  'Steps Taken: $lastTotalStepCount',
                                                ),
                                              );
                                            }
                                          },
                                        )
                                      else
                                        Text('Loading...'),
                                    ],
                                  ),
                                  //   ],
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Title text for new section (Find New Activities)
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 10, top: 30, bottom: 0),
                  child: Text(
                    'Find New Activities',
                    style: TextStyle(
                      fontSize: 24, // Font size
                      fontWeight: FontWeight.bold, // Text weight (e.g., bold)
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, // Text color
                    ),
                  ),
                ),

                // New activity finder that uses a horizontal scroll
                //Added HTTP request and a prompt for users to select to watch tut vid or go to planning page
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            if (selectedActivityDayForHomePage != null &&
                                isToday(selectedActivityDayForHomePage!) &&
                                remainingActivities.isNotEmpty)
                              ...preMadeActivities.where((preMadeActivity) {
                                return !selectedActivities.contains(preMadeActivity.name);
                              }).map((activity) {
                                remainingActivities.remove(activity);
                                return GestureDetector(
                                  onTap: () async {
                                    // Show a dialog with options
                                    bool watchVideo = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Activity Options"),
                                          content: Text("Would you like to watch the tutorial video or go to the planning page?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true); // Watch video
                                              },
                                              child: Text("Watch Video"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(false); // Go to planning page
                                              },
                                              child: Text("Go to Planning Page"),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (watchVideo != null && watchVideo) {
                                      // Launch YouTube video for the selected activity
                                      launchYouTubeVideo(activity.name);
                                    } else {
                                      // Navigate to the PlanningPage
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlanningPage(),
                                        ),
                                      );
                                    }
                                  },
                                  child: HomePageCards(
                                    leftPadding: 8,
                                    rightPadding: 10,
                                    topPadding: 5,
                                    bottomPadding: 10,
                                    leftTitlePadding: 8,
                                    rightTitlePadding: 100,
                                    topTitlePadding: 5,
                                    bottomTitlePadding: 0,
                                    content: Column(
                                      children: <Widget>[
                                        Text(activity.name),
                                        Text(''),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList()
                            else if (remainingActivities.isEmpty)
                            // Default card when there are no activities
                              HomePageCards(
                                leftPadding: 8,
                                rightPadding: 10,
                                topPadding: 5,
                                bottomPadding: 10,
                                leftTitlePadding: 8,
                                rightTitlePadding: 100,
                                topTitlePadding: 5,
                                bottomTitlePadding: 0,
                                content: Column(
                                  children: <Widget>[
                                    Text('No New Activities Available!'),
                                  ],
                                ),
                              )
                            else
                              Row(
                                children: [
                                  for (String activity in ['Biking', 'Running', 'Swimming', 'Boxing', 'Archery'])
                                    GestureDetector(
                                      onTap: () async {
                                        // Show a dialog with options
                                        bool watchVideo = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Activity Options"),
                                              content: Text("Would you like to watch the tutorial video or go to the planning page?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(true); // Watch video
                                                  },
                                                  child: Text("Watch Video"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(false); // Go to planning page
                                                  },
                                                  child: Text("Go to Planning Page"),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (watchVideo != null && watchVideo) {
                                          // Launch YouTube video for the selected activity
                                          launchYouTubeVideo(activity);
                                        } else {
                                          // Navigate to the PlanningPage
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PlanningPage(),
                                            ),
                                          );
                                        }
                                      },
                                      child: HomePageCards(
                                        leftPadding: 8,
                                        rightPadding: 10,
                                        topPadding: 5,
                                        bottomPadding: 10,
                                        leftTitlePadding: 8,
                                        rightTitlePadding: 100,
                                        topTitlePadding: 5,
                                        bottomTitlePadding: 0,
                                        content: Column(
                                          children: <Widget>[
                                            Text(activity),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Holds the meals and water counter cards (Final 2 cards)
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 200,
                        child: HomePageCards(
                          leftPadding: 10,
                          rightPadding: 10,
                          topPadding: 10,
                          bottomPadding: 10,
                          leftTitlePadding: 0,
                          rightTitlePadding: 0,
                          topTitlePadding: 0,
                          bottomTitlePadding: 0,
                          // content: Text('Meals to Eat'),
                          content: Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.only(left: 5, right: 0, top: 0, bottom: 5),

                                      child: Image(
                                        width: 40,
                                        height: 50,
                                        image: AssetImage('lib/assets/mealIcon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),

                                    Text(
                                      'Meals To Eat',
                                    ),
                                    SizedBox(height: 20),
                                    if (selectedMealDayForHomePage != null && isToday(selectedMealDayForHomePage!))
                                      ...meals[selectedMealDayForHomePage!]?.map((meal) {
                                        var matchingActivity = preMadeMeals.firstWhere(
                                              (preMadeMeal) => preMadeMeal.name == meal,
                                          orElse: () => Meal(id: '', name: '', calories: 0.0),
                                        );
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 15),
                                          child: Dismissible(
                                            key: Key(meal), // Unique key for each meal
                                            onDismissed: (direction) {
                                              // Remove the meal from the list when swiped
                                              meals[selectedMealDayForHomePage!]?.remove(meal);
                                              _refreshHomePage();
                                            },
                                            background: Container(
                                              color: Colors.red, // Background color when swiping
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.only(right: 16),
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () {
                                              },
                                              child: Text(matchingActivity.name),
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all<Color>(
                                                  Theme.of(context).brightness == Brightness.dark ? Colors.grey[900]! : Colors.greenAccent,
                                                ),
                                                foregroundColor: MaterialStateProperty.all<Color>(
                                                  Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                                ),
                                                padding: MaterialStateProperty.all<EdgeInsets>(
                                                  EdgeInsets.all(16.0),
                                                ),
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                ),
                                                elevation: MaterialStateProperty.all<double>(8.0),
                                              ),
                                            ),
                                          ),
                                        );
                                      })?.toList() ?? [],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: SizedBox(
                        height: 200,
                        child: HomePageCards(
                          leftPadding: 10,
                          rightPadding: 10,
                          topPadding: 10,
                          bottomPadding: 10,
                          leftTitlePadding: 0,
                          rightTitlePadding: 0,
                          topTitlePadding: 0,
                          bottomTitlePadding: 0,
                          content: Column(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(bottom: 50),

                                child: Text('Cups of Water: $waterCount'),

                              ),

                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: (){
                                          setState(() {
                                            if (waterCount > 0) {
                                              waterCount--;
                                            }
                                          });
                                        }
                                    ),
                                    Image.asset(
                                      'lib/assets/cup.jpg', // Image path from assets folder
                                      width: 40, // Set the width as needed
                                      height: 40, // Set the height as needed
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: (){
                                          setState(() {
                                            waterCount++;
                                          });
                                        }
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// Card class made to reduce code duplication and code smell in the UI section
// Now you only need to pass padding requirements in the UI section to have control of the card dimensions
class HomePageCards extends StatelessWidget {
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;
  final double leftTitlePadding;
  final double rightTitlePadding;
  final double topTitlePadding;
  final double bottomTitlePadding;
  final Widget content;


  HomePageCards({
    required this.leftPadding,
    required this.rightPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.leftTitlePadding,
    required this.rightTitlePadding,
    required this.topTitlePadding,
    required this.bottomTitlePadding,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(left: leftPadding, right: rightPadding, top: topPadding, bottom: bottomPadding),
      child: Card(
        // Card Design
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 8,
        shadowColor: Colors.greenAccent,
        child: Container(
          padding: EdgeInsets.all(16),

          // Card colours
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white10,
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.greenAccent : Colors.greenAccent, width: 1),
          ),

          child: Padding(
            padding: EdgeInsets.only(left: leftTitlePadding, right: rightTitlePadding, top: topTitlePadding, bottom: bottomTitlePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                content, // Inserted the content widget here
              ],
            ),
          ),
        ),
      ),
    );
  }
}

