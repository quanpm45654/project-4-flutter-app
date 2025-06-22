import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/views/lecturer/widgets/submission/submission_list_widget.dart';

class SubmissionListPage extends StatelessWidget {
  const SubmissionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment name'),
      ),
      body: const SafeArea(
        child: SubmissionListWidget(),
      ),
    );
  }
}
