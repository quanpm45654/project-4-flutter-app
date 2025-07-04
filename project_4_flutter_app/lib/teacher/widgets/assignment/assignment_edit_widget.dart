import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/teacher/models/assignment.dart';
import 'package:project_4_flutter_app/teacher/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/teacher/utils/functions.dart';
import 'package:project_4_flutter_app/teacher/utils/validator.dart';
import 'package:provider/provider.dart';

class AssignmentEditWidget extends StatefulWidget {
  const AssignmentEditWidget({super.key, required this.assignment});

  final Assignment assignment;

  @override
  State<AssignmentEditWidget> createState() => _AssignmentEditWidgetState();
}

class _AssignmentEditWidgetState extends State<AssignmentEditWidget> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _attachment = TextEditingController();
  final _dueDate = TextEditingController();
  bool _allowResubmit = false;

  @override
  void initState() {
    super.initState();
    _title.text = widget.assignment.title ?? '';
    _description.text = widget.assignment.description ?? '';
    _attachment.text = widget.assignment.attached_file ?? '';
    _dueDate.text = CustomFormatter.formatDateTime(widget.assignment.due_date) ?? '';
    _allowResubmit = widget.assignment.allow_resubmit;
  }

  Future<void> editAssignment(
    AssignmentRepository assignmentRepository,
    BuildContext context,
  ) async {
    int id = widget.assignment.id;
    int class_id = widget.assignment.class_id;
    String title = _title.text;
    String description = _description.text;
    String attachment = _attachment.text;
    DateTime due_date = DateTime.parse(_dueDate.text);
    bool allow_resubmit = _allowResubmit;
    Assignment inputAssignment = Assignment(
      id,
      class_id,
      title,
      description,
      attachment,
      due_date,
      allow_resubmit,
    );

    await assignmentRepository.updateAssignment(inputAssignment);

    if (context.mounted) {
      if (assignmentRepository.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Assignment edited successfully'),
            showCloseIcon: true,
          ),
        );
        Navigator.pop(context);
      } else if (assignmentRepository.errorMessageSnackBar.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(assignmentRepository.errorMessageSnackBar),
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

    return assignmentRepository.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16.0,
                        children: [
                          const SizedBox(),
                          TextFormField(
                            controller: _title,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Assignment title*'),
                            ),
                            validator: (value) => CustomValidator.combine([
                              CustomValidator.required(value, 'Assignment title'),
                              CustomValidator.maxLength(value, 255),
                            ]),
                          ),
                          TextFormField(
                            controller: _description,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Description*'),
                            ),
                            validator: (value) => CustomValidator.combine([
                              CustomValidator.required(value, 'Description'),
                            ]),
                          ),
                          TextFormField(
                            controller: _attachment,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Attachment*'),
                              suffixIcon: Icon(Icons.link_rounded),
                            ),
                            validator: (value) => CustomValidator.combine([
                              CustomValidator.required(value, 'Attachment'),
                            ]),
                          ),
                          TextFormField(
                            controller: _dueDate,
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Due date*'),
                              suffixIcon: Icon(Icons.calendar_month_rounded),
                            ),
                            onTap: () async {
                              DateTime? dateTime = await showDateTimePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 10),
                              );
                              _dueDate.text = CustomFormatter.formatDateTime(dateTime) ?? '';
                            },
                            validator: (value) => CustomValidator.combine([
                              CustomValidator.required(value, 'Due date'),
                            ]),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Checkbox(
                              value: _allowResubmit,
                              onChanged: (value) => setState(() => _allowResubmit = value ?? false),
                            ),
                            title: const Text('Allow resubmit'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.surfaceContainer,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 16.0,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: FilledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            editAssignment(assignmentRepository, context);
                          }
                        },
                        child: const Text('Edit assignment'),
                      ),
                    ),
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
