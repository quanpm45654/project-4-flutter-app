import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/utils/validator.dart';

class ClassCreateEditWidget extends StatefulWidget {
  const ClassCreateEditWidget({super.key, required this.title, this.classObject});

  final String title;
  final Class? classObject;

  @override
  State<ClassCreateEditWidget> createState() => _ClassCreateEditWidgetState();
}

class _ClassCreateEditWidgetState extends State<ClassCreateEditWidget> {
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();
  final _classCodeController = TextEditingController();
  final _classDescriptionController = TextEditingController();
  final _classSemesterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final classObject = widget.classObject;
    if (classObject != null) {
      _classNameController.text = classObject.class_name;
      _classCodeController.text = classObject.class_code;
      _classDescriptionController.text = classObject.description;
      _classSemesterController.text = classObject.semester;
    }

    return Column(
      spacing: CustomSize.extraLarge,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                spacing: CustomSize.medium,
                children: [
                  TextFormField(
                    controller: _classNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            CustomSize.medium,
                          ),
                        ),
                      ),
                      label: Text(
                        'Class name*',
                      ),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(
                          value,
                          'Class name',
                        ),
                      ]);
                    },
                  ),
                  TextFormField(
                    controller: _classCodeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            CustomSize.medium,
                          ),
                        ),
                      ),
                      label: Text(
                        'Class code*',
                      ),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(
                          value,
                          'Class code',
                        ),
                      ]);
                    },
                  ),
                  TextFormField(
                    controller: _classDescriptionController,
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
                    controller: _classSemesterController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            CustomSize.medium,
                          ),
                        ),
                      ),
                      label: Text(
                        'Semester*',
                      ),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(
                          value,
                          'Semester',
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
                child: Text(widget.title),
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
