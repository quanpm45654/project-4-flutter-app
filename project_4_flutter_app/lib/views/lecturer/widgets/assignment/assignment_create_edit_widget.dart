import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _assignmentTitleController = TextEditingController();
  final _assignmentDescriptionController = TextEditingController();
  final _assignmentDueAtController = TextEditingController();
  final _assignmentMaxScoreController = TextEditingController();
  final _assignmentTypeController = TextEditingController();
  final _assignmentTimeBoundController = TextEditingController();
  final _assignmentAllowResubmitController = TextEditingController();
  final _assignmentClassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final assignment = widget.assignment;
    if (assignment != null) {
      _assignmentTitleController.text = assignment.title;
      _assignmentDescriptionController.text = assignment.description;
      _assignmentDueAtController.text = assignment.due_at.toString();
      _assignmentMaxScoreController.text = assignment.max_score.toString();
      _assignmentTypeController.text = assignment.assignment_type.toString();
      _assignmentTimeBoundController.text = assignment.time_bound.toString();
      _assignmentAllowResubmitController.text = assignment.allow_resubmit.toString();
      _assignmentClassController.text = assignment.class_name;
    }

    return Column(
      spacing: CustomSize.extraLarge,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                spacing: CustomSize.medium,
                children: [
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
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            CustomSize.medium,
                          ),
                        ),
                      ),
                      label: const Text(
                        'Due at*',
                      ),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          DateTime? date;
                          date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 10),
                            lastDate: DateTime(DateTime.now().year + 10),
                          );
                          date != null
                              ? _assignmentDueAtController.text = CustomFormatter.formatDateTime2(
                                  date,
                                )
                              : _assignmentDueAtController.text = '';
                        },
                        icon: const Icon(
                          Icons.calendar_month_rounded,
                        ),
                      ),
                    ),
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
                  TextFormField(
                    controller: _assignmentTypeController,
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
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(
                          value,
                          'Type',
                        ),
                      ]);
                    },
                  ),
                  TextFormField(
                    controller: _assignmentTimeBoundController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            CustomSize.medium,
                          ),
                        ),
                      ),
                      label: Text(
                        'Time bound*',
                      ),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(
                          value,
                          'Time bound',
                        ),
                      ]);
                    },
                  ),
                  TextFormField(
                    controller: _assignmentAllowResubmitController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            CustomSize.medium,
                          ),
                        ),
                      ),
                      label: Text(
                        'Allow resubmit*',
                      ),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(
                          value,
                          'Allow resubmit',
                        ),
                      ]);
                    },
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
                      const SnackBar(
                        content: Text(
                          'Processing Data',
                        ),
                      ),
                    );
                  }
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
