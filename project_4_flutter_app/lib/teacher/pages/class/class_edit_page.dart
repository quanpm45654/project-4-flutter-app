import 'package:flutter/material.dart';

import '../../models/class.dart';
import '../../widgets/class/class_edit_widget.dart';

class ClassEditPage extends StatelessWidget {
  const ClassEditPage({super.key, required this.classObject});

  final Class classObject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit class'),
      ),
      body: SafeArea(
        child: ClassEditWidget(classObject: classObject),
      ),
    );
  }
}
