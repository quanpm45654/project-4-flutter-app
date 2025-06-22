import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/class.dart';
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
      _classNameController.text = classObject.name;
      _classCodeController.text = classObject.code;
      _classDescriptionController.text = classObject.description;
      _classSemesterController.text = classObject.semester;
    }

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
                      controller: _classNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        label: Text('Class name*'),
                      ),
                      validator: (value) {
                        return Validator.combine([
                          Validator.required(value, 'Class name'),
                        ]);
                      },
                    ),
                    TextFormField(
                      controller: _classCodeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        label: Text('Code*'),
                      ),
                      validator: (value) {
                        return Validator.combine([
                          Validator.required(value, 'Code'),
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
                        return Validator.combine([
                          Validator.required(value, 'Description'),
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
                        return Validator.combine([
                          Validator.required(value, 'Semester'),
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
