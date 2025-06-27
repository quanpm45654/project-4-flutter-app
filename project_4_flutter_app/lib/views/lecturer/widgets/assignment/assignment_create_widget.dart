import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/utils/enums.dart';
import 'package:project_4_flutter_app/utils/functions.dart';
import 'package:project_4_flutter_app/utils/validator.dart';

class AssignmentCreateWidget extends StatefulWidget {
  const AssignmentCreateWidget({super.key});

  @override
  State<AssignmentCreateWidget> createState() => _AssignmentCreateWidgetState();
}

class _AssignmentCreateWidgetState extends State<AssignmentCreateWidget> {
  final _assignmentRepository = AssignmentRepository();
  final _formKey = GlobalKey<FormState>();
  final _assignmentTitleController = TextEditingController();
  final _assignmentDescriptionController = TextEditingController();
  final _assignmentDueAtController = TextEditingController();
  final _assignmentMaxScoreController = TextEditingController();
  AssignmentType _assignmentType = AssignmentType.individual;
  bool _assignmentTimeBound = false;
  bool _assignmentAllowResubmit = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 32.0,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _assignmentTitleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      label: Text('Assignment title*'),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(value, 'Assignment title'),
                      ]);
                    },
                  ),
                  TextFormField(
                    controller: _assignmentDescriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      label: Text('Description*'),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(value, 'Description'),
                      ]);
                    },
                  ),
                  TextFormField(
                    controller: _assignmentDueAtController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      label: Text('Due at*'),
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
                          ? _assignmentDueAtController.text = CustomFormatter.formatDateTime(
                              date,
                            )
                          : _assignmentDueAtController.text = '';
                    },
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(value, 'Due at'),
                      ]);
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _assignmentMaxScoreController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      label: Text('Max score*'),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(value, 'Max score'),
                        CustomValidator.number(value),
                      ]);
                    },
                  ),
                  DropdownButtonFormField(
                    items: AssignmentType.values.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _assignmentType = value ?? AssignmentType.individual;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      label: Text('Assignment type*'),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(value.toString(), 'Assignment type'),
                      ]);
                    },
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
                ],
              ),
            ),
          ),
        ),
        Column(
          spacing: 16.0,
          children: [
            SizedBox(
              width: double.maxFinite,
              height: 48,
              child: FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Creating assignment...'),
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
                  );
                  _assignmentRepository
                      .createAssignment(assignment: inputAssignment)
                      .then((result) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Assignment created successfully'),
                            ),
                          );
                        }
                      })
                      .catchError((dynamic error) {
                        developer.log('${DateTime.now()}: $error');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('There was an error, please try again later'),
                            ),
                          );
                        }
                      });
                },
                child: const Text('Create assignment'),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              height: 48,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
