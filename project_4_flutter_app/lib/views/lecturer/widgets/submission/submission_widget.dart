import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/submission.dart';
import 'package:project_4_flutter_app/repositories/submission_repository.dart';
import 'package:project_4_flutter_app/utils/functions.dart';
import 'package:project_4_flutter_app/utils/validator.dart';
import 'package:provider/provider.dart';

class SubmissionWidget extends StatefulWidget {
  const SubmissionWidget({super.key, required this.submission});

  final Submission submission;

  @override
  State<SubmissionWidget> createState() => _SubmissionWidgetState();
}

class _SubmissionWidgetState extends State<SubmissionWidget> {
  final _formKey = GlobalKey<FormState>();
  final _submissionGrade = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var submissionRepository = Provider.of<SubmissionRepository>(context);

    return submissionRepository.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: buildColumn(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: Column(
                  children: [
                    buildForm(),
                    const SizedBox(height: 16.0),
                    buildSubmitButton(submissionRepository, context),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.maxFinite,
                      height: 48.0,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Column buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.submission.student_name}',
          style: const TextStyle(fontSize: 24.0),
        ),
        Text('Submitted at ${CustomFormatter.formatDateTime(widget.submission.submitted_at)}'),
        Text('${widget.submission.score} point'),
        Text('${widget.submission.note}'),
        Text(
          'Attachment',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(widget.submission.file_url),
        Text(
          'Feedback',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(widget.submission.feedback_text ?? ''),
        Text(widget.submission.feedback_file_url ?? ''),
        Text(
          'Comment',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _submissionGrade,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text('Grade*'),
        ),
        validator: (value) => CustomValidator.combine([
          CustomValidator.number(value),
        ]),
      ),
    );
  }

  SizedBox buildSubmitButton(SubmissionRepository submissionRepository, BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 48.0,
      child: FilledButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final submission = Submission(
              submission_id: 0,
              assignment_id: 0,
              student_id: 0,
              attempt: 0,
              submitted_at: DateTime.now(),
              file_url: '',
              score: num.parse(_submissionGrade.text),
              graded_by: 2,
            );

            await submissionRepository.gradeSubmission(submission: submission);

            if (context.mounted) {
              if (submissionRepository.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Submission graded successfully'),
                    showCloseIcon: true,
                  ),
                );
                Navigator.pop(context);
              } else if (submissionRepository.errorMessageSnackBar.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(submissionRepository.errorMessageSnackBar),
                    showCloseIcon: true,
                  ),
                );
                Navigator.pop(context);
              }
            }
          }
        },
        child: const Text('Return grade'),
      ),
    );
  }
}
