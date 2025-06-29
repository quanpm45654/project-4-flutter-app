import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/utils/enums.dart';
import 'package:project_4_flutter_app/utils/functions.dart';
import 'package:project_4_flutter_app/utils/validator.dart';
import 'package:provider/provider.dart';

class AssignmentCreateWidget extends StatefulWidget {
  const AssignmentCreateWidget({super.key, required this.class_id});

  final num class_id;

  @override
  State<AssignmentCreateWidget> createState() => _AssignmentCreateWidgetState();
}

class _AssignmentCreateWidgetState extends State<AssignmentCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final _assignmentTitle = TextEditingController();
  final _assignmentDescription = TextEditingController();
  final _assignmentDueAt = TextEditingController();
  final _assignmentMaxScore = TextEditingController();
  AssignmentType _assignmentType = AssignmentType.individual;
  bool _assignmentTimeBound = false;
  bool _assignmentAllowResubmit = false;
  final _assignmentFileUrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final assignmentRepository = Provider.of<AssignmentRepository>(context);

    return assignmentRepository.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            spacing: 32.0,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: buildForm(context),
                ),
              ),
              Column(
                spacing: 16.0,
                children: [
                  buildSubmitButton(assignmentRepository, context),
                  buildCancelButton(context),
                ],
              ),
            ],
          );
  }

  Form buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          const SizedBox(
            height: 8,
          ),
          buildTitleField(),
          buildDescriptionField(),
          buildDueAtField(context),
          buildMaxScoreField(),
          buildTypeField(),
          buildFileUrlField(),
          buildTimeBoundField(),
          buildAllowResubmitField(),
        ],
      ),
    );
  }

  TextFormField buildTitleField() {
    return TextFormField(
      controller: _assignmentTitle,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        label: Text('Assignment title*'),
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value, 'Assignment title'),
      ]),
    );
  }

  TextFormField buildDescriptionField() {
    return TextFormField(
      controller: _assignmentDescription,
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

  TextFormField buildDueAtField(BuildContext context) {
    return TextFormField(
      controller: _assignmentDueAt,
      readOnly: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        label: Text('Due at*'),
        suffixIcon: Icon(Icons.calendar_month_rounded),
      ),
      onTap: () async {
        DateTime? date = await showDateTimePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 10),
        );

        date != null
            ? _assignmentDueAt.text = CustomFormatter.formatDateTime(date)
            : _assignmentDueAt.text = '';
      },
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value, 'Due at'),
      ]),
    );
  }

  TextFormField buildMaxScoreField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _assignmentMaxScore,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        label: Text('Max score*'),
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value, 'Max score'),
        CustomValidator.number(value),
      ]),
    );
  }

  DropdownButtonFormField<AssignmentType> buildTypeField() {
    return DropdownButtonFormField(
      items: AssignmentType.values.map((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value.name.toUpperCase()),
        );
      }).toList(),
      onChanged: (value) => _assignmentType = value ?? AssignmentType.individual,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        label: Text('Assignment type*'),
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value.toString(), 'Assignment type'),
      ]),
    );
  }

  TextFormField buildFileUrlField() {
    return TextFormField(
      controller: _assignmentFileUrl,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        label: Text('File url*'),
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value, 'File url'),
      ]),
    );
  }

  Row buildTimeBoundField() {
    return Row(
      children: [
        Checkbox(
          value: _assignmentTimeBound,
          onChanged: (value) => setState(() => _assignmentTimeBound = value ?? false),
        ),
        const Text(
          'Time bound',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Row buildAllowResubmitField() {
    return Row(
      children: [
        Checkbox(
          value: _assignmentAllowResubmit,
          onChanged: (value) => setState(() => _assignmentAllowResubmit = value ?? false),
        ),
        const Text(
          'Allow resubmit',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  SizedBox buildSubmitButton(AssignmentRepository assignmentRepository, BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 48,
      child: FilledButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final inputAssignment = Assignment(
              assignment_id: 0,
              title: _assignmentTitle.text,
              description: _assignmentDescription.text,
              due_at: DateTime.parse(_assignmentDueAt.text),
              max_score: double.parse(_assignmentMaxScore.text),
              assignment_type: _assignmentType,
              time_bound: _assignmentTimeBound,
              allow_resubmit: _assignmentAllowResubmit,
              class_id: widget.class_id,
              file_url: _assignmentFileUrl.text,
            );

            await assignmentRepository.createAssignment(assignment: inputAssignment);

            if (context.mounted) {
              if (assignmentRepository.errorMessageSnackBar.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Assignment created successfully',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    showCloseIcon: true,
                  ),
                );
                assignmentRepository.fetchClassAssignmentList(
                  class_id: widget.class_id,
                  lecturer_id: 2,
                );
                Navigator.pop(context);
              } else if (assignmentRepository.errorMessageSnackBar.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      assignmentRepository.errorMessageSnackBar,
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
          'Create assignment',
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
