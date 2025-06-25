import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/class/class_create_edit_widget.dart';

class ClassCreateEditPage extends StatelessWidget {
  const ClassCreateEditPage({super.key, required this.title, this.classObject});

  final String title;
  final Class? classObject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(
            CustomSize.medium,
          ),
          child: ClassCreateEditWidget(
            title: title,
            classObject: classObject,
          ),
        ),
      ),
    );
  }
}
