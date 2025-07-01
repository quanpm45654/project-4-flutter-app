import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/submission.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/repositories/submission_repository.dart';
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
  final _submissionFeedback = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var submissionRepository = Provider.of<SubmissionRepository>(context);
    var assignmentRepository = Provider.of<AssignmentRepository>(context);

    return submissionRepository.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: buildColumn(assignmentRepository),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: Column(
                  children: [
                    buildForm(assignmentRepository),
                    const SizedBox(height: 16.0),
                    buildSubmitButton(submissionRepository, context),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.maxFinite,
                      height: 48.0,
                      child: buildCancelButton(context),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Column buildColumn(AssignmentRepository assignmentRepository) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            '${widget.submission.student_name}',
            style: const TextStyle(fontSize: 20.0),
          ),
          subtitle:
              widget.submission.submitted_at.isAfter(
                assignmentRepository.assignmentList
                    .firstWhere(
                      (a) => a.assignment_id == widget.submission.assignment_id,
                    )
                    .due_at,
              )
              ? Text(
                  'Done late',
                  style: TextStyle(
                    color: Colors.red.shade900,
                  ),
                )
              : Text(
                  'Turned in',
                  style: TextStyle(color: Colors.green.shade900),
                ),
          trailing: Text(
            '${widget.submission.score}/${assignmentRepository.assignmentList.firstWhere(
              (a) => a.assignment_id == widget.submission.assignment_id,
            ).max_score}',
            style: TextStyle(color: Colors.green.shade900, fontSize: 20.0),
          ),
        ),
        Text(
          'Note',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text('${widget.submission.note}'),
        const SizedBox(height: 8.0),
        Text(
          'Attachment',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SelectableText(widget.submission.file_url),
        const SizedBox(height: 8.0),
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
        const SizedBox(height: 8.0),
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

  Form buildForm(AssignmentRepository assignmentRepository) {
    var maxScore = assignmentRepository.assignmentList
        .firstWhere((a) => a.assignment_id == widget.submission.assignment_id)
        .max_score;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildGradeField(maxScore),
          const SizedBox(height: 16),
          buildFeedbackField(),
        ],
      ),
    );
  }

  TextFormField buildGradeField(double maxScore) {
    return TextFormField(
      controller: _submissionGrade,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        label: const Text('Grade*'),
        suffixText: '/$maxScore',
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value, 'Grade'),
        CustomValidator.number(value),
        CustomValidator.minValue(value, 0),
        CustomValidator.maxValue(value, maxScore),
      ]),
    );
  }

  TextFormField buildFeedbackField() {
    return TextFormField(
      controller: _submissionFeedback,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        label: Text('Feedback'),
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.maxLength(value, 255),
      ]),
    );
  }

  SizedBox buildSubmitButton(
    SubmissionRepository submissionRepository,
    BuildContext context,
  ) {
    return SizedBox(
      width: double.maxFinite,
      height: 48.0,
      child: FilledButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var submission = Submission.empty();
            submission.submission_id = widget.submission.submission_id;
            submission.score = double.parse(_submissionGrade.text);
            submission.feedback_text = _submissionFeedback.text;
            submission.graded_by = 2;

            await submissionRepository.gradeSubmission(submission);

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

  TextButton buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Cancel'),
    );
  }
}
