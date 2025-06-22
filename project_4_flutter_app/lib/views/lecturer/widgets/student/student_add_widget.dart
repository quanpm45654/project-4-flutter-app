import 'package:flutter/material.dart';
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
                      controller: _studentEmailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        label: Text('Student email'),
                      ),
                      validator: (value) {
                        return Validator.combine([
                          Validator.required(value, 'Student email'),
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
