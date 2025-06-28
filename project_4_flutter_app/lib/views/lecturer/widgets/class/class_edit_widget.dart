import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/repositories/class_repository.dart';
import 'package:project_4_flutter_app/utils/validator.dart';
import 'package:provider/provider.dart';

class ClassEditWidget extends StatefulWidget {
  const ClassEditWidget({super.key, required this.classObject});

  final Class classObject;

  @override
  State<ClassEditWidget> createState() => _ClassEditWidgetState();
}

class _ClassEditWidgetState extends State<ClassEditWidget> {
  final _formKey = GlobalKey<FormState>();
  final _className = TextEditingController();
  final _classCode = TextEditingController();
  final _classDescription = TextEditingController();
  final _classSemester = TextEditingController();

  @override
  void initState() {
    super.initState();
    _className.text = widget.classObject.class_name;
    _classCode.text = widget.classObject.class_code;
    _classDescription.text = widget.classObject.description;
    _classSemester.text = widget.classObject.semester;
  }

  @override
  Widget build(BuildContext context) {
    final classRepository = Provider.of<ClassRepository>(context);

    return classRepository.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            spacing: 32.0,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: buildForm(),
                ),
              ),
              Column(
                spacing: 16.0,
                children: [
                  buildSubmitButton(classRepository, context),
                  buildCancelButton(context),
                ],
              ),
            ],
          );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 16.0,
        children: [
          const SizedBox(height: 8.0),
          buildNameField(),
          buildCodeField(),
          buildDescriptionField(),
          buildSemesterField(),
        ],
      ),
    );
  }

  TextFormField buildNameField() {
    return TextFormField(
      controller: _className,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        label: Text('Class name*'),
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value, 'Class name'),
      ]),
    );
  }

  TextFormField buildCodeField() {
    return TextFormField(
      controller: _classCode,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        label: Text('Class code*'),
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value, 'Class code'),
      ]),
    );
  }

  TextFormField buildDescriptionField() {
    return TextFormField(
      controller: _classDescription,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        label: Text('Description*'),
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value, 'Description'),
      ]),
    );
  }

  TextFormField buildSemesterField() {
    return TextFormField(
      controller: _classSemester,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        label: Text('Semester*'),
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value, 'Semester'),
      ]),
    );
  }

  SizedBox buildSubmitButton(ClassRepository classRepository, BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 48,
      child: FilledButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final inputClass = Class(
              class_id: widget.classObject.class_id,
              class_code: _classCode.text,
              class_name: _className.text,
              description: _classDescription.text,
              semester: _classSemester.text,
              lecturer_id: 2,
            );

            await classRepository.updateClass(classObject: inputClass);

            if (context.mounted) {
              if (classRepository.errorMessageSnackBar.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Class edited successfully',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    showCloseIcon: true,
                  ),
                );
                Navigator.pop(context);
              } else if (classRepository.errorMessageSnackBar.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      classRepository.errorMessageSnackBar,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    showCloseIcon: true,
                  ),
                );
                Navigator.pop(context);
              }
            }
          }
        },
        child: const Text(
          'Edit class',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  SizedBox buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 48,
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'Cancel',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
