import 'package:flutter/material.dart';

class MainBody extends StatefulWidget {
  const MainBody({
    super.key,
    required this.title,
    required this.body,
    this.appBarColor,
    this.titleTextColor,
    this.backGroundColor,
    this.centerTitle,
    this.drawer,
    this.autoLeadingIcon = true,
    this.floatingActionButton,
  });
  final String title;
  final Color? appBarColor;
  final Color? titleTextColor;
  final Widget body;
  final Color? backGroundColor;
  final Widget? centerTitle;
  final Widget? drawer;
  final bool autoLeadingIcon;
  final Widget? floatingActionButton;
  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.drawer,
      floatingActionButton: widget.floatingActionButton,
      appBar: AppBar(
        automaticallyImplyLeading: widget.autoLeadingIcon,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: widget.titleTextColor ?? Colors.white,
        ),
        leading: widget.centerTitle,
        backgroundColor: widget.appBarColor ?? Colors.blue,
        title: Text(
          widget.title,
        ),
      ),
      backgroundColor:
      widget.backGroundColor ?? const Color.fromARGB(255, 255, 255, 255),
      body: widget.body,
    );
  }
}