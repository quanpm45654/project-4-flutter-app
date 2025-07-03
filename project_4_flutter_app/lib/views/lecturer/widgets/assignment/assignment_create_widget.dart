import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/assignment.dart';
import 'package:project_4_flutter_app/repositories/assignment_repository.dart';
import 'package:project_4_flutter_app/utils/enums.dart';
import 'package:project_4_flutter_app/utils/functions.dart';
import 'package:project_4_flutter_app/utils/validator.dart';
import 'package:provider/provider.dart';

class AssignmentCreateWidget extends StatefulWidget {
  const AssignmentCreateWidget({super.key, required this.class_id});

  final int class_id;

  @override
  State<AssignmentCreateWidget> createState() => _AssignmentCreateWidgetState();
}

class _AssignmentCreateWidgetState extends State<AssignmentCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final _assignmentTitle = TextEditingController();
  final _assignmentDescription = TextEditingController();
  final _assignmentDueAt = TextEditingController();
  final _assignmentMaxScore = TextEditingController();
  AssignmentType? _assignmentType = AssignmentType.individual;
  var _assignmentTimeBound = false;
  var _assignmentAllowResubmit = false;
  final _assignmentFileUrl = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var assignmentRepository = Provider.of<AssignmentRepository>(context);

    return assignmentRepository.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: buildForm(context),
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.surfaceContainer,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 16.0,
                  children: [
                    buildSubmitButton(assignmentRepository, context),
                    buildCancelButton(context),
                  ],
                ),
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
          const SizedBox(),
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
        border: OutlineInputBorder(),
        label: Text('Assignment title*'),
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value, 'Assignment title'),
        CustomValidator.maxLength(value, 255),
      ]),
    );
  }

  TextFormField buildDescriptionField() {
    return TextFormField(
      controller: _assignmentDescription,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
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
        border: OutlineInputBorder(),
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
        border: OutlineInputBorder(),
        label: Text('Max score*'),
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value, 'Max score'),
        CustomValidator.number(value),
        CustomValidator.minValue(value, 0),
      ]),
    );
  }

  Column buildTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Assignment type'),
        const SizedBox(height: 8.0),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Radio<AssignmentType>(
            value: AssignmentType.individual,
            groupValue: _assignmentType,
            onChanged: (AssignmentType? value) {
              setState(() {
                _assignmentType = value;
              });
            },
          ),
          title: const Text('Individual'),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Radio<AssignmentType>(
            value: AssignmentType.group,
            groupValue: _assignmentType,
            onChanged: (AssignmentType? value) {
              setState(() {
                _assignmentType = value;
              });
            },
          ),
          title: const Text('Group'),
        ),
      ],
    );
  }

  TextFormField buildFileUrlField() {
    return TextFormField(
      controller: _assignmentFileUrl,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        label: Text('File url*'),
      ),
      validator: (value) => CustomValidator.combine([
        CustomValidator.required(value, 'File url'),
      ]),
    );
  }

  ListTile buildTimeBoundField() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Checkbox(
        value: _assignmentTimeBound,
        onChanged: (value) =>
            setState(() => _assignmentTimeBound = value ?? false),
      ),
      title: const Text('Time bound'),
    );
  }

  ListTile buildAllowResubmitField() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Checkbox(
        value: _assignmentAllowResubmit,
        onChanged: (value) =>
            setState(() => _assignmentAllowResubmit = value ?? false),
      ),
      title: const Text('Allow resubmit'),
    );
  }

  SizedBox buildSubmitButton(
    AssignmentRepository assignmentRepository,
    BuildContext context,
  ) {
    return SizedBox(
      width: double.maxFinite,
      child: FilledButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var assignment_id = 0;
            var title = _assignmentTitle.text;
            var description = _assignmentDescription.text;
            var due_at = DateTime.parse(_assignmentDueAt.text);
            var max_score = double.parse(_assignmentMaxScore.text);
            var assignment_type = _assignmentType ?? AssignmentType.individual;
            var time_bound = _assignmentTimeBound;
            var allow_resubmit = _assignmentAllowResubmit;
            var class_id = widget.class_id;
            var file_url = _assignmentFileUrl.text;

            var inputAssignment = Assignment(
              assignment_id,
              title,
              description,
              due_at,
              max_score,
              assignment_type,
              time_bound,
              allow_resubmit,
              class_id,
              file_url,
            );

            await assignmentRepository.createAssignment(inputAssignment);

            if (context.mounted) {
              if (assignmentRepository.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Assignment created successfully'),
                    showCloseIcon: true,
                  ),
                );
                Navigator.pop(context);
              } else if (assignmentRepository.errorMessageSnackBar.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(assignmentRepository.errorMessageSnackBar),
                    showCloseIcon: true,
                  ),
                );
                Navigator.pop(context);
              }
            }
          }
        },
        child: const Text('Create assignment'),
      ),
    );
  }

  SizedBox buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    );
  }
}
