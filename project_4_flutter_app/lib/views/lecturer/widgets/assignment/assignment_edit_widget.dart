import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/utils/enums.dart';
import 'package:project_4_flutter_app/utils/functions.dart';
import 'package:project_4_flutter_app/utils/validator.dart';
import 'package:provider/provider.dart';

class AssignmentEditWidget extends StatefulWidget {
  const AssignmentEditWidget({super.key, required this.assignment});

  final Assignment assignment;

  @override
  State<AssignmentEditWidget> createState() => _AssignmentEditWidgetState();
}

class _AssignmentEditWidgetState extends State<AssignmentEditWidget> {
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
  void initState() {
    super.initState();
    _assignmentTitle.text = widget.assignment.title;
    _assignmentDescription.text = widget.assignment.description ?? '';
    _assignmentDueAt.text = CustomFormatter.formatDateTime(widget.assignment.due_at);
    _assignmentMaxScore.text = widget.assignment.max_score.toString();
    _assignmentType = widget.assignment.assignment_type;
    _assignmentTimeBound = widget.assignment.time_bound;
    _assignmentAllowResubmit = widget.assignment.allow_resubmit;
    _assignmentFileUrl.text = widget.assignment.file_url ?? '';
  }

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
          const SizedBox(height: 8),
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
        DateTime? dateTime = await showDateTimePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 10),
        );

        dateTime != null
            ? _assignmentDueAt.text = CustomFormatter.formatDateTime(dateTime)
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
      value: widget.assignment.assignment_type,
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
              assignment_id: widget.assignment.assignment_id,
              title: _assignmentTitle.text,
              description: _assignmentDescription.text,
              due_at: DateTime.parse(_assignmentDueAt.text),
              max_score: double.parse(_assignmentMaxScore.text),
              assignment_type: _assignmentType,
              time_bound: _assignmentTimeBound,
              allow_resubmit: _assignmentAllowResubmit,
              class_id: widget.assignment.class_id,
              file_url: _assignmentFileUrl.text,
            );

            await assignmentRepository.updateAssignment(assignment: inputAssignment);

            if (context.mounted) {
              if (assignmentRepository.errorMessageSnackBar.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Assignment edited successfully',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    showCloseIcon: true,
                  ),
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
          'Edit assignment',
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
