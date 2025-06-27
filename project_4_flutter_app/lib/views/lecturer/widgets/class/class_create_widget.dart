import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/repositories/class_repository.dart';
import 'package:project_4_flutter_app/utils/validator.dart';

class ClassCreateWidget extends StatefulWidget {
  const ClassCreateWidget({super.key});

  @override
  State<ClassCreateWidget> createState() => _ClassCreateWidgetState();
}

class _ClassCreateWidgetState extends State<ClassCreateWidget> {
  final _classRepository = ClassRepository();
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();
  final _classCodeController = TextEditingController();
  final _classDescriptionController = TextEditingController();
  final _classSemesterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 32.0,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 16.0,
                children: [
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _classNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      label: Text('Class name*'),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(value, 'Class name'),
                      ]);
                    },
                  ),
                  TextFormField(
                    controller: _classCodeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      label: Text('Class code*'),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(value, 'Class code'),
                      ]);
                    },
                  ),
                  TextFormField(
                    controller: _classDescriptionController,
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
                    controller: _classSemesterController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      label: Text('Semester*'),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(value, 'Semester'),
                      ]);
                    },
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
                        content: Text('Creating class...'),
                      ),
                    );
                    final inputClass = Class(
                      class_id: 0,
                      class_code: _classCodeController.text,
                      class_name: _classNameController.text,
                      description: _classDescriptionController.text,
                      semester: _classSemesterController.text,
                      lecturer_id: 2,
                    );
                    _classRepository
                        .createClass(
                          classObject: inputClass,
                        )
                        .then((result) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Class created successfully'),
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
                  }
                },
                child: const Text('Create class'),
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
