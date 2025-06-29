import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/repositories/class_repository.dart';
import 'package:project_4_flutter_app/utils/validator.dart';
import 'package:provider/provider.dart';

class ClassCreateWidget extends StatefulWidget {
  const ClassCreateWidget({super.key});

  @override
  State<ClassCreateWidget> createState() => _ClassCreateWidgetState();
}

class _ClassCreateWidgetState extends State<ClassCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final _className = TextEditingController();
  final _classCode = TextEditingController();
  final _classDescription = TextEditingController();
  final _classSemester = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var classRepository = Provider.of<ClassRepository>(context);

    return classRepository.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: buildForm(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: Column(
                  spacing: 16.0,
                  children: [
                    buildSubmitButton(classRepository, context),
                    buildCancelButton(context),
                  ],
                ),
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
          const SizedBox(),
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
        border: OutlineInputBorder(),
        label: Text('Class name*'),
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value, 'Class name'),
        CustomValidator.maxLength(value, 100),
      ]),
    );
  }

  TextFormField buildCodeField() {
    return TextFormField(
      controller: _classCode,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        label: Text('Class code*'),
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value, 'Class code'),
        CustomValidator.maxLength(value, 50),
      ]),
    );
  }

  TextFormField buildDescriptionField() {
    return TextFormField(
      controller: _classDescription,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
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
        border: OutlineInputBorder(),
        label: Text('Semester*'),
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value, 'Semester'),
        CustomValidator.maxLength(value, 20),
      ]),
    );
  }

  SizedBox buildSubmitButton(ClassRepository classRepository, BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 48.0,
      child: FilledButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final inputClass = Class(
              class_id: 0,
              class_code: _classCode.text,
              class_name: _className.text,
              description: _classDescription.text,
              semester: _classSemester.text,
              lecturer_id: 2,
            );

            await classRepository.createClass(classObject: inputClass);

            if (context.mounted) {
              if (classRepository.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Class created successfully'),
                    showCloseIcon: true,
                  ),
                );
                Navigator.pop(context);
              } else if (classRepository.errorMessageSnackBar.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(classRepository.errorMessageSnackBar),
                    showCloseIcon: true,
                  ),
                );
                Navigator.pop(context);
              }
            }
          }
        },
        child: const Text('Create class'),
      ),
    );
  }

  SizedBox buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 48.0,
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    );
  }
}
