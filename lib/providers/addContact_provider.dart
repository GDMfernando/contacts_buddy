import 'package:flutter/material.dart';

class AddContactProvider extends ChangeNotifier{
  TextEditingController nameController = TextEditingController();
  TextEditingController get getnameController => nameController;

  TextEditingController phoneNumController = TextEditingController();
  TextEditingController get getphoneNumController => phoneNumController;

  TextEditingController emailController = TextEditingController();
  TextEditingController get getemailController => emailController;

  Future<void> clearData(context) async {
    nameController.clear();
    phoneNumController.clear();
    emailController.clear();
  }
}