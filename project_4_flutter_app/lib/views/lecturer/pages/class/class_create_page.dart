import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/class/class_create_widget.dart';

class ClassCreatePage extends StatelessWidget {
  const ClassCreatePage({super.key});

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
          child: const ClassCreateWidget(),
        ),
      ),
    );
  }
}
