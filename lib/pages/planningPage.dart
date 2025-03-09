import 'package:FleXcelerate/pages/Scaffold.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../logic/activity.dart';


//Page is essentially the page for planning the...
//... activities the user will do or work on.

class PlanningPage extends StatefulWidget {
  @override
  _PlanningPageState createState() => _PlanningPageState();
}

Map<DateTime, List<String>> activities = {};
Map<DateTime, List<String>> meals = {};


DateTime? selectedActivityDayForHomePage; // New state variable
String? selectedActivityForHomePage; // New state variable
DateTime? selectedMealDayForHomePage; // New state variable
String? selectedMealForHomePage; // New state variable


List<Activity> preMadeActivities = [
  Activity(id: '1', name: 'Biking', caloriesPerMinute: 15.0),
  Activity(id: '2', name: 'Running', caloriesPerMinute: 14.2),
  Activity(id: '3', name: 'Swimming', caloriesPerMinute: 8.0),
  Activity(id: '4', name: 'Boxing', caloriesPerMinute: 10.8),
  Activity(id: '5', name: 'Archery', caloriesPerMinute: 4.1),
  // Add more activities as needed
];

List<Meal> preMadeMeals = [
  Meal(id: '1', name: 'Breakfast: Cereal with milk', calories: 250.0),
  Meal(id: '2', name: 'Lunch: Chicken salad', calories: 350.0),
  Meal(id: '3', name: 'Dinner: Grilled salmon with vegetables', calories: 500.0),
  Meal(id: '4', name: 'Snack: Greek yogurt', calories: 150.0),
  // Add more meals as needed
];

class _PlanningPageState extends State<PlanningPage> {
  List<DateTime> selectedDays = [];
  bool isFirstLaunch = true;

  //FirstLaunch message
  @override
  void initState() {
    super.initState();
  }

  //Widget and title of the page goes here
  @override
  Widget build(BuildContext context) {
    return MyScaffold(currentIndex: 1, body: ListView(
      children: [
        PlanningPageCards(
          title: 'Plans for the Week',
          leftPadding: 16.0,
          rightPadding: 16.0,
          topPadding: 16.0,
          bottomPadding: 16.0,
          leftTitlePadding: 16.0,
          rightTitlePadding: 16.0,
          topTitlePadding: 16.0,
          bottomTitlePadding: 16.0,
        ),

        //Calendar widget that lets the user select any day or days to add activities in
        CalendarWidget(
          onClearButtonPressed: () {
            setState(() {
              selectedDays.clear();
            });
          },
          onAddActivityButtonPressed: _showAddActivityDialog,
          onAddMealButtonPressed: _showAddMealDialog,
          activities: activities,
          selectedDays: selectedDays,
          onDaySelected: (selectedDay) {
            if (selectedDays.contains(selectedDay)) {
              setState(() {
                selectedDays.remove(selectedDay);
              });
            } else {
              setState(() {
                selectedDays.add(selectedDay);
              });
            }
            selectedActivityDayForHomePage = null; // Reset selected day for homepage
          },
          //This feature is only for if you want to add a activity on one specific day
          onDayLongPressed: (selectedDay) {
            _showAddActivityDialog(selectedDay);
            _showAddMealDialog(selectedDay);
          },
        ),

        //This is where the activities are shown
        ActivitiesListWidget(
          activities: activities,
          onDeleteActivity: (DateTime day, String activity) {
            setState(() {
              activities[day]!.remove(activity);
              if (activities[day]!.isEmpty) {
                activities.remove(day);
              }
            });
          },
          onClearActivity: () {
            setState(() {
              activities.clear();
            });
          },
        ),
        //This is where the meals are shown
        MealsListWidget(
          meals: meals,
          onDeleteMeal: (DateTime day, String meal) {
            setState(() {
              meals[day]!.remove(meal);
              if (meals[day]!.isEmpty) {
                meals.remove(day);
              }
            });
          },
          onClearMeal: () {
            setState(() {
              meals.clear();
            });
          },
        ),
      ],
    ),
    );
  }

