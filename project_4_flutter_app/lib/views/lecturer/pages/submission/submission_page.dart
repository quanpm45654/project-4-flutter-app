import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/submission/submission_widget.dart';

class SubmissionPage extends StatelessWidget {
  const SubmissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submission detail'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(CustomSize.medium),
          child: const SubmissionWidget(),
        ),
      ),
    );
  }
}
