import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/submission/submission_list_widget.dart';

class SubmissionListPage extends StatelessWidget {
  const SubmissionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment 1'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(CustomSize.medium),
          child: const SubmissionListWidget(),
        ),
      ),
    );
  }
}