  void _showAddActivityDialog([DateTime? day]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Activity for selected days'),
        content: SingleChildScrollView(
          child: Column(
          children: [
            Text('Select an activity:'),
            SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              items: preMadeActivities.map((Activity activity) {
                return DropdownMenuItem<String>(
                  value: activity.name,
                  child: Text(activity.name),
                );
              }).toList(),
              onChanged: (selectedActivity) {
                if (selectedActivity != null) {

                  selectedActivityDayForHomePage = day; // Store selected day
                  selectedActivityForHomePage = selectedActivity;

                  setState(() {
                    List<DateTime> days = day != null ? [day] : selectedDays;
                    for (DateTime day in days) {
                      if (activities.containsKey(day)) {
                        activities[day]!.add(selectedActivity);
                      } else {
                        activities[day] = [selectedActivity];
                      }
                    }
                    Navigator.of(context).pop(); // Close the dialog
                  });
                }
              },
              hint: Text('Select activity'),
            ),
          ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAddMealDialog([DateTime? day]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Meals for selected days'),
        content: SingleChildScrollView(  // Add this
          child: Column(
            children: [
              Text('Select an meal:'),
              SizedBox(height: 10),
              DropdownButton<String>(
                isExpanded: true,
                items: preMadeMeals.map((Meal meal) {
                  return DropdownMenuItem<String>(
                    value: meal.name,
                    child: Text(meal.name),
                  );
                }).toList(),
                onChanged: (selectedMeal) {
                  if (selectedMeal != null) {

                    selectedMealDayForHomePage = day; // Store selected day
                    selectedMealForHomePage = selectedMeal;

                    setState(() {
                      List<DateTime> days = day != null ? [day] : selectedDays;
                      for (DateTime day in days) {
                        if (meals.containsKey(day)) {
                          meals[day]!.add(selectedMeal);
                        } else {
                          meals[day] = [selectedMeal];
                        }
                      }
                      Navigator.of(context).pop(); // Close the dialog
                    });
                  }
                },
                hint: Text('Select meal'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

}//planning page extends planning page state

class CalendarWidget extends StatelessWidget {
  final Map<DateTime, List<String>> activities;
  final List<DateTime> selectedDays;
  final Function(DateTime) onDaySelected;
  final Function(DateTime) onDayLongPressed;
  final Function() onAddActivityButtonPressed;
  final Function() onAddMealButtonPressed;
  final VoidCallback onClearButtonPressed;

  CalendarWidget({
    required this.activities,
    required this.selectedDays,
    required this.onDaySelected,
    required this.onDayLongPressed,
    required this.onAddActivityButtonPressed,
    required this.onAddMealButtonPressed,
    required this.onClearButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 8,
        shadowColor: Theme.of(context).brightness == Brightness.dark ? Colors.greenAccent : Colors.greenAccent,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.greenAccent : Colors.greenAccent, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
                selectedDayPredicate: (day) => selectedDays.contains(day),
                onDaySelected: (selectedDay, focusedDay) {
                  onDaySelected(selectedDay);
                },
                onDayLongPressed: (selectedDay, focusedDay) {
                  onDayLongPressed(selectedDay);
                },
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  defaultTextStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  weekendTextStyle: TextStyle(
                    color: Colors.red,
                  ),
                  selectedTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              //Added button alongside LongPress to add activities.. and clear button to remove all the selected days instantly
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: onAddActivityButtonPressed,
                        icon: Icon(Icons.fitness_center),
                        label: Text('Add Activity'),
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
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: onAddMealButtonPressed,
                        icon: Icon(Icons.fastfood),
                        label: Text('Add Meal'),
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
                  ),
                ],
              ),//row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: onClearButtonPressed,
                        icon: Icon(Icons.clear),
                        label: Text('Clear'),
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
                  ),
                ],
              ),//row
            ],//children
          ),//column
        ),//container
      ),//card
    );//padding
  }
}

class ActivitiesListWidget extends StatelessWidget {
  final Map<DateTime, List<String>> activities;
  final Function(DateTime, String) onDeleteActivity;
  final VoidCallback onClearActivity;

  ActivitiesListWidget({required this.activities, required this.onDeleteActivity, required this.onClearActivity,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 8,
        shadowColor: Theme.of(context).brightness == Brightness.dark ? Colors.greenAccent : Colors.greenAccent,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.greenAccent : Colors.greenAccent, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Activities',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              ...activities.entries.map(
                    (entry) => ListTile(
                  title: Text(
                    DateFormat('yyyy-MM-dd').format(entry.key),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: entry.value.map((activity) => Row(
                      children: [
                        Expanded(
                          child: Text(
                            activity,
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            onDeleteActivity(entry.key, activity);
                          },
                        ),
                      ],
                    )).toList(),
                  ),
                ),
              ).toList(),
              ElevatedButton.icon(
                onPressed: onClearActivity,
                icon: Icon(Icons.clear),
                label: Text('Clear All Activities'),//Clears all activities instead of one by one
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
            ],
          ),
        ),
      ),
    );
  }
}

class MealsListWidget extends StatelessWidget {
  final Map<DateTime, List<String>> meals;
  final Function(DateTime, String) onDeleteMeal;
  final VoidCallback onClearMeal;

  MealsListWidget({required this.meals, required this.onDeleteMeal, required this.onClearMeal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 8,
        shadowColor: Theme.of(context).brightness == Brightness.dark ? Colors.greenAccent : Colors.greenAccent,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.greenAccent : Colors.greenAccent, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Meals',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              ...meals.entries.map(
                    (entry) => ListTile(
                  title: Text(
                    DateFormat('yyyy-MM-dd').format(entry.key),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: entry.value.map((meal) => Row(
                      children: [
                        Expanded(
                          child: Text(
                            meal,
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            onDeleteMeal(entry.key, meal);
                          },
                        ),
                      ],
                    )).toList(),
                  ),
                ),
              ).toList(),
              ElevatedButton.icon(
                onPressed: onClearMeal,
                icon: Icon(Icons.clear),
                label: Text('Clear All Meals'),//clears all meals instead of selecting one by one
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
            ],
          ),
        ),
      ),
    );
  }
}

class PlanningPageCards extends StatelessWidget {
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;
  final double leftTitlePadding;
  final double rightTitlePadding;
  final double topTitlePadding;
  final double bottomTitlePadding;
  final String title;

  PlanningPageCards({
    required this.title,
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
        elevation: 8,
        shadowColor: Colors.greenAccent,
        child: Container(
          padding: EdgeInsets.all(16),
          color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF212121) : Colors.greenAccent,
          child: Padding(
            padding: EdgeInsets.only(
              left: leftTitlePadding,
              right: rightTitlePadding,
              top: topTitlePadding,
              bottom: bottomTitlePadding,
            ),
            child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}
