import 'package:flutter/material.dart';
import 'package:contacts_buddy/db_helper/database_handler.dart';
import 'package:contacts_buddy/utils/main_body.dart';
import 'package:contacts_buddy/model/contact.dart';
import 'package:contacts_buddy/providers/editContact_provider.dart';

class EditContact extends StatefulWidget {
  final int contactId;
  const EditContact({Key? key, required this.contactId}) : super(key: key);


  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  late DatabaseHandler handler;
  late Contact originalContact;
  final formKey = GlobalKey<FormState>();
  late EditContactProvider provider;

  @override
  void initState() {
    super.initState();
    provider = EditContactProvider();
    handler = DatabaseHandler();
    fetchContactData();
  }

  void fetchContactData() async {
    try {
      List<Contact> contacts = await handler.retrieveContact();
      Contact contact = contacts.firstWhere((c) => c.id == widget.contactId);
      setState(() {
        originalContact = contact;
        provider.nameController.text = contact.name;
        provider.phoneNumController.text = contact.phoneNum.toString();
        provider.emailController.text = contact.email ?? "";
      });
    } catch (e) {
      print('Error fetching contact data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return MainBody(title: 'Contacts Buddy',
        appBarColor: Colors.white,
        titleTextColor: Colors.grey.shade800,
        body:
        SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.only(
              left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 250.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 250.0,
                        // Adjust the size according to your needs
                        color: Color.fromARGB(255, 213, 219, 255),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: provider.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigoAccent)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: provider.phoneNumController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigoAccent)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: provider.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigoAccent)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: ElevatedButton(onPressed: () {
                    Contact updatedContact = Contact(
                      id: originalContact.id,
                      name: provider.getnameController.text,
                      phoneNum: int.parse(provider.getphoneNumController.text),
                      email: provider.getemailController.text.isNotEmpty ? provider.getemailController.text : null,
                    );

                    handler.updateContact(updatedContact).then((result) {
                      Navigator.pop(context);
                    });

                  },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text("SAVE",
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            ),
          ),
        )

    );
  }
}
