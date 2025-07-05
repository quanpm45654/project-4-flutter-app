import 'package:flutter/material.dart';

import '../../widgets/class/class_create_widget.dart';

class ClassCreatePage extends StatelessWidget {
  const ClassCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Create class'),
      ),
      body: const SafeArea(
        child: ClassCreateWidget(),
      ),
    );
  }
}
