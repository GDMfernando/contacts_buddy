import 'package:contacts_buddy/utils/main_body.dart';
import 'package:flutter/material.dart';
import 'package:contacts_buddy/db_helper/database_handler.dart';
import 'package:contacts_buddy/model/contact.dart';
import 'package:contacts_buddy/screens/contacts_list/contacts_list.dart';
import 'package:contacts_buddy/providers/addContact_provider.dart';
import 'package:provider/provider.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  late DatabaseHandler handler;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddContactProvider>(context, listen: false)
          .clearData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainBody(
        title: 'Contacts Buddy',
        appBarColor: Colors.white,
        titleTextColor: Colors.grey.shade800,
        body: Consumer<AddContactProvider>(
            builder: (context, addContactProvider, child) {
          return SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Form (key: formKey,
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
                        controller: addContactProvider.nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigoAccent)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: addContactProvider.phoneNumController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigoAccent)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: addContactProvider.emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.indigoAccent)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null; // Email is optional
                            } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          }
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60.0,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              handler.initializeDB().whenComplete(() async {
                                Contact secondContact = Contact(
                                    name: addContactProvider.nameController
                                        .text,
                                    phoneNum: int.parse(
                                        addContactProvider.phoneNumController
                                            .text),
                                    email: addContactProvider.emailController
                                        .text);

                                List<Contact> listOfUsers = [secondContact];
                                handler.insertContact(listOfUsers);
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ContactList()),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text(
                            "SAVE",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                )


                ),
          );
        }));
  }
}
