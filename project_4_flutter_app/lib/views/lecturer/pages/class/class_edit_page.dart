import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/class/class_edit_widget.dart';

class ClassEditPage extends StatelessWidget {
  const ClassEditPage({super.key, required this.classObject});

  final Class classObject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Create class'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: ClassEditWidget(classObject: classObject),
        ),
      ),
    );
  }
}
