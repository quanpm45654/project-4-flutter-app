import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/utils/enums.dart';
import 'package:project_4_flutter_app/utils/functions.dart';
import 'package:project_4_flutter_app/utils/validator.dart';

class AssignmentCreateEditWidget extends StatefulWidget {
  const AssignmentCreateEditWidget({super.key, required this.title, this.assignment});

  final String title;
  final Assignment? assignment;

  @override
  State<AssignmentCreateEditWidget> createState() => _AssignmentCreateEditWidgetState();
}

class _AssignmentCreateEditWidgetState extends State<AssignmentCreateEditWidget> {
  final _assignmentRepository = AssignmentRepository();
  final _formKey = GlobalKey<FormState>();
  final _assignmentTitleController = TextEditingController();
  final _assignmentDescriptionController = TextEditingController();
  final _assignmentDueAtController = TextEditingController();
  final _assignmentMaxScoreController = TextEditingController();
  AssignmentType _assignmentType = AssignmentType.individual;
  bool _assignmentTimeBound = false;
  bool _assignmentAllowResubmit = false;
  final _assignmentClassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final assignment = widget.assignment;
    if (assignment != null) {
      _assignmentTitleController.text = assignment.title;
      _assignmentDescriptionController.text = assignment.description;
      _assignmentDueAtController.text = CustomFormatter.formatDateTime2(assignment.due_at);
      _assignmentMaxScoreController.text = assignment.max_score.toString();
      _assignmentType = assignment.assignment_type;
      _assignmentTimeBound = assignment.time_bound;
      _assignmentAllowResubmit = assignment.allow_resubmit;
      _assignmentClassController.text = assignment.class_name ?? '';
    }

    return Column(
      spacing: CustomSize.extraLarge,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: CustomSize.medium,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _assignmentTitleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            CustomSize.medium,
                          ),
                        ),
                      ),
                      label: Text(
                        'Assignment title*',
                      ),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(
                          value,
                          'Assignment title',
                        ),
                      ]);
                    },
                  ),
                  TextFormField(
                    controller: _assignmentDescriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            CustomSize.medium,
                          ),
                        ),
                      ),
                      label: Text(
                        'Description*',
                      ),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(
                          value,
                          'Description',
                        ),
                      ]);
                    },
                  ),
                  TextFormField(
                    controller: _assignmentDueAtController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            CustomSize.medium,
                          ),
                        ),
                      ),
                      label: Text(
                        'Due at*',
                      ),
                      suffixIcon: Icon(
                        Icons.calendar_month_rounded,
                      ),
                    ),
                    onTap: () async {
                      DateTime? date = await showDateTimePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 10),
                      );

                      date != null
                          ? _assignmentDueAtController.text = CustomFormatter.formatDateTime2(
                              date,
                            )
                          : _assignmentDueAtController.text = '';
                    },
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(
                          value,
                          'Due at',
                        ),
                      ]);
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _assignmentMaxScoreController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            CustomSize.medium,
                          ),
                        ),
                      ),
                      label: Text(
                        'Max score*',
                      ),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(
                          value,
                          'Max score',
                        ),
                      ]);
                    },
                  ),
                  DropdownButtonFormField(
                    items: AssignmentType.values.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value.name,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _assignmentType = value ?? AssignmentType.individual;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            CustomSize.medium,
                          ),
                        ),
                      ),
                      label: Text(
                        'Type*',
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _assignmentTimeBound,
                        onChanged: (value) {
                          setState(() {
                            _assignmentTimeBound = value ?? false;
                          });
                        },
                      ),
                      Text(
                        'Time bound',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _assignmentAllowResubmit,
                        onChanged: (value) {
                          setState(() {
                            _assignmentAllowResubmit = value ?? false;
                          });
                        },
                      ),
                      Text(
                        'Allow resubmit',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _assignmentClassController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            CustomSize.medium,
                          ),
                        ),
                      ),
                      label: Text(
                        'Class*',
                      ),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(
                          value,
                          'Class',
                        ),
                      ]);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          spacing: CustomSize.medium,
          children: [
            SizedBox(
              width: double.maxFinite,
              height: 48,
              child: FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${widget.title}...',
                        ),
                      ),
                    );
                  }
                  final inputAssignment = Assignment(
                    assignment_id: 0,
                    title: _assignmentTitleController.text,
                    description: _assignmentDescriptionController.text,
                    due_at: DateTime.parse(_assignmentDueAtController.text),
                    max_score: double.parse(_assignmentMaxScoreController.text),
                    assignment_type: _assignmentType,
                    time_bound: _assignmentTimeBound,
                    allow_resubmit: _assignmentAllowResubmit,
                    class_id: 0,
                    class_name: '',
                  );
                  setState(() {
                    widget.title.toLowerCase().contains('create') && widget.assignment == null
                        ? _assignmentRepository.createAssignment(assignment: inputAssignment)
                        : _assignmentRepository.updateAssignment(
                            assignment_id: widget.assignment!.assignment_id,
                            assignment: inputAssignment,
                          );
                  });
                },
                child: Text(
                  widget.title,
                ),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              height: 48,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
  lastDate ??= firstDate.add(const Duration(days: 365 * 200));

  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (selectedDate == null) return null;

  if (!context.mounted) return selectedDate;

  final TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
  );

  return selectedTime == null
      ? selectedDate
      : DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
}
