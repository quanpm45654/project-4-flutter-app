import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/teacher/models/class.dart';
import 'package:project_4_flutter_app/teacher/repositories/class_repository.dart';
import 'package:project_4_flutter_app/teacher/utils/shared_preference_service.dart';
import 'package:project_4_flutter_app/teacher/utils/validator.dart';
import 'package:provider/provider.dart';

class ClassCreateWidget extends StatefulWidget {
  const ClassCreateWidget({super.key});

  @override
  State<ClassCreateWidget> createState() => _ClassCreateWidgetState();
}

class _ClassCreateWidgetState extends State<ClassCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final _className = TextEditingController();
  final _code = TextEditingController();

  Future<void> createClass(
    ClassRepository classRepository,
    BuildContext context,
  ) async {
    int id = 0;
    String class_name = _className.text;
    int teacher_id = await SharedPreferenceService.getUserId() ?? 0;
    String code = _code.text;
    Class inputClass = Class(id, class_name, teacher_id, code);

    await classRepository.createClass(inputClass);

    if (context.mounted) {
      if (classRepository.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Class created successfully'),
            showCloseIcon: true,
          ),
        );
        Navigator.pop(context);
      } else {
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

  @override
  Widget build(BuildContext context) {
    final classRepository = Provider.of<ClassRepository>(context);

    return classRepository.isLoading
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
                        spacing: 16.0,
                        children: [
                          const SizedBox(),
                          TextFormField(
                            controller: _className,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Class name*'),
                            ),
                            validator: (value) => CustomValidator.combine([
                              CustomValidator.required(value, 'Class name'),
                              CustomValidator.maxLength(value, 100),
                            ]),
                          ),
                          TextFormField(
                            controller: _code,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Code*'),
                            ),
                            validator: (value) => CustomValidator.combine([
                              CustomValidator.required(value, 'Code'),
                              CustomValidator.maxLength(value, 10),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Theme.of(context).colorScheme.surfaceContainer,
                child: Column(
                  spacing: 16.0,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: FilledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            createClass(classRepository, context);
                          }
                        },
                        child: const Text('Create class'),
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
