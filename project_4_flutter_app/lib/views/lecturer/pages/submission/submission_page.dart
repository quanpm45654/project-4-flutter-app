import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/submission/submission_widget.dart';

class SubmissionPage extends StatelessWidget {
  const SubmissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submission detail'),
      ),
      body: const SafeArea(
        child: SubmissionWidget(),
      ),
    );
  }
}
