import 'package:flutter/material.dart';
import 'package:contacts_buddy/db_helper/database_handler.dart';
import 'package:contacts_buddy/model/contact.dart';
import 'package:contacts_buddy/utils/main_body.dart';
import 'package:contacts_buddy/screens/add_contact/add_contact.dart';
import 'package:contacts_buddy/screens/edit_contact/edit_contact.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late DatabaseHandler handler;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return MainBody(
        appBarColor: Colors.white,
        titleTextColor: Colors.grey.shade800,
        title: 'Contacts Buddy',
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            child: Stack(
              children: [
                TextFormField(
                  controller: searchController,
                  decoration: const InputDecoration(
                      hintText: 'Search',
                      filled: true,
                      fillColor: Color.fromARGB(255, 225, 225, 225),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.all(Radius.circular(35.0))),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black54,
                      )),
                  onChanged: (value) {
                    setState(() {
                      // Perform search when the text changes
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 75),
                  child: FutureBuilder(
                    future: handler.retrieveContact(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Contact>> snapshot) {
                      if (snapshot.hasData) {
                        List<Contact> filteredContacts =
                            _filterContacts(snapshot.data ?? []);
                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 12.0),
                          shrinkWrap: true,
                          itemCount: filteredContacts.length,
                          itemBuilder: (BuildContext context, int index) {
                            Contact contact = filteredContacts[index];
                            return Card(
                              color: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 0.5), // Add a red bottom border
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: w,
                                    height: 80.0,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 80.0,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 213, 219, 255),
                                                radius: 30.0,
                                                child: Text(contact.name[0]),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("${contact.name} ",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  )),
                                              Text(
                                                  "${contact.phoneNum.toInt()}"),
                                              Text("${contact.email}"),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: IconButton(
                                                      color: Colors.green,
                                                      onPressed: () async {
                                                        bool? res = await FlutterPhoneDirectCaller.callNumber("${contact.phoneNum.toInt()}");
                                                      },
                                                      icon: const Icon(
                                                          Icons.call),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: IconButton(
                                                      color:
                                                          Colors.indigoAccent,
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => EditContact(contactId: contact.id!),
                                                          ),
                                                        );
                                                      },
                                                      icon: const Icon(
                                                          Icons.edit),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: IconButton(
                                                      color: Colors.red,
                                                      onPressed: () {
                                                        handler.deleteContact(
                                                            contact.id!);
                                                        setState(() {
                                                          filteredContacts
                                                              .removeAt(index);
                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigoAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                30.0), // Adjust the border radius as needed
          ),
          child: const Icon(
            Icons.person_add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddContact()),
            );
          },
        ));
  }

  List<Contact> _filterContacts(List<Contact> contacts) {
    String keyword = searchController.text.toLowerCase();
    if (keyword.isEmpty) {
      return contacts;
    }

    return contacts
        .where((contact) =>
            contact.name.toLowerCase().contains(keyword) ||
            contact.phoneNum.toString().contains(keyword) ||
            (contact.email != null &&
                contact.email!.toLowerCase().contains(keyword)))
        .toList();
  }
}
