import 'package:flutter/material.dart';

class EditContactProvider extends ChangeNotifier{
  TextEditingController nameController = TextEditingController();
  TextEditingController get getnameController => nameController;

  TextEditingController phoneNumController = TextEditingController();
  TextEditingController get getphoneNumController => phoneNumController;

  TextEditingController emailController = TextEditingController();
  TextEditingController get getemailController => emailController;
}
