import 'package:flutter/material.dart';
import 'package:project_4_flutter_app/models/class.dart';
import 'package:project_4_flutter_app/repositories/class_repository.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_create_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_edit_page.dart';
import 'package:project_4_flutter_app/views/lecturer/pages/class/class_page.dart';
import 'package:provider/provider.dart';

class ClassListWidget extends StatefulWidget {
  const ClassListWidget({super.key});

  @override
  State<ClassListWidget> createState() => _ClassListWidgetState();
}

class _ClassListWidgetState extends State<ClassListWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Provider.of<ClassRepository>(
        context,
        listen: false,
      ).fetchClassList(2),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          buildCreateButton(context),
          const SizedBox(height: 16.0),
          buildConsumer(),
        ],
      ),
    );
  }

  SizedBox buildCreateButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 48.0,
      child: FilledButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const ClassCreatePage(),
          ),
        ),
        child: const Text('Create class'),
      ),
    );
  }

  Consumer<ClassRepository> buildConsumer() {
    return Consumer<ClassRepository>(
      builder: (context, classRepository, child) {
        if (classRepository.isLoading) {
          return const Flexible(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (classRepository.errorMessage.isNotEmpty) {
          return buildErrorMessage(classRepository, context);
        }

        if (classRepository.classList.isEmpty) {
          return const Flexible(
            child: Center(
              child: Text(
                "You haven't added any classes yet",
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        var classList = classRepository.classList;
        classList.sort((a, b) => b.class_id.compareTo(a.class_id));

        return Flexible(
          child: RefreshIndicator(
            onRefresh: () async => await classRepository.fetchClassList(2),
            child: buildClassListView(classRepository, classList),
          ),
        );
      },
    );
  }

  Flexible buildErrorMessage(
    ClassRepository classRepository,
    BuildContext context,
  ) {
    return Flexible(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              classRepository.errorMessage,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () async => await classRepository.fetchClassList(2),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildClassListView(
    ClassRepository classRepository,
    List<Class> classList,
  ) {
    return ListView.builder(
      itemCount: classRepository.classList.length,
      itemBuilder: (context, index) {
        var classObject = classList[index];

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => ClassPage(classObject: classObject),
            ),
          ),
          child: Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: const Icon(Icons.class_outlined),
              ),
              title: Text(
                classObject.class_name,
                style: const TextStyle(fontSize: 20.0),
              ),
              subtitle: Text(
                "${classObject.class_code} - ${classObject.semester}",
              ),
              trailing: MenuAnchor(
                builder: (context, controller, child) {
                  return IconButton(
                    onPressed: () {
                      controller.isOpen
                          ? controller.close()
                          : controller.open();
                    },
                    icon: const Icon(Icons.more_vert_rounded),
                  );
                },
                menuChildren: [
                  buildMenuEditButton(context, classObject),
                  buildMenuDeleteButton(context, classRepository, classObject),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  MenuItemButton buildMenuEditButton(BuildContext context, Class classObject) {
    return MenuItemButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => ClassEditPage(classObject: classObject),
        ),
      ),
      child: const Text('Edit'),
    );
  }

  MenuItemButton buildMenuDeleteButton(
    BuildContext context,
    ClassRepository classRepository,
    Class classObject,
  ) {
    return MenuItemButton(
      onPressed: () async =>
          await buildDeleteDialog(context, classRepository, classObject),
      child: Text(
        'Delete',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  Future<void> buildDeleteDialog(
    BuildContext context,
    ClassRepository classRepository,
    Class classObject,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete confirmation'),
          content: const Text('This class will be deleted forever'),
          actions: [
            buildCancelButton(context),
            buildDeleteButton(classRepository, classObject, context),
          ],
        );
      },
    );
  }

  TextButton buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Cancel'),
    );
  }

  TextButton buildDeleteButton(
    ClassRepository classRepository,
    Class classObject,
    BuildContext context,
  ) {
    return TextButton(
      onPressed: () async {
        await classRepository.deleteClass(classObject.class_id);

        if (context.mounted) {
          if (classRepository.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Class deleted successfully'),
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
      },
      child: Text(
        'Delete',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
