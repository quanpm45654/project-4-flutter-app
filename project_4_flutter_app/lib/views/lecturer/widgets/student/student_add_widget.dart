import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/utils/constants.dart';
import 'package:project_4_flutter_app/utils/validator.dart';

class StudentAddWidget extends StatefulWidget {
  const StudentAddWidget({super.key, required this.title});

  final String title;

  @override
  State<StudentAddWidget> createState() => _StudentAddWidgetState();
}

class _StudentAddWidgetState extends State<StudentAddWidget> {
  final _formKey = GlobalKey<FormState>();
  final _studentEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    controller: _studentEmailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            CustomSize.medium,
                          ),
                        ),
                      ),
                      label: Text(
                        'Student email',
                      ),
                    ),
                    validator: (value) {
                      return CustomValidator.combine([
                        CustomValidator.required(
                          value,
                          'Student email',
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
