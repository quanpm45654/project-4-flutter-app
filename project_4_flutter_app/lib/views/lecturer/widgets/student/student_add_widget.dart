import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/utils/validator.dart';

class StudentAddWidget extends StatefulWidget {
  const StudentAddWidget({super.key});

  @override
  State<StudentAddWidget> createState() => _StudentAddWidgetState();
}

class _StudentAddWidgetState extends State<StudentAddWidget> {
  final _formKey = GlobalKey<FormState>();
  final _studentEmailController = TextEditingController();

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
                    controller: _studentEmailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      label: Text('Student email'),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(value, 'Student email'),
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
                        content: Text('Adding student...'),
                      ),
                    );
                  }
                },
                child: const Text('Add student'),
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
