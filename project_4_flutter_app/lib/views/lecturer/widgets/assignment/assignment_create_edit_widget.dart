import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/utils/validator.dart';

class AssignmentCreateEditWidget extends StatefulWidget {
  const AssignmentCreateEditWidget({super.key, required this.title});

  final String title;

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
  final _assignmentTimeboundController = TextEditingController();
  final _assignmentAllowResubmitController = TextEditingController();
  final _assignmentClassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.0,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 16.0,
                  children: [
                    TextFormField(
                      controller: _assignmentTitleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        label: Text('Assignment title*'),
                      ),
                      validator: (value) {
                        return Validator.combine([
                          Validator.required(value, 'Assignment title'),
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
                        return Validator.combine([
                          Validator.required(value, 'Description'),
                        ]);
                      },
                    ),
                    TextFormField(
                      controller: _assignmentDueAtController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        label: Text('Due at*'),
                      ),
                      validator: (value) {
                        return Validator.combine([
                          Validator.required(value, 'Due at'),
                        ]);
                      },
                    ),
                    TextFormField(
                      controller: _assignmentMaxScoreController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        label: Text('Max score*'),
                      ),
                      validator: (value) {
                        return Validator.combine([
                          Validator.required(value, 'Max score'),
                        ]);
                      },
                    ),
                    TextFormField(
                      controller: _assignmentTypeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        label: Text('Type*'),
                      ),
                      validator: (value) {
                        return Validator.combine([
                          Validator.required(value, 'Type'),
                        ]);
                      },
                    ),
                    TextFormField(
                      controller: _assignmentTimeboundController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        label: Text('Time bound*'),
                      ),
                      validator: (value) {
                        return Validator.combine([
                          Validator.required(value, 'Time bound'),
                        ]);
                      },
                    ),
                    TextFormField(
                      controller: _assignmentAllowResubmitController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        label: Text('Allow resubmit*'),
                      ),
                      validator: (value) {
                        return Validator.combine([
                          Validator.required(value, 'Allow resubmit'),
                        ]);
                      },
                    ),
                    TextFormField(
                      controller: _assignmentClassController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        label: Text('Class*'),
                      ),
                      validator: (value) {
                        return Validator.combine([
                          Validator.required(value, 'Class'),
                        ]);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          width: 10000,
          child: FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              }
            },
            child: Text(widget.title),
          ),
        ),
      ],
    );
  }
}
