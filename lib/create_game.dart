import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:pickup/models/game.dart';
import 'package:pickup/services/game_service.dart';
import 'package:pickup/services/log.dart';

class CreateGame extends StatefulWidget {
  final DateTime date;
  const CreateGame({super.key, required this.date});

  @override
  _CreateGameState createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  final _formKey = GlobalKey<FormBuilderState>();
  // late GameInfo _gameInfo;

  var needPermission = false;

  @override
  void initState() {
    super.initState();
    // _gameInfo = GameInfo(
    //   date: DateTime.now(),
    //   time: TimeOfDay.now(),
    //   location: '',
    // );
    // listenToMessages('chatId'); here.
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Center(
              child: Column(
                children: <Widget>[
                  FormBuilderDateTimePicker(
                    name: 'date',
                    initialEntryMode: DatePickerEntryMode.calendar,
                    initialValue: widget.date,
                    fieldHintText: 'Add Date',
                    inputType: InputType.date,
                    format: DateFormat('MM-dd-yyyy'),
                    decoration: const InputDecoration(
                      labelText: 'Date',
                    ),
                  ),
                  FormBuilderDateTimePicker(
                    name: 'time',
                    initialValue: DateTime.now(),
                    fieldHintText: 'Add Time',
                    inputType: InputType.time,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                    ),
                  ),
                  FormBuilderTextField(
                    name: 'location',
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                  // Add more fields here for max players, min rating, announcements, and image upload
                  // For example, for max players:
                  // Use FormBuilderDropdown or FormBuilderChoiceChip for min rating
                  // Use FormBuilderImagePicker for image upload
                  // ... rest of the form fields ...

                  // Advanced settings using ExpansionTile
                  ExpansionTile(
                    title: const Text("Advanced Settings"),
                    leading: const Icon(Icons.settings),
                    children: <Widget>[
                      FormBuilderTextField(
                        name: 'maxPlayers',
                        decoration: const InputDecoration(
                          labelText: 'Max Players',
                          border: OutlineInputBorder(),
                          hintText: 'Enter max number of players',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      FormBuilderSlider(
                        name: 'minRating',
                        decoration: const InputDecoration(labelText: 'Min Rating'),
                        min: 0.0,
                        max: 5.0,
                        initialValue: 0.0,
                        divisions: 10,
                        activeColor: Colors.amber,
                        inactiveColor: Colors.amber.withOpacity(0.2),
                      ),
                      FormBuilderTextField(
                        name: 'announcement',
                        decoration: const InputDecoration(
                          labelText: 'Announcements',
                          border: OutlineInputBorder(),
                          hintText: 'Enter any announcements',
                        ),
                        maxLines: 3,
                      ),
                      FormBuilderSwitch(
                        name: 'reqPermissions',
                        title: const Text('Request Permission'),
                        initialValue: needPermission,
                        onChanged: (bool? newValue) {
                          setState(() {
                            needPermission = newValue!;
                          });
                        },
                      ),
                      FormBuilderImagePicker(
                        name: 'gamePic',
                        decoration: const InputDecoration(
                          labelText: 'Image',
                        ),
                        maxImages: 1,
                        // validator: FormBuilderValidators.required(
                        //     errorText: "This field is required"),
                        previewHeight: 100.0, // height of the preview image
                        previewWidth: 100.0, // width of the preview image
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.saveAndValidate()) {
      // This will save the form and validate the inputs
      Map<String, dynamic> modifiableGameData = Map<String, dynamic>.from(_formKey.currentState!.value);
      Log.info(modifiableGameData);
      // Game game = Game.fromJson(_formKey.currentState!.value); //Won't work; fields missing.
      // Log.info(game);
      try {
        await Get.find<GameService>().createGame(modifiableGameData);
        Get.back();
        Get.snackbar(
        "Success!",
        "Your PickUp time has been posted.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
        // Log.info('Game created successfully');
        // Get.snackbar("Success!", "Your PickUP time has been posted.", backgroundColor: Colors.green, colorText: Colors.white, duration: const Duration(seconds: 1), );
      } catch (e) {
        Log.error('Failed to create game:', e);
      }
    } else {
      Log.error('Form not valid', "Couldn't create game.");
    }
  }
}
