import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Scaffold.dart';
import '../logic/user.dart';

// So all of the functionality of this page is complete all that's left to do is
// have every value the user changes on this page updated in the database to then
// be displayed on the other pages.

class EditProfilePage extends StatefulWidget {

  const EditProfilePage({super.key,});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {

  String? newFirstName;
  String? newLastName;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  File? _image;

  String? selectedHeightUnit;
  double? heightValueInFeet;
  double? heightValueInCentimeters;
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();
  final TextEditingController _centimetersController = TextEditingController();

  String? selectedWeightUnit;
  double? weightValueInPounds;
  double? weightValueInKilograms;
  double? weightGoalValueInPounds;
  double? weightGoalValueInKilograms;
  final TextEditingController _poundsController = TextEditingController();
  final TextEditingController _goalPoundsController = TextEditingController();
  final TextEditingController _kilogramsController = TextEditingController();
  final TextEditingController _goalKilogramsController = TextEditingController();

  String? selectedGender;

  int selectedMonth = 1;
  int selectedDay = 1;
  int selectedYear = DateTime.now().year;

  final TextEditingController calorieGoalController = TextEditingController();
  final TextEditingController stepsGoalController = TextEditingController();

  // this method shows an AlertDialog that pops up when the user selects the Last Name TextButton,
  // which allows the user to type in their last name.
  void _showFirstNameDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 110),
            actions: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(label: Text('First Name', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black))),
                  ),
                  const SizedBox(height: 5),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    icon: const Icon(Icons.check, color: Colors.greenAccent),
                  ),
                ],
              ),
            ],
          );
        }
    );
  }

  // this method shows an AlertDialog that pops up when the user selects the First Name TextButton,
  // which allows the user to type in their first name.
  void _showLastNameDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 110),
            actions: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _lastNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(label: Text('Last Name', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black))),
                  ),
                  const SizedBox(height: 5),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    icon: const Icon(Icons.check, color: Colors.greenAccent),
                  ),
                ],
              ),
            ],
          );
        }
    );
  }

  // this method sends the user to their photo gallery where they select a photo as their pfp
  Future<void> _getImageFromGallery() async {
    if (await Permission.photos.request().isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } else {
      print('Permission not granted.');
    }
  }

  // this method sends the user to their camera to use the photo they take as their pfp
  Future<void> _getImageFromCamera() async {
    if (await Permission.camera.request().isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } else {
      print('Permission not granted.');
    }
  }

  // this method shows the Alert Dialog that pops up when the Profile Photo TextButton is selected,
  // which gives the user the choice to either take a photo, or choose from their gallery.
  void _showPFPSelectionDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    _getImageFromCamera();
                    Navigator.of(context).pop();
                  },
                  child: Text('Take Photo', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black))
              ),
              const ColoredBox(color: Colors.greenAccent, child: SizedBox(height: 40, width: 1)),
              TextButton(
                  onPressed: () {
                    _getImageFromGallery();
                    Navigator.of(context).pop();
                  },
                  child: Text('Choose Existing Photo', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black))
              ),
            ],
          );
        }
    );
  }

  // this method handle the info displayed in the console when the user selects a height unit and confirms their height.
  void _handleHeightSelection() {
    double? heightValue;

    if (selectedHeightUnit == 'Feet/Inches') {
      double feet = double.tryParse(_feetController.text) ?? 0.0;
      double inches = double.tryParse(_inchesController.text) ?? 0.0;

      // Convert feet and inches to centimeters (you may want to use a more accurate conversion factor)
      heightValue = feet * 30.48 + inches * 2.54;
    } else if (selectedHeightUnit == 'Centimeters') {
      heightValue = double.tryParse(_centimetersController.text);
    }

    if (heightValue != null) {
      print('Selected Height: $heightValue cm');
      // TODO: Implement logic to update the user's profile with the new height
    }
  }

  // this method shows the initial AlertDialog that pops up when the user selects the Height TextButton,
  // which the user then chooses the height unit of their choice.
  void _heightUnitPopUp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 90),
            title: const Center(child: Text('Select Height')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: selectedHeightUnit,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedHeightUnit = newValue;
                          Navigator.of(context).pop();
                        });

                        _heightUnitPopUp();
                      },
                      items: <String>['Feet/Inches', 'Centimeters']
                          .map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
                if (selectedHeightUnit == 'Feet/Inches')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          controller: _feetController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(label: Text('Feet', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black))),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          controller: _inchesController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(label: Text('Inches', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black))),
                        ),
                      ),
                    ],
                  ),
                if (selectedHeightUnit == 'Centimeters')
                  SizedBox(
                    width: 90,
                    child: TextFormField(
                      controller: _centimetersController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                const SizedBox(height: 10),
                IconButton(
                  onPressed: () {
                    _handleHeightSelection();
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  icon: const Icon(Icons.check, color: Colors.greenAccent),
                ),
              ],
            ),
          );
        });
  }

  // this method shows the AlertDialog that pops up when the user selects one of the height units,
  // to then allow the user to fill in the TextFieldForms with their height.
  void _showHeightUnitPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 90),
          title: const Center(child: Text('Select Height')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: selectedHeightUnit,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedHeightUnit = newValue;
                        Navigator.of(context).pop();
                        _heightUnitPopUp();
                      });
                    },
                    items: <String>['Feet/Inches', 'Centimeters']
                        .map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
              if (selectedHeightUnit == 'Feet/Inches')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: _feetController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(label: Text('Feet', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black))),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: _inchesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(label: Text('Inches', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black))),
                      ),
                    ),
                  ],
                ),
              if (selectedHeightUnit == 'Centimeters')
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: _centimetersController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              const SizedBox(height: 10),
              IconButton(
                onPressed: () {
                  _handleHeightSelection();
                  Navigator.of(context).pop();
                  setState(() {});
                },
                icon: const Icon(Icons.check, color: Colors.greenAccent),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleWeightSelection() {
    double? weightValue;

    if (selectedWeightUnit == 'Pounds') {
      double pounds = double.tryParse(_poundsController.text) ?? 0.0;

      // Convert feet and inches to centimeters (you may want to use a more accurate conversion factor)
      weightValue = pounds * 2.24;
    } else if (selectedHeightUnit == 'Kilograms') {
      weightValue = double.tryParse(_kilogramsController.text);
    }

    if (weightValue != null) {
      print('Selected Weight: $weightValue kg');
    }
  }

  void _weightUnitPopUp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 90),
            title: const Center(child: Text('Select Weight')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: selectedWeightUnit,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedWeightUnit = newValue;
                          Navigator.of(context).pop();
                        });

                        _weightUnitPopUp();
                      },
                      items: <String>['Pounds', 'Kilograms']
                          .map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
                if (selectedWeightUnit == 'Pounds')
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 90,
                        child: TextFormField(
                          controller: _poundsController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                if (selectedWeightUnit == 'Kilograms')
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 90,
                        child: TextFormField(
                          controller: _kilogramsController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                IconButton(
                  onPressed: () {
                    _handleWeightSelection();
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  icon: const Icon(Icons.check, color: Colors.greenAccent),
                ),
              ],
            ),
          );
        });
  }

  void _showWeightUnitPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 90),
          title: const Center(
            child: Text('Select Weight'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: selectedWeightUnit,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedWeightUnit = newValue;
                        Navigator.of(context).pop();
                        _weightUnitPopUp();
                      });
                    },
                    items: <String>['Pounds', 'Kilograms']
                        .map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
              if (selectedWeightUnit == 'Pounds')
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: _poundsController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              if (selectedWeightUnit == 'Kilograms')
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: _kilogramsController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              IconButton(
                onPressed: () {
                  _handleWeightSelection();
                  Navigator.of(context).pop();
                  setState(() {});
                },
                icon: const Icon(Icons.check, color: Colors.greenAccent),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showGoalWeightPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 90),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selectedWeightUnit == 'Pounds')
                const Text('Pounds', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              if (selectedWeightUnit == 'Pounds')
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: _goalPoundsController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              if (selectedWeightUnit == 'Kilograms')
                const Text('Kilograms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              if (selectedWeightUnit == 'Kilograms')
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: _goalKilogramsController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
                icon: const Icon(Icons.check, color: Colors.greenAccent),
              ),
            ],
          ),
        );
      },
    );
  }

  // this method shows the AlertDialog that pops up when the user selects the Gender TextButton,
  // where they select one of the TextButtons to display their Gender.
  void _showGenderSelectionDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 110),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      selectedGender = 'Male';
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: Text('Male\t\t', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                  ),
                  const ColoredBox(color: Colors.greenAccent, child: SizedBox(height: 40, width: 1)),
                  TextButton(
                    onPressed: () {
                      selectedGender = 'Female';
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: Text('\t\tFemale', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                  ),
                ],
              ),
            ],
          );
        }
    );
  }

  // this method simply adds the day suffix to the Date of Birth Text.
  String numSuffix(int num) {

    if (num == 1 || num == 21 || num == 31) {return 'st';}
    else if (num == 2 || num == 22) {return 'nd';}
    else if (num == 3 || num == 23) {return 'rd';}
    else if ((num >= 4 && num <= 20) || (num >= 24 && num <= 30)) {return 'th';}
    return '';
  }

  // this method shows the Date of Birth AlertDialog which pops up when the user selects the Date of Birth TextButton,
  // where the user can select their month, day, and year of birth from dropdown menus.
  void _showDatePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 80),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('Month\t\t\t\t\t\t', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                  Text('Day\t\t\t\t\t\t\t\t\t\t\t', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                  Text('Year', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<int>(
                    value: selectedMonth,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedMonth = newValue!;
                        Navigator.of(context).pop();
                        _showDatePickerDialog();
                      });
                    },
                    items: List.generate(12, (index) => index + 1)
                        .map<DropdownMenuItem<int>>(
                          (int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      },
                    ).toList(),
                  ),
                  DropdownButton<int>(
                    value: selectedDay,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedDay = newValue!;
                        Navigator.of(context).pop();
                        _showDatePickerDialog();
                      });
                    },
                    items:
                    List.generate(31, (index) => index + 1)
                        .map<DropdownMenuItem<int>>(
                          (int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      },
                    ).toList(),
                  ),
                  DropdownButton<int>(
                    value: selectedYear,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedYear = newValue!;
                        Navigator.of(context).pop();
                        _showDatePickerDialog();
                      });
                    },
                    items: List.generate(100, (index) => DateTime.now().year - index)
                        .map<DropdownMenuItem<int>>(
                          (int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              IconButton(
                onPressed: () {
                  print('Selected Date of Birth: $selectedMonth/$selectedDay/$selectedYear');
                  Navigator.of(context).pop();
                  setState(() {});
                },
                icon: const Icon(Icons.check, color: Colors.greenAccent,),
              ),
            ],
          ),
        );
      },
    );
  }

  // this method simply turns the selected month int into it's String form
  String monthString(int num) {
    if (num == 1) {
      return 'January';
    } else if (num == 2) {
      return 'February';
    } else if (num == 3) {
      return 'March';
    } else if (num == 4) {
      return 'April';
    } else if (num == 5) {
      return 'May';
    } else if (num == 6) {
      return 'June';
    } else if (num == 7) {
      return 'July';
    } else if (num == 8) {
      return 'August';
    } else if (num == 9) {
      return 'September';
    } else if (num == 10) {
      return 'October';
    } else if (num == 11) {
      return 'November';
    } else if (num == 12) {
      return 'December';
    }
    return '';
  }

  int calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;

    // Check if the birthday has occurred this year
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }

    return age;
  }

  void calorieGoalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 90),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Calorie Goal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      controller: calorieGoalController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
                icon: const Icon(Icons.check, color: Colors.greenAccent),
              ),
            ],
          ),
        );
      },
    );
  }

  void stepsGoalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 90),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Step Count Goal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      controller: stepsGoalController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
                },
                icon: const Icon(Icons.check, color: Colors.greenAccent),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserDataSingleton userDataSingleton = UserDataSingleton();

    DateTime dateOfBirth = DateTime(selectedYear, selectedMonth, selectedDay);
    String age = "${calculateAge(dateOfBirth)}";
    String heightString;
    String weightString;
    String goalWeightString;
    int? calorieGoal = int.tryParse(calorieGoalController.text);
    int? stepsGoal = int.tryParse(stepsGoalController.text);
    ImageProvider profileImage = FileImage(File('lib/assets/logo.png'));

    ThemeMode currentThemeMode = ThemeManager().themeMode;

    selectedHeightUnit == 'Feet/Inches' ? heightString = "${_feetController.text} ft ${_inchesController.text} in" : heightString = "${_centimetersController.text} cm";
    selectedWeightUnit == 'Pounds' ? weightString = "${_poundsController.text} lbs" : weightString = "${_kilogramsController.text} kg";
    selectedWeightUnit == 'Pounds' ? goalWeightString = "${_goalPoundsController.text} lbs" : goalWeightString = "${_goalKilogramsController.text} kg";
    _image != null ? profileImage = FileImage(_image!) : profileImage = const AssetImage('lib/assets/logo.png');

    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Details',style: TextStyle(color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,),),
        backgroundColor: currentThemeMode == ThemeMode.dark ? Colors.black! : Colors.white,
        iconTheme: IconThemeData(
          color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
        ),        actions: [
          IconButton(
            onPressed: () {
              UserData updatedData = UserData(
                uid: userDataSingleton.userData?.uid ?? '',
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
                age: age,
                height: heightString,
                weight: weightString,
                gender: selectedGender.toString(),
                profilePhoto: profileImage,
                weightGoal: goalWeightString,
                calorieGoal: calorieGoal,
                stepsGoal: stepsGoal
              );

              userDataSingleton.setUserData(updatedData);

              Navigator.pop(context);
            },
            icon: const Icon(Icons.check, color: Colors.greenAccent),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    _showFirstNameDialog();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'First Name',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,),                      ),
                      Text(_firstNameController.text, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                    ],
                  ),
                ),
              ),
              const ColoredBox(color: Colors.greenAccent, child: SizedBox(height: 1, width: 400)),
              SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    _showLastNameDialog();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Last Name',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        ),                      ),
                      Text(_lastNameController.text, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                    ],
                  ),
                ),
              ),
              const ColoredBox(color: Colors.greenAccent, child: SizedBox(height: 1, width: 400)),
              SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    _showPFPSelectionDialog();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile Photo',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        ),                      ),
                      _image != null ?
                      CircleAvatar(
                        backgroundImage: FileImage(_image!),
                        radius: 15,
                      )
                          : const CircleAvatar(
                          backgroundImage: AssetImage('lib/assets/logo.png'),
                          backgroundColor: Colors.greenAccent,
                          radius: 15
                      ),
                    ],
                  ),
                ),
              ),
              const ColoredBox(color: Colors.greenAccent, child: SizedBox(height: 1, width: 400)),
              SizedBox(
                height: 50,
                child: TextButton(
                    onPressed: () {
                      _showHeightUnitPopUp();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Height',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                          ),                        ),
                        if (selectedHeightUnit == 'Feet/Inches')
                          Text(
                            "${_feetController.text} ft ${_inchesController.text} in",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                            ),                          )
                        else if (selectedHeightUnit == 'Centimeters')
                          Text(
                            "${_centimetersController.text} cm",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                            ),                          ),
                      ],
                    )
                ),
              ),
              const ColoredBox(color: Colors.greenAccent, child: SizedBox(height: 1, width: 400)),
              SizedBox(
                height: 50,
                child: TextButton(
                    onPressed: () {
                      _showWeightUnitPopUp();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Weight',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                          ),                        ),
                        if (selectedWeightUnit == 'Pounds')
                          Text(
                            "${_poundsController.text} lbs",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                            ),                          )
                        else if (selectedWeightUnit == 'Kilograms')
                          Text(
                            "${_kilogramsController.text} kg",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                            ),                          ),
                      ],
                    )
                ),
              ),
              const ColoredBox(color: Colors.greenAccent, child: SizedBox(height: 1, width: 400)),
              SizedBox(
                height: 50,
                child: TextButton(
                    onPressed: () {
                      _showGoalWeightPopUp();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Weight Goal',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                          ),                        ),
                        if (selectedWeightUnit == 'Pounds')
                          Text(
                            "${_goalPoundsController.text} lbs",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                            ),                          )
                        else if (selectedWeightUnit == 'Kilograms')
                          Text(
                            "${_goalKilogramsController.text} kg",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                            ),                          ),
                      ],
                    )
                ),
              ),
              const ColoredBox(color: Colors.greenAccent, child: SizedBox(height: 1, width: 400)),
              SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    _showGenderSelectionDialog();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text(
                        'Gender',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        ),                      ),
                      if (selectedGender != null)
                        Text(
                          selectedGender!,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                          ),                        )
                    ],
                  ),
                ),
              ),
              const ColoredBox(color: Colors.greenAccent, child: SizedBox(height: 1, width: 400)),
              SizedBox(
                height: 50,
                child: TextButton(
                    onPressed: () {
                      _showDatePickerDialog();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date of Birth',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                          ),                        ),
                        Text('${monthString(selectedMonth)} $selectedDay${numSuffix(selectedDay)}, $selectedYear', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        )),
                      ],
                    )
                ),
              ),
              const ColoredBox(color: Colors.greenAccent, child: SizedBox(height: 1, width: 400)),
              SizedBox(
                height: 50,
                child: TextButton(
                    onPressed: () {
                      calorieGoalDialog();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Calorie Goal',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                          ),                        ),
                        Text(calorieGoalController.text, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                      ],
                    )
                ),
              ),
              const ColoredBox(color: Colors.greenAccent, child: SizedBox(height: 1, width: 400)),
              SizedBox(
                height: 50,
                child: TextButton(
                    onPressed: () {
                      stepsGoalDialog();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Steps Goal',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: currentThemeMode == ThemeMode.dark ? Colors.white : Colors.black,
                          ),                        ),
                        Text(stepsGoalController.text, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                      ],
                    )
                ),
              ),
              const ColoredBox(color: Colors.greenAccent, child: SizedBox(height: 1, width: 400)),
            ],
          ),
        ),
      ),
      backgroundColor: currentThemeMode == ThemeMode.dark ? Colors.grey[900] : null,
    );
  }
}