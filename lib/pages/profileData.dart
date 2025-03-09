import 'dart:core';
import '../logic/dailyStats.dart';
import 'homePage.dart';

class ProfileData {
  static List<DailyStatistics> getWeeklyData() {
    if (DateTime.now().weekday == DateTime.sunday) {
      return [
        DailyStatistics(sunday: DateTime.sunday, caloriesBurned: HomePageState().caloriesBurnedToday(), stepsTaken: HomePageState().stepsTakenToday()),
        DailyStatistics(monday: DateTime.monday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(tuesday: DateTime.tuesday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(wednesday: DateTime.wednesday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(thursday: DateTime.thursday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(friday: DateTime.friday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(saturday: DateTime.saturday, caloriesBurned: 0, stepsTaken: 0),
      ];
    }
    else if (DateTime.now().weekday == DateTime.monday) {
      return [
        DailyStatistics(sunday: DateTime.sunday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(monday: DateTime.monday, caloriesBurned: HomePageState().caloriesBurnedToday(), stepsTaken: HomePageState().stepsTakenToday()),
        DailyStatistics(tuesday: DateTime.tuesday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(wednesday: DateTime.wednesday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(thursday: DateTime.thursday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(friday: DateTime.friday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(saturday: DateTime.saturday, caloriesBurned: 0, stepsTaken: 0),
      ];
    }
    else if (DateTime.now().weekday == DateTime.tuesday) {
      return [
        DailyStatistics(sunday: DateTime.sunday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(monday: DateTime.monday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(tuesday: DateTime.tuesday, caloriesBurned: HomePageState().caloriesBurnedToday(), stepsTaken: HomePageState().stepsTakenToday()),
        DailyStatistics(wednesday: DateTime.wednesday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(thursday: DateTime.thursday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(friday: DateTime.friday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(saturday: DateTime.saturday, caloriesBurned: 0, stepsTaken: 0),
      ];
    }
    else if (DateTime.now().weekday == DateTime.wednesday) {
      return [
        DailyStatistics(sunday: DateTime.sunday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(monday: DateTime.monday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(tuesday: DateTime.tuesday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(wednesday: DateTime.wednesday, caloriesBurned: HomePageState().caloriesBurnedToday(), stepsTaken: HomePageState().stepsTakenToday()),
        DailyStatistics(thursday: DateTime.thursday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(friday: DateTime.friday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(saturday: DateTime.saturday, caloriesBurned: 0, stepsTaken: 0),
      ];
    }
    else if (DateTime.now().weekday == DateTime.thursday) {
      return [
        DailyStatistics(sunday: DateTime.sunday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(monday: DateTime.monday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(tuesday: DateTime.tuesday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(wednesday: DateTime.wednesday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(thursday: DateTime.thursday, caloriesBurned: HomePageState().caloriesBurnedToday(), stepsTaken: HomePageState().stepsTakenToday()),
        DailyStatistics(friday: DateTime.friday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(saturday: DateTime.saturday, caloriesBurned: 0, stepsTaken: 0),
      ];
    }
    else if (DateTime.now().weekday == DateTime.friday) {
      return [
        DailyStatistics(sunday: DateTime.sunday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(monday: DateTime.monday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(tuesday: DateTime.tuesday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(wednesday: DateTime.wednesday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(thursday: DateTime.thursday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(friday: DateTime.friday, caloriesBurned: HomePageState().caloriesBurnedToday(), stepsTaken: HomePageState().stepsTakenToday()),
        DailyStatistics(saturday: DateTime.saturday, caloriesBurned: 0, stepsTaken: 0),
      ];
    }
    else if (DateTime.now().weekday == DateTime.saturday) {
      return [
        DailyStatistics(sunday: DateTime.sunday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(monday: DateTime.monday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(tuesday: DateTime.tuesday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(wednesday: DateTime.wednesday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(thursday: DateTime.thursday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(friday: DateTime.friday, caloriesBurned: 0, stepsTaken: 0),
        DailyStatistics(saturday: DateTime.saturday, caloriesBurned: HomePageState().caloriesBurnedToday(), stepsTaken: HomePageState().stepsTakenToday()),
      ];
    }
    return [
      DailyStatistics(sunday: DateTime.sunday, caloriesBurned: 0, stepsTaken: 0),
      DailyStatistics(monday: DateTime.monday, caloriesBurned: 0, stepsTaken: 0),
      DailyStatistics(tuesday: DateTime.tuesday, caloriesBurned: 0, stepsTaken: 0),
      DailyStatistics(wednesday: DateTime.wednesday, caloriesBurned: 0, stepsTaken: 0),
      DailyStatistics(thursday: DateTime.thursday, caloriesBurned: 0, stepsTaken: 0),
      DailyStatistics(friday: DateTime.friday, caloriesBurned: 0, stepsTaken: 0),
      DailyStatistics(saturday: DateTime.saturday, caloriesBurned: 0, stepsTaken: 0),
    ];
  }
}