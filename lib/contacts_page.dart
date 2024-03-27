import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:pickup/services/log.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _updateContacts();
  }

  void _updateContacts({String query = ''}) async {
    final contacts = await ContactsService.getContacts(query: query);
    setState(() {
      _contacts = contacts.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                // setState(() {
                //   _searchTerm = value;
                // });
                _updateContacts(
                    query:
                        value); // resets state twice; could be more efficient/less complicated.
              },
              decoration: const InputDecoration(
                labelText: 'Search Contacts',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                Contact contact = _contacts[index];
                return ListTile(
                  title: Text(contact.displayName ?? "No name"),
                  onTap: () {
                    // Perform your action on tap here
                    // For example, navigate to a contact detail page or display a modal
                    try{
                    Log.info('Tapped on ${contact.displayName}');
                    if (contact.phones?.isNotEmpty ?? false) {
                      _sendMessage("Your message here", [contact.phones!.first.value!]);
                    } else {
                      Log.debug("No phone number available");
                    }
                    } catch (e) {
                      Log.error("Failed to send SMS.", e);
                      Get.snackbar("Failed to send SMS", "Please try again later.");
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message, List<String> recipients) async {
    String result = await sendSMS(message: message, recipients: recipients)
        .catchError((onError) {
      Log.error("Failed to send SMS.", onError);
    });
    Log.info(result);
  }
}
