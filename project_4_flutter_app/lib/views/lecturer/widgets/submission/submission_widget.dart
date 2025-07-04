import 'package:flutter/material.dart' hide Feedback;
import 'package:project_4_flutter_app/models/feedback.dart';
import 'package:project_4_flutter_app/models/submission.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/repositories/feedback_repository.dart';
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

  Future<void> sendFeedback(
    SubmissionRepository submissionRepository,
    FeedbackRepository feedbackRepository,
    BuildContext context,
  ) async {
    int id = widget.submission.feedback_id ?? 0;
    int submission_id = widget.submission.submission_id!;
    double score = double.parse(_submissionGrade.text);
    String comment = _submissionFeedback.text;
    Feedback feedback = Feedback(id, submission_id, score, comment);

    await feedbackRepository.sendFeedback(feedback);
    await submissionRepository.fetchSubmissionList(widget.submission.assignment_id ?? 0);

    if (context.mounted) {
      if (feedbackRepository.isSuccess && submissionRepository.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Submission graded successfully'),
            showCloseIcon: true,
          ),
        );
        Navigator.pop(context);
      } else if (feedbackRepository.errorMessageSnackBar.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(feedbackRepository.errorMessageSnackBar),
            showCloseIcon: true,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignmentRepository = Provider.of<AssignmentRepository>(context);
    final submissionRepository = Provider.of<SubmissionRepository>(context);
    final feedbackRepository = Provider.of<FeedbackRepository>(context);

    return feedbackRepository.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          '${widget.submission.student_name}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        subtitle:
                            widget.submission.submitted_at!.isAfter(
                              assignmentRepository.assignmentList
                                  .firstWhere(
                                    (a) => a.id == widget.submission.assignment_id,
                                  )
                                  .due_date,
                            )
                            ? Text(
                                'Done late',
                                style: TextStyle(
                                  color: Colors.red.shade900,
                                ),
                              )
                            : Text(
                                'Submitted',
                                style: TextStyle(color: Colors.green.shade900),
                              ),
                        trailing: Text(
                          widget.submission.score != null
                              ? '${widget.submission.score}/10'
                              : 'Not graded',
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      const Divider(),
                      Text(
                        'Note',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text('${widget.submission.note}'),
                      const SizedBox(height: 8.0),
                      Text(
                        'Attachment',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SelectableText(widget.submission.file_path ?? ''),
                      const SizedBox(height: 8.0),
                      Text(
                        'Feedback',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(widget.submission.comment ?? ''),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _submissionGrade,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Grade*'),
                              suffixText: '/10',
                            ),
                            validator: (value) => CustomValidator.combine([
                              CustomValidator.required(value, 'Grade'),
                              CustomValidator.number(value),
                              CustomValidator.minValue(value, 0),
                              CustomValidator.maxValue(value, 10),
                            ]),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _submissionFeedback,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Feedback'),
                            ),
                            validator: (value) => CustomValidator.combine([
                              CustomValidator.maxLength(value, 255),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.maxFinite,
                      child: FilledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            sendFeedback(submissionRepository, feedbackRepository, context);
                          }
                        },
                        child: const Text('Send feedback'),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.maxFinite,
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
}
