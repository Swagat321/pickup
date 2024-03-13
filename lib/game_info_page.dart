import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class GameInfoPage extends StatefulWidget {
  const GameInfoPage({super.key});

  @override
  _GameInfoPageState createState() => _GameInfoPageState();
}

class _GameInfoPageState extends State<GameInfoPage> {
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
                    initialValue: DateTime.now(),
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
                        name: 'max_players',
                        decoration: const InputDecoration(
                          labelText: 'Max Players',
                          border: OutlineInputBorder(),
                          hintText: 'Enter max number of players',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      FormBuilderSlider(
                        name: 'min_rating',
                        decoration: const InputDecoration(labelText: 'Min Rating'),
                        min: 0.0,
                        max: 5.0,
                        initialValue: 0.0,
                        divisions: 10,
                        activeColor: Colors.amber,
                        inactiveColor: Colors.amber.withOpacity(0.2),
                      ),
                      FormBuilderTextField(
                        name: 'announcements',
                        decoration: const InputDecoration(
                          labelText: 'Announcements',
                          border: OutlineInputBorder(),
                          hintText: 'Enter any announcements',
                        ),
                        maxLines: 3,
                      ),
                      FormBuilderSwitch(
                        name: 'permissions',
                        title: const Text('Request Permission'),
                        initialValue: needPermission,
                        onChanged: (bool? newValue) {
                          setState(() {
                            needPermission = newValue!;
                          });
                        },
                      ),
                      FormBuilderImagePicker(
                        name: 'image',
                        decoration: const InputDecoration(
                          labelText: 'Image',
                        ),
                        maxImages: 1,
                        validator: FormBuilderValidators.required(
                            errorText: "This field is required"),
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

  void _submitForm() {
    if (_formKey.currentState!.saveAndValidate()) {
      // This will save the form and validate the inputs
      print(_formKey.currentState!.value);

      // Here you can map the form values to your GameInfo model
      // And then use this data as needed in your application
    } else {
      print('Form not valid');
    }
  }
}
